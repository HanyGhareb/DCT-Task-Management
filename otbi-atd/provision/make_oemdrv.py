#!/usr/bin/env python3
"""Build ONE Oracle Linux 9 OEMDRV kickstart ISO for a VM (otbi-atd scale-out).

  python make_oemdrv.py <hostname> <ip> <out.iso> [pubkey_file]

The ISO is labeled OEMDRV with /ks.cfg at the root, which Anaconda auto-loads (no
boot-arg edit). OS-level only (no app/runner software — deploy_worker.sh does that).
Network params + root password come from env vars (sensible lab defaults below).
Requires: pip install pycdlib.
"""
import os
import sys
import pycdlib

GATEWAY = os.environ.get("ATD_NET_GATEWAY", "192.168.1.1")
NETMASK = os.environ.get("ATD_NET_NETMASK", "255.255.255.0")
DNS     = os.environ.get("ATD_NET_DNS", "192.168.1.1,8.8.8.8")
ROOTPW  = os.environ.get("ATD_NEW_ROOT_PW", "changeme")
TZ      = os.environ.get("ATD_TZ", "Asia/Dubai")

KS = """#version=OL9
# Oracle Linux 9 unattended kickstart - host {host}
text
cdrom
eula --agreed
firstboot --disable
poweroff

lang en_US.UTF-8
keyboard --vckeymap=us
timezone {tz} --utc

network --bootproto=static --onboot=on --activate --ip={ip} --netmask={netmask} --gateway={gateway} --nameserver={dns} --hostname={host}
firewall --enabled --service=ssh

rootpw --plaintext {rootpw}
{sshkey_line}
selinux --enforcing

ignoredisk --only-use=sda
clearpart --all --initlabel --drives=sda
autopart --type=lvm
bootloader --location=mbr --boot-drive=sda

%packages --ignoremissing
@^minimal-environment
openssh-server
open-vm-tools
unzip
tar
%end

%post --log=/root/ks-post.log
systemctl enable sshd
systemctl enable vmtoolsd
%end
"""


def main():
    if len(sys.argv) < 4:
        sys.exit("usage: make_oemdrv.py <hostname> <ip> <out.iso> [pubkey_file]")
    host, ip, out = sys.argv[1], sys.argv[2], sys.argv[3]
    sshkey_line = ""
    if len(sys.argv) > 4 and os.path.exists(sys.argv[4]):
        key = open(sys.argv[4]).read().strip()
        sshkey_line = 'sshkey --username=root "%s"' % key
    ks = KS.format(host=host, ip=ip, netmask=NETMASK, gateway=GATEWAY, dns=DNS,
                   rootpw=ROOTPW, tz=TZ, sshkey_line=sshkey_line)
    ks_path = out + ".cfg"
    with open(ks_path, "w", newline="\n") as f:
        f.write(ks)
    iso = pycdlib.PyCdlib()
    iso.new(interchange_level=3, vol_ident="OEMDRV", joliet=3, rock_ridge="1.09")
    size = os.path.getsize(ks_path)
    with open(ks_path, "rb") as fp:
        iso.add_fp(fp, size, "/KS.CFG;1", rr_name="ks.cfg", joliet_path="/ks.cfg")
        iso.write(out)
    iso.close()
    print("built %s (label OEMDRV, ks for %s/%s)" % (out, host, ip))


if __name__ == "__main__":
    main()
