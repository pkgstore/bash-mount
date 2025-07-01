#!/usr/bin/env -S bash -euo pipefail
# -------------------------------------------------------------------------------------------------------------------- #
# MOUNT
# Mounting a file system using a script.
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera <mail@kai.kim>
# @license    MIT
# @version    0.1.0
# @link
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"; readonly SRC_DIR
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )"; readonly SRC_NAME
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf"

# Parameters.
declare -A MOUNT
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.list"

# Variables.
LOG="${SRC_DIR}/log.mount"

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function mnt() {
  for i in "${!MOUNT[@]}"; do
    if [[ ! -e "${i}" ]] || findmnt -M "${MOUNT[${i}]}"; then continue; fi
    mount "${i}" "${MOUNT[${i}]}"
  done
}

function main() {
  mnt 2>&1 | tee "${LOG}"
}; main "$@"
