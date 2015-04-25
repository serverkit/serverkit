# serverkit apply
`serverkit apply` is an executable action to execute migration process to fill-in the gaps
between the specified recipe and the state of the target host.

## Successful case
If no error was found, it returns exit status 0.

```
$ serverkit apply recipe.yml
[SKIP] homebrew mysql on localhost
[SKIP] homebrew redis on localhost
[SKIP] homebrew_cask licecap on localhost
[SKIP] homebrew_cask alfred on localhost
[DONE] git git@github.com:r7kamura/dotfiles.git on localhost
[DONE] symlink /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc on localhost
$ echo $?
0
```

## Failed case
If any error was found, it returns exit status 1.

```
$ serverkit apply recipe.yml
[SKIP] homebrew mysql on localhost
[SKIP] homebrew redis on localhost
[SKIP] homebrew_cask licecap on localhost
[SKIP] homebrew_cask alfred on localhost
[FAIL] git git@github.com:r7kamura/dotfiles.git on localhost
[DONE] symlink /Users/r7kamura/src/github.com/r7kamura/dotfiles/linked/.zshrc on localhost
$ echo $?
1
```

## --hosts= option
Use `--hosts=` option to execute serverkit over SSH.
Serverkit does not require any installation on server-side.
You can run serverkit on multiple hosts by passing hosts in comma-separated style.
If you want to specify SSH configuration, write it into your ~/.ssh/config.
This option is also available in `serverkit check` action.

```
$ serverkit apply recipe.yml --hosts=alpha.example.com
$ serverkit apply recipe.yml --hosts=alpha.example.com,bravo.example.com
$ serverkit apply recipe.yml --hosts=app1,app2,app3
```

## --log-level option
You can change serverkit log level by passing `--log-level=` option with
`DEBUG`, `ERROR`, `FATAL`, `WARN`, or `INFO` (case-insensitive, and the default is `INFO`).
For example, the general result lines like `[SKIP] ...` and `[ OK ] ...` are logged with FATAL level,
and all shell commands executed on hosts are logged with DEBUG level.
The log output is colored by default.
Pass `--no-color` option if you want to disable colored log outputs.

```
$ serverkit apply recipe.yml --hosts=alpha.example.com --log-level=debug --no-color
```
