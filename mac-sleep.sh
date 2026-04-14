#!/bin/bash

# Mac Sleep Control
# -----------------
# Disables/restores display and system sleep via pmset.
# Sufficient to prevent lock screen since lock triggers on display off OR screensaver.
# Disabling display sleep alone prevents the lock screen from appearing.
#
# Original values (confirmed 2026-03-28):
#   displaysleep = 60  (display sleeps after 60 mins on power adapter)
#   sleep        = 1   (system sleep enabled)
#
# Usage:
#   ./mac-sleep.sh disable   — turn off sleep (before long operations)
#   ./mac-sleep.sh restore   — put everything back to normal
#   ./mac-sleep.sh status    — read current values

case "$1" in
  disable)
    echo "Disabling sleep..."
    sudo pmset -a displaysleep 0
    sudo pmset -a sleep 0
    echo "Done. Remember to run './mac-sleep.sh restore' when finished."
    ;;
  restore)
    echo "Restoring original sleep settings..."
    sudo pmset -a displaysleep 60
    sudo pmset -a sleep 1
    echo "Done. Settings restored to original values."
    ;;
  status)
    sudo pmset -g | grep -E "displaysleep|^ sleep"
    ;;
  *)
    echo "Usage: $0 {disable|restore|status}"
    exit 1
    ;;
esac
