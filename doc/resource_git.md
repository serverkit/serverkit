# git
`git` is a resource to ensure a git repository exists on a remote host.

## Attributes
- path - where repository is cloned (required, type: `String`)
- repository - repository URL (required, type: `String`)
- state - whether it must be same revision with origin (`"cloned"` or `"updated"`, default: `"cloned"`)
- branch - branch name (type: `String`)

## Example
This recipe ensures a git repository is cloned from
`https://github.com/r7kamura/dotfiles.git` at
`/Users/r7kamura/src/github.com/r7kamura/dotfiles` on a remote host.

```yaml
resources:
  - type: git
    path: /Users/r7kamura/src/github.com/r7kamura/dotfiles
    repository: https://github.com/r7kamura/dotfiles.git
    state: updated
```
