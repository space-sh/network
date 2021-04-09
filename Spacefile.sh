#
# Copyright 2016-2017 Blockie AB
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
    SPACE_DEP="OS_IS_INSTALLED PRINT"       # shellcheck disable=SC2034
    PRINT "Checking for OS dependencies." "info"

    OS_IS_INSTALLED "nmap" "nmap"

    if [ "$?" -eq 0 ]; then
        PRINT "Dependencies found." "ok"
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
    SPACE_DEP="PRINT"           # shellcheck disable=SC2034

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
    SPACE_DEP="PRINT"               # shellcheck disable=SC2034
    SPACE_ENV="SUDO=\${SUDO-}"      # shellcheck disable=SC2034

    local address="${1-192.168.0.1}"
    shift $(( $# > 0 ? 1 : 0 ))

    PRINT "Scanning IP ${address}."

    local SUDO="${SUDO-}"
    ${SUDO} nmap -sS "${address}"
}

#=====================
# NETWORK_PORT_FREE
#
# Check if a port is free (or if a process is listening on it).
# This check is pretty crude and does not differ on interfaces.
#
# Parameters:
#   $1: Port number
#
# Returns:
#   1 if port is busy.
#   2 if no tool available to check if port is busy
#
#=====================
NETWORK_PORT_FREE()
{
    SPACE_SIGNATURE="port"
    SPACE_DEP="PRINT"

    local port="${1}"
    shift

    # Try sockstat first
    if command -v sockstat >/dev/null 2>&1; then
        sockstat 2>/dev/null | awk '{print $6}' | grep -q ":${port}\>"
        # Inherit status in return
        return
    fi

    # Now try netstat
    if command -v netstat >/dev/null 2>&1; then
        if netstat -tulpn 2>/dev/null | grep "LISTEN" | awk '{print $4}' | grep -q ":${port}\>"; then
            return 1
        fi
        return 0
    fi

    # Ok, let's try lsof
    if command -v lsof >/dev/null 2>&1; then
        if lsof -nP -iTCP -sTCP:LISTEN | grep -q ":${port}\>"; then
            return 1
        fi
        return 0
    fi

    PRINT "Listen, no sockstat, no netstat nor lsof found, cannot determine if port is busy or not" "debug"
    return 2
}

#=====================
# NETWORK_LOCAL_IP
#
# Get one of the local IP addresses present.
# It will sort all ipv4 inet addresses and take the largest, excluding gateways (ending with ".1").
#
# Parameters:
#   $1: Interface (optional)
#
# Returns:
#   Non-zero if not found
#   stdout has the address
#
#=====================
NETWORK_LOCAL_IP()
{
    local interface="${1:-}"

    # shellcheck disable=2086
    ifconfig ${interface:-} | grep -o "inet .*" | cut -d' ' -f 2 | grep ".*[.].*[.].*[.]1$" -v | sort | tail -n1
}
