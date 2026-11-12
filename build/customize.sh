#!/usr/bin/env bash
# Customize hook called by the build-libguestfs-image reusable workflow.
# Receives the qcow2 path as $1.
#
# Amazon Linux 2 cloud images (`amzn2-kvm-*.xfs.gpt.qcow2`) ship with
# cloud-init, openssh-server, GRUB2 with serial console wired, and the
# `ec2-user` default user pre-configured. The org-wide cloud-init
# policy drop-in (datasource_list, disable_root, ssh_pwauth=false,
# mount_default_fields) is injected by the reusable workflow AFTER
# this script runs. Customisation reduces to a dnf cache cleanup so
# the published qcow2 stays small.
#
# Note: AL2 is past AWS standard support (EOL 2025-06-30). We rebuild
# images for clients on AWS extended support; new deployments should
# use Amazon Linux 2023 (sibling repo open-img-cloud/amazon-linux-2023).

set -euo pipefail

QCOW2="${1:?usage: customize.sh <path-to-qcow2>}"

if [[ ! -f "$QCOW2" ]]; then
  echo "::error::qcow2 not found: $QCOW2" >&2
  exit 1
fi

echo "[customize] target: $QCOW2"

# Slow DHCP: network-scripts start dhclient with -1 (one attempt, 60 s
# timeout by default), so where DHCP takes longer (over 2 minutes measured
# in Infomaniak dc4-a) the instance never got IPv4 and SSH never opened.
# Keep dhclient running in the background (PERSISTENT_DHCLIENT, read from
# /etc/sysconfig/network by ifup-eth) and give it 5 minutes.
virt-customize -a "$QCOW2" \
  --run-command 'grep -q "^PERSISTENT_DHCLIENT=" /etc/sysconfig/network || echo "PERSISTENT_DHCLIENT=yes" >> /etc/sysconfig/network' \
  --run-command 'touch /etc/dhcp/dhclient.conf && (grep -q "^timeout " /etc/dhcp/dhclient.conf || echo "timeout 300;" >> /etc/dhcp/dhclient.conf)' \
  --run-command 'rm -rf /var/cache/dnf /var/cache/yum /tmp/* /var/tmp/*'

echo "[customize] done"
