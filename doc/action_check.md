# serverkit check
`serverkit check` is an executable action to show the difference between the specified recipe and
the state of the target host (a.k.a. "dry-run" in other tools).
Note that this action might do some destructive behaviors by resource implementations (e.g. `git fetch`).
This action takes the same options with `serverkit apply` action.
See [/doc/action_apply.md] for more details.

## Same case
If no difference was detected, it returns exit status 0.

```
$ serverkit check recipe.yml
[ OK ] homebrew mysql on localhost
[ OK ] homebrew redis on localhost
[ OK ] homebrew_cask licecap on localhost
[ OK ] homebrew_cask alfred on localhost
[ OK ] git git@github.com:r7kamura/dotfiles.git on localhost
[ OK ] symlink /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc on localhost
$ echo $?
0
```

## Different case
If any difference was detected, it returns exit status 1.

```
$ serverkit check recipe.yml
[ OK ] homebrew mysql on localhost
[ OK ] homebrew redis on localhost
[ OK ] homebrew_cask licecap on localhost
[ OK ] homebrew_cask alfred on localhost
[ NG ] git git@github.com:r7kamura/dotfiles.git on localhost
[ NG ] symlink /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc on localhost
$ echo $?
1
```
