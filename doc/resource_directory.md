# directory
`directory` is a resource to manage a directory on file system.

## Attributes
- group - directory group (type: `String`)
- mode - directory mode (type: `Integer`)
- owner - directory owner (type: `String`)
- path - directory path (required, type: `String`)

## Example
This recipe ensures the `/home/foo/.ssh` on remote host exists,
and its mode is `700`, and it is owned by user `foo`.

```yaml
resources:
  - type: directory
    path: /home/foo/.ssh
    mode: 700
    owner: foo
```
