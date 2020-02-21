# Network module | [![build status](https://gitlab.com/space-sh/network/badges/master/pipeline.svg)](https://gitlab.com/space-sh/network/commits/master)

Provides operations for inspecting IPs, services and devices on local network.



## /discover/
	Discover devices

	Discover devices on a local network given an IP address range.
	


## /portscan/
	Port scanning

	Scan for open ports on specific IP address.
	


# Functions 

## NETWORK\_DEP\_INSTALL ()  
  
  
  
Check dependencies for this module.  
  
  
  
## NETWORK\_DISCOVER ()  
  
  
  
Discover devices on a local network given an IP address range.  
  
### Parameters:  
- $1: IP address. Default: 192.168.0.0/24  
  
### Returns:  
- Non-zero on failure.  
  
  
  
## NETWORK\_PORTSCAN ()  
  
  
  
Scan for open ports on specific IP address.  
  
### Parameters:  
- $1: IP address. Default: 192.168.0.1  
  
### Returns:  
- Non-zero on failure.  
  
  
  
