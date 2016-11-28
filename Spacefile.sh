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
