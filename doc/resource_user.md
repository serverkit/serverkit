# user
`user` is a resource to ensure a user exists on remote host.

## Attributes
- gid - group gid (type: `Integer` or `String`)
- home - path to home directory (type: `String`)
- name - user name (required, type: `String`)
- password - user raw password (type: `String`, will be encrypted with SHA512)
- shell - log-in shell (type: `String`)
- system - pass `true` to make system user (`true` or `false`, default: `false`)
- uid - user uid (type: `Integer`)

## Example
This recipe ensures a user `foo` exists on remote host.

```yaml
resources:
  - type: user
    name: foo
```
