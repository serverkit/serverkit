# package
`package` is a resource to ensure a specified package is installed
using the main package system on the target host OS (e.g. `yum`, `apt`, `homebrew`, ...).

## Attributes
- name - package name (required, type: `String`, e.g. `"nginx"`)
- options - additional command lien options (type: `String`, e.g. `"--HEAD"`)
- version - package version (type: `String`, some package systems don't support this)

## Example
This is an example recipe to install `mysql` and `nginx`.

```yaml
resources:
  - type: package
    name: mysql
  - type: package
    name: nginx
```
