#!/bin/bash
# otbi-atd : provision ONE new OL9 VM on standalone ESXi (scale-out helper, Plan 1 generalised).
#   ./provision_vm.sh <hostname> <ip>
# Builds the VM's OEMDRV kickstart ISO, uploads it + creates/boots the VM over SSH to the
# ESXi host, waits for the unattended install to power off, detaches the install media, and
# boots the finished OS. Then run deploy_worker.sh <ip> to turn it into a worker.
#
# Config via env vars (defaults suit the current lab):
#   ATD_ESXI=192.168.1.190  ATD_ESXI_PW=...   ESXi host + root password
#   ATD_DATASTORE=datastore1   ATD_PORTGROUP="VM Network"
#   ATD_OL_ISO=/vmfs/volumes/datastore1/ISO_images/Linux9.7/OracleLinux-R9-U7-x86_64-dvd-20251119.iso
#   ATD_SSH_PUBKEY=/c/tmp/atd-provision/keys/atd_id_ed25519.pub   (injected for root login)
#   ATD_NET_GATEWAY/NETMASK/DNS, ATD_NEW_ROOT_PW   (consumed by make_oemdrv.py)
# Requires plink/pscp (PuTTY) or ssh/scp with sshpass; here we use plink/pscp like Plan 1.
set -euo pipefail
HOST="${1:?usage: provision_vm.sh <hostname> <ip>}"
IP="${2:?usage: provision_vm.sh <hostname> <ip>}"
SELF="$(cd "$(dirname "$0")" && pwd)"
ESXI="${ATD_ESXI:-192.168.1.190}"
ESXI_PW="${ATD_ESXI_PW:?set ATD_ESXI_PW (ESXi root password)}"
DS="${ATD_DATASTORE:-datastore1}"
PG="${ATD_PORTGROUP:-VM Network}"
OL_ISO="${ATD_OL_ISO:-/vmfs/volumes/$DS/ISO_images/Linux9.7/OracleLinux-R9-U7-x86_64-dvd-20251119.iso}"
PUBKEY="${ATD_SSH_PUBKEY:-/c/tmp/atd-provision/keys/atd_id_ed25519.pub}"
PLINK="${PLINK:-/c/Program Files/PuTTY/plink}"; PSCP="${PSCP:-/c/Program Files/PuTTY/pscp.exe}"
ESH(){ "$PLINK" -ssh -batch -pw "$ESXI_PW" root@"$ESXI" "$1"; }

WORK="$(mktemp -d)"; OEMDRV="$WORK/oemdrv_${HOST}.iso"
echo "[provision $HOST/$IP] building OEMDRV kickstart ISO…"
python "$SELF/make_oemdrv.py" "$HOST" "$IP" "$OEMDRV" "$PUBKEY"
DSDIR="/vmfs/volumes/$DS/ISO_images/Linux9.7"
"$PSCP" -batch -pw "$ESXI_PW" -scp "$OEMDRV" root@"$ESXI":"$DSDIR/oemdrv_${HOST}.iso"

echo "[provision $HOST] creating VM on ESXi…"
VMDIR="/vmfs/volumes/$DS/$HOST"
ESH "mkdir -p '$VMDIR'; vmkfstools -c 50G -d thin '$VMDIR/$HOST.vmdk'"
ESH "cat > '$VMDIR/$HOST.vmx' <<EOF
config.version = \"8\"
virtualHW.version = \"13\"
displayName = \"$HOST\"
guestOS = \"oraclelinux7-64\"
numvcpus = \"2\"
memSize = \"6144\"
firmware = \"bios\"
bios.bootOrder = \"cdrom,hdd\"
scsi0.present = \"TRUE\"
scsi0.virtualDev = \"pvscsi\"
scsi0:0.present = \"TRUE\"
scsi0:0.deviceType = \"scsi-hardDisk\"
scsi0:0.fileName = \"$HOST.vmdk\"
ethernet0.present = \"TRUE\"
ethernet0.virtualDev = \"vmxnet3\"
ethernet0.networkName = \"$PG\"
ethernet0.addressType = \"generated\"
sata0.present = \"TRUE\"
sata0:0.present = \"TRUE\"
sata0:0.deviceType = \"cdrom-image\"
sata0:0.fileName = \"$OL_ISO\"
sata0:0.startConnected = \"TRUE\"
sata0:1.present = \"TRUE\"
sata0:1.deviceType = \"cdrom-image\"
sata0:1.fileName = \"$DSDIR/oemdrv_${HOST}.iso\"
sata0:1.startConnected = \"TRUE\"
tools.syncTime = \"TRUE\"
EOF"
VMID="$(ESH "vim-cmd solo/registervm '$VMDIR/$HOST.vmx'" | tr -dc '0-9')"
echo "[provision $HOST] vmid=$VMID — powering on (unattended install)…"
ESH "vim-cmd vmsvc/power.on $VMID" >/dev/null

echo "[provision $HOST] waiting for install to finish (VM powers off when done)…"
until ESH "vim-cmd vmsvc/power.getstate $VMID" | grep -qi 'Powered off'; do sleep 20; done

echo "[provision $HOST] detaching install media + booting the OS…"
ESH "sed -i '/^sata0:0/d; /^sata0:1/d' '$VMDIR/$HOST.vmx'; vim-cmd vmsvc/reload $VMID; vim-cmd vmsvc/power.on $VMID" >/dev/null
rm -rf "$WORK"
echo "[provision $HOST] DONE. Next: deploy_worker.sh $IP"
