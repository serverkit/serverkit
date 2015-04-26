# command
`command` is a resource to execute a command on target hosts.
This resource takes a shell script to be executed.

## Attributes
- script - shell script to be executed (required, type: `String`)

## Example
This recipe ensures the login shell to be `/bin/zsh` on Mac OS X.
Note that `check_script` attribute (* this attribute is available on all resources)
is used to check if the current login shell is configured with `/bin/zsh` by `finger` command.

```yaml
resources:
  - type: command
    check_script: "finger -l | grep -E 'Shell: /bin/zsh$'"
    script: chsh -s /bin/zsh <%= ENV["USER"] %>
```
