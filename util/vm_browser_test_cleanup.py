#!/usr/bin/env python3
"""VM191 only: reap overdue allowlisted tests and their current descendants.

Dry-run by default. Never matches a browser by its name alone. Orphan browsers
without a surviving allowlisted test parent are deliberately left for review.
Uses pidfds so recycled process IDs cannot receive cleanup signals.
"""
import argparse
import fcntl
import os
from pathlib import Path
import signal
import socket
import time

TEST = Path('/root/DCT-Task-Management/final apps/GL/tests/fd_deep_browser.py')


def process(pid):
    try:
        base = Path('/proc') / str(pid)
        fields = (base / 'stat').read_text().rsplit(')', 1)[1].split()
        return {'pid': pid, 'ppid': int(fields[1]), 'start': int(fields[19])}
    except (OSError, ValueError, IndexError):
        return None


def matches(exe, argv, cwd):
    # Only direct invocation: python <exact test> [--bounded-child].
    return (Path(exe).name.startswith('python') and len(argv) >= 2
            and argv[1] != '-c' and argv[1] != '-m'
            and (Path(cwd) / argv[1]).resolve() == TEST
            and all(arg == '--bounded-child' for arg in argv[2:]))


def is_test(pid):
    try:
        base = Path('/proc') / str(pid)
        argv = (base / 'cmdline').read_bytes().rstrip(b'\0').decode().split('\0')
        return matches(os.readlink(base / 'exe'), argv, os.readlink(base / 'cwd'))
    except (OSError, UnicodeError):
        return False


def descendants(root, snapshot):
    ids = {root}
    while True:
        added = {p['pid'] for p in snapshot.values() if p['ppid'] in ids} - ids
        if not added:
            return ids
        ids.update(added)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    if socket.gethostname() != 'dev-vm':
        raise SystemExit('Refusing: this action is restricted to VM191 (dev-vm)')
    if not hasattr(os, 'pidfd_open') or not hasattr(signal, 'pidfd_send_signal'):
        raise SystemExit('pidfd support required; no unsafe PID-only fallback')
    with open('/run/lock/dct-browser-test-cleanup.lock', 'w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        snapshot = {}
        for entry in Path('/proc').iterdir():
            if entry.name.isdigit():
                item = process(int(entry.name))
                if item:
                    snapshot[item['pid']] = item
        uptime = float(Path('/proc/uptime').read_text().split()[0])
        ticks = os.sysconf('SC_CLK_TCK')
        handled = set()
        candidates = 0
        for root in sorted(snapshot.values(), key=lambda p: p['start']):
            age = uptime - root['start'] / ticks
            if root['pid'] in handled or age < 900 or not is_test(root['pid']):
                continue
            ids = descendants(root['pid'], snapshot)
            handled.update(ids)
            candidates += 1
            print(f"overdue_test pid={root['pid']} age_seconds={age:.0f} "
                  f"tree={sorted(ids)} apply={args.apply}", flush=True)
            if not args.apply:
                continue
            handles = []
            try:
                for pid in sorted(ids):
                    try:
                        fd = os.pidfd_open(pid)
                    except ProcessLookupError:
                        continue
                    current = process(pid)
                    if current is None or current['start'] != snapshot[pid]['start']:
                        os.close(fd)
                        continue
                    handles.append((pid, fd))
                if process(root['pid']) != root or not is_test(root['pid']):
                    print('Root changed/exited; skipping this tree', flush=True)
                    continue
                for pid, fd in handles:
                    try:
                        signal.pidfd_send_signal(fd, signal.SIGTERM)
                    except ProcessLookupError:
                        pass
                time.sleep(5)
                for pid, fd in handles:
                    try:
                        signal.pidfd_send_signal(fd, signal.SIGKILL)
                        print(f'kill_remaining pid={pid}', flush=True)
                    except ProcessLookupError:
                        pass
            finally:
                for _, fd in handles:
                    os.close(fd)
        print(f'candidate_tests={candidates} apply={args.apply}', flush=True)


if __name__ == '__main__':
    main()
