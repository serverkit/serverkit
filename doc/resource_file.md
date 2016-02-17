# file
`file` is a resource to manage a file on file system.

## Attributes
- content - file content (type: `String`). `remote_host` resource is recommended for complex content.
- group - file group (type: `String`)
- mode - file mode (type: `Integer`)
- owner - file owner (type: `String`)
- path - file path (required, type: `String`)

## Example
This recipe ensures a file exists at `/home/foo/.ssh/authorized_keys` on a remote host
with specified content, and its mode is `0600`, and its owner is user `foo`.

```yaml
resources:
  - type: file
    path: /home/foo/.ssh/authorized_keys
    content: ...
    mode: 0600
    owner: foo
```
