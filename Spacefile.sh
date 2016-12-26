#
# Copyright 2016 Blockie AB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Disable warning about indirectly checking status code
# shellcheck disable=SC2181

#=====================
# NETWORK_DEP_INSTALL
#
# Check dependencies for this module.
#
#=====================
NETWORK_DEP_INSTALL ()
{
    SPACE_CMDDEP="OS_IS_INSTALLED PRINT"    # shellcheck disable=SC2034
    PRINT "Checking for OS dependencies." "info"

    OS_IS_INSTALLED "nmap" "nmap"

    if [ "$?" -eq 0 ]; then
        PRINT "Dependencies found." "success"
    else
        PRINT "Failed finding dependencies." "error"
        return 1
    fi
}

#=====================
# NETWORK_DISCOVER
#
# Discover devices on a local network given an IP address range.
#
# Parameters:
#   $1: IP address. Default: 192.168.0.0/24
#
# Returns:
#   Non-zero on failure.
#
#=====================
NETWORK_DISCOVER ()
{
    # shellcheck disable=SC2034
    SPACE_SIGNATURE="address"
    SPACE_CMDDEP="PRINT"        # shellcheck disable=SC2034

    local address="${1:-192.168.0.0/24}"
    shift $(( $# > 0 ? 1 : 0 ))

    PRINT "Searching network: ${address}."

    nmap -sL "${address}" | grep '(.*)'
}

#=====================
# NETWORK_PORTSCAN
#
# Scan for open ports on specific IP address.
#
# Parameters:
#   $1: IP address. Default: 192.168.0.1
#
# Returns:
#   Non-zero on failure.
#
#=====================
NETWORK_PORTSCAN ()
{
    # shellcheck disable=SC2034
    SPACE_SIGNATURE="address"
    SPACE_CMDDEP="PRINT"            # shellcheck disable=SC2034
    SPACE_CMDENV="SUDO=\${SUDO-}"   # shellcheck disable=SC2034

    local address="${1-192.168.0.1}"
    shift $(( $# > 0 ? 1 : 0 ))

    PRINT "Scanning IP ${address}."

    local SUDO="${SUDO-}"
    ${SUDO} nmap -sS "${address}"
}

