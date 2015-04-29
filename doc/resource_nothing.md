# nothing
`nothing` is a resource to do nothing.
This is useful for handlers to run after other resources finished,
or useful for some debug use.
This resource always fails on check phase and succeeds on recheck phase.

## Attributes
No specific attributes for this resource,
but of course the default attributes are available on all resource types.

## Example
This is an example recipe to do nothing...

```yaml
resources:
  - type: nothing
```
