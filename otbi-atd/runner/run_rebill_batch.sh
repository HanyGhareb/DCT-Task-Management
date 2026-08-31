#!/bin/bash
# Detached SEQUENTIAL batch of full unattended AR_INVOICE_REBILL runs.
# One argument per payload file; each invoice gets its own ctl/screenshot dir
# and its own checkpointed saga, so a failure in one invoice never blocks the
# next and any failed invoice can be resumed individually.
set -o pipefail
# env.sh sets TNS_ADMIN="$HOME/wallet"; systemd-run has no $HOME, so pin it
# BEFORE sourcing -- the expansion happens at source time.
export HOME="${HOME:-/root}"
cd /root/otbi-atd/runner || exit 1
source /root/otbi-atd/env.sh >/dev/null 2>&1
BATCHLOG=/root/otbi-atd/runner/.ar_batch/batch.log
mkdir -p /root/otbi-atd/runner/.ar_batch
echo "BATCH-LAUNCH $(date '+%Y-%m-%d %H:%M:%S') host=$(hostname) invoices=$#" > "$BATCHLOG"
FAILED=0
for PAYLOAD in "$@"; do
  INV=$(basename "$PAYLOAD" .json); INV=${INV#payload_}
  CTL=/root/otbi-atd/runner/.ar_batch/$INV
  mkdir -p "$CTL"
  export ATD_ACTION_SHOT_DIR="$CTL"
  echo "START $INV $(date '+%H:%M:%S')" >> "$BATCHLOG"
  python -u step_ar_rebill.py "$PAYLOAD" --ctl "$CTL" --auto > "$CTL/run.log" 2>&1
  RC=$?
  echo "END $INV rc=$RC $(date '+%H:%M:%S')" >> "$BATCHLOG"
  [ $RC -ne 0 ] && FAILED=$((FAILED+1))
done
echo "BATCH-DONE failed=$FAILED $(date '+%Y-%m-%d %H:%M:%S')" >> "$BATCHLOG"
exit $FAILED
