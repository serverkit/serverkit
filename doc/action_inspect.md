# serverkit inspect
`serverkit inspect` is an executable action to show fully-expanded recipe content in JSON format.
This action is useful as your recipe grows to a large size with using variables, nested recipe, and so on.
You can specify your recipe by passing its path in the same way as the other actions.

## Example
```
$ serverkit inspect recipe.yml
{
  "resources": [
    {
      "type": "homebrew",
      "name": "mysql"
    },
    {
      "type": "homebrew",
      "name": "redis"
    },
    {
      "type": "homebrew_cask",
      "name": "licecap"
    },
    {
      "type": "homebrew_cask",
      "name": "alfred"
    },
    {
      "type": "git",
      "repository": "git@github.com:r7kamura/dotfiles.git",
      "path": "/Users/r7kamura/src/github.com/r7kamura/dotfiles"
    },
    {
      "type": "symlink",
      "source": "/Users/r7kamura/.zshrc",
      "destination": "/Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc"
    }
  ]
}
```
