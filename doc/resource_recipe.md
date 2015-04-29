# recipe
`recipe` is a resource to include other resources in a specified recipe.
You can use any recipe format the same way as normal recipe,
and of course variables are available in included recipes.
`serverkit inspect` action, that shows fully-expanded resources,
 might help you because nested recipes tend to become complex.

## Attributes
- path - path to an included recipe (required, type: `String`)

## Example
This is an example recipe to bundle other recipes

```yaml
resources:
  - type: recipe
    path: homebrew.json.erb
  - type: recipe
    path: dotfiles.yml
```
