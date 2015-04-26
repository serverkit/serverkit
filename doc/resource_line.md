# line
`line` is a resource to ensure a particular line is in a file,
or replace an existing line using regexp.

## Attributes
- path - file path on remote host (required, type: `String`)
- insert_after - regexp to specify where line will be inserted (type: `String`), prior last match
- insert_before - regexp to specify where line will be inserted (type: `String`), prior last match
- line - inserted line content (required, type: `String`)
- pattern - regexp to check if a line already exists or not (type: `String`)
- state - `"absent"` or `"present"` (default)
- validation_script - shell script to run before copying into place (type: `String`, Use `%{path}` in the command to indicate the current file to validate)

## Example
This recipe ensures a line `"%wheel ALL=(ALL) ALL"` is in `/etc/sudoers` before a line
matched with `Regexp.new("^#includedir")`, if no line matched with
`Regexp.new('%wheel +ALL=\(ALL\) ALL')` and `visudo -cf /path/to/tempfile` succeeded.

```yaml
resources:
  - type: line
    path: /etc/sudoers
    pattern: '%wheel +ALL=\(ALL\) ALL'
    line: "%wheel ALL=(ALL) ALL"
    insert_before: "^#includedir"
    validation_script: visudo -cf %{path}
```
