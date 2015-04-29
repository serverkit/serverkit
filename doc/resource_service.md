# service
`service` is a resource to manage services on remote hosts
by OS specific init systems (e.g. BSD init, systemd, upstart, ...).

## Attributes
- name - service name (required, type: `String`)

## Example
This is an example recipe to ensure `nginx` is running.

```yaml
resources:
  - type: service
    name: nginx
```
