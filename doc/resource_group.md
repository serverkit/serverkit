# group
`group` is a resource to ensure a group exists on a remote host.

## Attributes
- gid - group gid (type: `Integer`)
- name - group name (required, type: `String`)

## Example
This recipe ensures a group `staff` of gid `20` exists on a remote host.

```yaml
resources:
  - type: group
    gid: 20
    name: staff
```
