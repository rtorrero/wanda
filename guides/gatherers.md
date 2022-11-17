# Gatherers

## Introduction

Gatherers can be thought of as functions:

- they have a name
- they accept argument(s)
- they return a value, the gathered [Fact](./specification.md#facts)

Facts Gathering process in a nutshell

```
fact = gatherer(argument)
```

## Available Gatherers

Here's a collection of build-in gatherers, with information about how to use them.

| name                              | implementation          
| --------------------------------- | ------------------------------------------
| [`corosync.conf`](#corosyncconf)  | [trento-project/agent/../gatherers/corosyncconf.go](https://github.com/trento-project/agent/blob/main/internal/factsengine/gatherers/corosyncconf.go)
| [`hosts`](#hosts-etchosts)        | [trento-project/agent/../gatherers/hostsfile.go](https://github.com/trento-project/agent/blob/main/internal/factsengine/gatherers/hostsfile.go)

### corosync.conf

**Name:** `corosync.conf`

This gatherer allows accessing information contained in `/etc/corosync/corosync.conf`

```
corosync_related_fact = corosync.conf(some.argument)
```

Sample arguments
| name | Return value  
| ------------------------------------ | ------------------------------------------
| `totem.token` | extracted value from the config
| `totem.join` | extracted value from the config
| `nodelist.node.<node_index>.nodeid` | extracted value from the config
| `nodelist.node` | list of objects representing the nodes

Specification examples:

```yaml
facts:
  - name: corosync_token_timeout
    gatherer: corosync.conf
    argument: totem.token

  - name: corosync_join
    gatherer: corosync.conf
    argument: totem.join

  - name: corosync_node1id
    gatherer: corosync.conf
    argument: nodelist.node.0.nodeid

  - name: corosync_node2id
    gatherer: corosync.conf
    argument: nodelist.node.1.nodeid

  - name: corosync_nodes
    gatherer: corosync.conf
    argument: nodelist.node
```

For more information refer to [trento-project/agent/../gatherers/corosyncconf_test.go](https://github.com/trento-project/agent/blob/main/internal/factsengine/gatherers/corosyncconf_test.go)

### hosts (/etc/hosts)

This gatherer allows accessing the hostnames that are resolvable through `/etc/hosts`. It
does **not** use domain resolution in any way but instead directly parses the file.

It allows one argument to be specified or none at all:
 - When a hostname is provided as an argument, the gatherer will return an array of IPv4 and/or IPv6 addresses.
 - When no argument is provided, the gatherer will return a map with hostname as keys and arrays with IPv4 and/or IPv6 addresses.

Sample arguments
| name                                 | Return value          
| ------------------------------------ | --------------------------------------------------------
| `localhost`                          | list of IPs resolving `localhost` e.g. `["127.0.0.1", "::1"]`
| `node1`                              | list of IPs resolving `node1` e.g. `["172.22.0.1"]`
| `nil` or `""`                        | map with hostnames and IP addresses e.g. `{"localhost": ["127.0.0.1", "::1"], "node1": ["172.22.0.1"]}`

Specification examples:
```yaml
facts:
  - name: hosts_node1
    gatherer: hosts
    argument: node1
  
  - name: hosts_node2
    gatherer: hosts
    argument: node2

  - name: hsots_all
    gatherer: hosts

```

For more information refer to [trento-project/agent/../gatherers/hostsfile_test.go](https://github.com/trento-project/agent/blob/main/internal/factsengine/gatherers/hostsfile_test.go)
