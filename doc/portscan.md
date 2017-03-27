---
modulename: Network
title: /portscan/
giturl: gitlab.com/space-sh/network
weight: 200
---
# Network module: Port scan

Scan for open ports on specific _IP_ address.


## Example

```sh
space -m network /portscan/ -- "192.168.0.1"
```

Exit status code is expected to be 0 on success.
