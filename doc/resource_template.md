# template
`template` is a resource to transfer a file from client host to remote host
with expanding ERB template with given variables.

## Attributes
- destination - file path on remote machine (required, type: `String`)
- group - file group (type: `String`)
- mode - file mode (type: `Integer`)
- owner - file owner (type: `String`)
- source - file path on client machine (required, type: `String`)

## Example
This recipe ensures a file exists at `/home/foo/.ssh/authorized_keys` on remote host
with same content with a expanded result of `files/authorized_keys.erb`.

```yaml
resources:
  - type: template
    destination: /home/foo/.ssh/authorized_keys
    source: files/authorized_keys.erb
    mode: 0600
    owner: foo
```
