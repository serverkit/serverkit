# directory
`directory` is a resource to manage a directory on file system.

## Attributes
- group - directory group (type: `String`)
- mode - directory mode (type: `Integer`)
- owner - directory owner (type: `String`)
- path - directory path (required, type: `String`)

## Example
This recipe ensures a directory exists at `/home/foo/.ssh` on a remote host,
and its mode is `0700`, and it is owned by user `foo`.

```yaml
resources:
  - type: directory
    path: /home/foo/.ssh
    mode: 0700
    owner: foo
```
