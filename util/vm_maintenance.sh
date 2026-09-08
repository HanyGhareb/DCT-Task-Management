#!/usr/bin/env bash
# DCT VM maintenance runner.
#
# Safe defaults:
#   - read-only unless --apply is supplied;
#   - crash cleanup removes only files named exactly "vmcore" directly below
#     /var/crash/*/;
#   - the newest complete vmcore is always retained;
#   - vmcore-dmesg.txt and kexec-dmesg.log are never removed;
#   - only full dumps older than the retention period are eligible.
#
# Examples:
#   sudo ./vm_maintenance.sh status
#   sudo ./vm_maintenance.sh crash-dumps
#   sudo ./vm_maintenance.sh --apply --older-than 30 crash-dumps
#   sudo ./vm_maintenance.sh --apply all
set -Eeuo pipefail

readonly SCRIPT_NAME=${0##*/}
readonly CRASH_DIR=/var/crash
readonly LOCK_FILE=/run/lock/dct-vm-maintenance.lock

APPLY=0
OLDER_THAN_DAYS=30
ACTION=status

usage() {
  cat <<EOF
Usage: $SCRIPT_NAME [--apply] [--older-than DAYS] {status|crash-dumps|browser-tests|all}

  status        Show capacity and relevant service state; makes no changes.
  crash-dumps   List eligible old binary vmcores, or remove them with --apply.
  all           Run crash-dumps followed by status.
  browser-tests VM191 only: reap allowlisted GL tests older than 15 minutes.
                Separate opt-in action; never included in all.

Dry-run is the default. --apply is required for deletion.
The newest full vmcore and every text diagnostic are always retained.
EOF
}

log() {
  printf '%s %s\n' "$(date --iso-8601=seconds)" "$*"
}

die() {
  log "ERROR: $*" >&2
  exit 1
}

while (($#)); do
  case "$1" in
    --apply)
      APPLY=1
      ;;
    --older-than)
      shift
      (($#)) || die '--older-than requires a number of days'
      [[ $1 =~ ^[0-9]+$ ]] || die '--older-than must be a non-negative integer'
      OLDER_THAN_DAYS=$1
      ;;
    status|crash-dumps|browser-tests|all)
      ACTION=$1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
  shift
done

exec 9>"$LOCK_FILE"
flock -n 9 || die 'another maintenance run is active'

show_status() {
  log "host=$(hostname) action=status"
  df -h "$CRASH_DIR"
  du -sh "$CRASH_DIR"
  for service in atd-worker rpt-worker; do
    if systemctl list-unit-files "$service.service" --no-legend 2>/dev/null | grep -q .; then
      printf '%s=' "$service"
      systemctl is-active "$service" || true
    fi
  done
}

maintain_crash_dumps() {
  [[ -d $CRASH_DIR ]] || die "$CRASH_DIR does not exist"

  local newest=''
  local record path bytes epoch age_days
  local eligible_count=0
  local eligible_bytes=0
  local removed_count=0
  local removed_bytes=0
  local now_epoch
  local -a dumps=()

  now_epoch=$(date +%s)
  mapfile -t dumps < <(
    find "$CRASH_DIR" -mindepth 2 -maxdepth 2 -type f -name vmcore \
      -printf '%T@ %s %p\n' | sort -n
  )

  if ((${#dumps[@]} == 0)); then
    log 'no complete vmcore files found'
    return
  fi

  newest=${dumps[${#dumps[@]}-1]#* * }
  [[ $newest == "$CRASH_DIR"/*/vmcore ]] || die "unsafe newest path: $newest"
  log "retaining newest full dump: $newest"

  for record in "${dumps[@]}"; do
    epoch=${record%%.*}
    record=${record#* }
    bytes=${record%% *}
    path=${record#* }

    [[ $path == "$CRASH_DIR"/*/vmcore ]] || die "unsafe candidate path: $path"
    [[ ${path##*/} == vmcore ]] || die "unexpected candidate name: $path"
    [[ $path != "$newest" ]] || continue

    age_days=$(( (now_epoch - epoch) / 86400 ))
    ((age_days >= OLDER_THAN_DAYS)) || continue

    eligible_count=$((eligible_count + 1))
    eligible_bytes=$((eligible_bytes + bytes))
    log "eligible age_days=$age_days bytes=$bytes path=$path"

    if ((APPLY)); then
      rm -f -- "$path"
      [[ ! -e $path ]] || die "failed to remove $path"
      removed_count=$((removed_count + 1))
      removed_bytes=$((removed_bytes + bytes))
    fi
  done

  if ((APPLY)); then
    log "removed_count=$removed_count removed_bytes=$removed_bytes"
  else
    log "dry_run=1 eligible_count=$eligible_count eligible_bytes=$eligible_bytes"
    log 'rerun with --apply to remove the listed binary dumps'
  fi
}

case "$ACTION" in
  browser-tests)
    browser_helper=/usr/local/libexec/dct-vm-maintenance/vm_browser_test_cleanup.py
    if [[ ! -f $browser_helper ]]; then
      browser_helper="$(dirname -- "$(readlink -f -- "$0")")/vm_browser_test_cleanup.py"
    fi
    browser_args=()
    ((APPLY)) && browser_args+=(--apply)
    python3 "$browser_helper" "${browser_args[@]}"
    ;;
  status)
    show_status
    ;;
  crash-dumps)
    maintain_crash_dumps
    ;;
  all)
    maintain_crash_dumps
    show_status
    ;;
esac
