---
modulename: Network
title: /discover/
giturl: gitlab.com/space-sh/network
weight: 200
---
# Network module: Discover

Discover devices on a local network given an _IP_ address range.


## Example

```sh
space -m network /discover/ -- "192.168.0.0/24"
```

Exit status code is expected to be 0 on success.
