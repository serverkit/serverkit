# script
`script` is a resource to execute a script on target hosts.
This resource takes a shell script path to be executed.

## Attributes
- path - shell script path to be executed (required, type: `String`)

## Example

```yaml
resources:
  - type: script
    script: karabiner.sh
```
