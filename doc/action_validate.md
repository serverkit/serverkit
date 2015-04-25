# serverkit validate
`serverkit validate` is an executable action to check if a specified recipe is valid or not.
You can specify your recipe by passing its path in the same way as the other actions.
Note that the other actions (e.g. `inspect`, `check`, `apply`) also runs validation before its task.

## Successful case
If no error found, it returns exit status 0.

```
$ serverkit validate recipe.yml
$ echo $?
0
```

## Failed case
If any error found, it reports errors and returns exit status 1.

```
$ serverkit validate recipe.yml
Error: source attribute is required in remote_file resource
Error: path attribute can't be unreadable path in recipe resource
$ echo $?
1
```
