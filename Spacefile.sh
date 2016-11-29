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

NETWORK_DEP_INSTALL ()
{
    SPACE_CMDDEP="OS_IS_INSTALLED PRINT"
    PRINT "Checking for OS dependencies." "info"

    OS_IS_INSTALLED "nmap" "nmap"

    if [ "$?" -eq 0 ]; then
        PRINT "Dependencies found." "success"
    else
        PRINT "Failed finding dependencies." "error"
        return 1
    fi
}

NETWORK_DISCOVER ()
{
    SPACE_SIGNATURE="address"
    SPACE_CMDDEP="PRINT"

    local address="${1:-192.168.0.0/24}"
    shift $(( $# > 0 ? 1 : 0 ))

    PRINT "Searching network: ${address}."

    nmap -sL ${address} | grep '(.*)'
}

NETWORK_PORTSCAN ()
{
    SPACE_SIGNATURE="address"
    SPACE_CMDDEP="PRINT"
    SPACE_CMDENV="SUDO=\${SUDO-}"

    local address="${1-192.168.0.1}"
    shift $(( $# > 0 ? 1 : 0 ))

    PRINT "Scanning IP ${address}."

    local SUDO="${SUDO-}"
    ${SUDO} nmap -sS ${address}
}
