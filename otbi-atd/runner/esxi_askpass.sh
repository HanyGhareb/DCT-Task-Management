#!/bin/sh
# OpenSSH SSH_ASKPASS helper for the fleet's ESXi power-reset recovery
# (runner.py _esxi_reset). Prints the ESXi password from the environment
# (ATD_ESXI_PWD, overlaid from ATD_RUNNER_CONFIG at worker startup).
# No sshpass/paramiko needed on the VMs.
echo "$ATD_ESXI_PWD"
