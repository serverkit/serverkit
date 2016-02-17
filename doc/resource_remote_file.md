# remote_file
`remote_file` is a resource to transfer a file from a client machine to a remote machine.

## Attributes
- destination - file path on remote machine (required, type: `String`)
- group - file group (type: `String`)
- mode - file mode (type: `Integer`)
- owner - file owner (type: `String`)
- source - file path on client machine (required, type: `String`)

## Example
This recipe ensures a file exists at `/home/foo/.ssh/authorized_keys` on a remote host
with same content with `files/authorized_keys` on a client side.

```yaml
resources:
  - type: remote_file
    destination: /home/foo/.ssh/authorized_keys
    source: files/authorized_keys
    mode: 0600
    owner: foo
```
