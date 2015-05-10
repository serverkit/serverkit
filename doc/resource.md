# Resource
A resource is a statement of configuration policy that describes the desired state for an item.

## Attributes
Each resource has different attributes along with its type.
By default, all types of resource can or must have the following attributes:

- type - what type this resource represents (required)
- check_script - pass shell script to override the `#check` phase
- cwd - pass current working directory path
- id - change resource identifier used in log, and also used for `notify`
- notify - specify an Array of handler ids that should be applied after changed
- recheck_script - pass shell script to override the `#recheck` phase (runned after `#apply`)
- user - specify user who executes commands on remote machine

## Example
Here is a tiny example recipe that has only one resource with `type` and `name` attributes.
It desceibes that there must be a mysql package in the target machine.

```yml
resources:
  - type: package
    name: mysql
```
