# symlink
`symlink` is a resource to ensure a symlink exists with specified source and destination.

## Attributes
- destination - symlink destination path on remote host (required, type: `String`)
- source - symlink source path on remote host (required, type: `String`)

## Example
This is an example recipe to ensure a symlink in remote host
from `/Users/foo/.bashrc` to `/Users/foo/dotfiles/.bashrc`.

```yaml
resources:
  - type: symlink
    destination: /Users/foo/dotfiles/.bashrc
    source: /Users/foo/.bashrc
```
