import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location('cleanup', Path(__file__).with_name('vm_browser_test_cleanup.py'))
cleanup = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cleanup)


class ScopeTests(unittest.TestCase):
    def test_exact_test_allowed(self):
        self.assertTrue(cleanup.matches('/usr/bin/python3.9',
            ['python', str(cleanup.TEST), '--bounded-child'], '/tmp'))

    def test_relative_test_allowed(self):
        self.assertTrue(cleanup.matches('/usr/bin/python3.9',
            ['python', 'final apps/GL/tests/fd_deep_browser.py'], '/root/DCT-Task-Management'))

    def test_unrelated_processes_excluded(self):
        for exe, argv in [
            ('chrome-headless', ['chrome', str(cleanup.TEST)]),
            ('python3', ['python', '/root/otbi-atd/runner/runner.py']),
            ('python3', ['python', '-c', str(cleanup.TEST)]),
            ('python3', ['python', '/tmp/fd_deep_browser.py']),
            ('python3', ['python', str(cleanup.TEST), '--unrecognized'])]:
            self.assertFalse(cleanup.matches(exe, argv, '/tmp'))

    def test_only_own_descendants(self):
        snapshot = {1: {'pid': 1, 'ppid': 0}, 10: {'pid': 10, 'ppid': 1},
                    11: {'pid': 11, 'ppid': 10}, 12: {'pid': 12, 'ppid': 11},
                    20: {'pid': 20, 'ppid': 1}}
        self.assertEqual(cleanup.descendants(10, snapshot), {10, 11, 12})


if __name__ == '__main__':
    unittest.main()
