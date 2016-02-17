## 0.6.7
- Use /bin/bash with -i option on command execution with user option

## 0.6.6
- Fix bug on `service` resource

## 0.6.5
- Use `sudo -H` option

## 0.6.4
- Fix has_correct_group?

## 0.6.3
- Add :request_pty option on SSH backend

## 0.6.2
- Add AtLeastOneOfValidator

## 0.6.1
- Move to home directory if user attribute is specified

## 0.6.0
- Add `cwd` and `user` attributes on all resources

## 0.5.1
- Fix user resource behavior on nil password case

## 0.5.0
- Add validation_script attribute on line resource

## 0.4.9
- Add insert_after, insert_before, and pattern attributes on line resource
- Rescue YAML parse error on recipe loading phase

## 0.4.8
- Add line resource

## 0.4.7
- Add a patch for vagrant-serverkit

## 0.4.6
- Fix group resource on apply action

## 0.4.5
- Add group resource
- Raise KeyError when missing key is referred from ERB
- Show its file path on error from ERB template

## 0.4.4
- Add template resource
- Prevent abstract class from being used as resource type

## 0.4.3
- Add directory resource
- Add file resource
- Rename the previous file resource with remote_file
- Support shell attribute on user resource
- Change some attribue names on user resource

## 0.4.2
- Fix bug on apply action exit status
- Support case-insensitive or number log-level

## 0.4.1
- Add user resource

## 0.4.0
- Deprecate homebrew & homebrew_cask resources
- Add check_script and recheck_script to all resources
- Disable original color from command result
- Change symlink default_id so that only source is displayed

## 0.3.5
- Add logger with `--log-level=` and `--no-color` options

## 0.3.4
- Add -f option on symlink resource
- Change attributes naming rule: status -> state

## 0.3.3
- Return exit status 1 if any resource failed

## 0.3.2
- Fix git resource on git-clone

## 0.3.1
- Support options and version attributes on package resource

## 0.3.0
- Always use sudo on SSH backend

## 0.2.9
- Support ActiveModel v3.2.12

## 0.2.8
- Support SSH options injection on action class

## 0.2.7
- Ignore missing Gemfile error

## 0.2.6
- Support ERB trim_mode with "-"

## 0.2.5
- Fix bug on resource with no notify property

## 0.2.4
- Add new feature: Handlers
- Add command resource type
- Change id attribute to optional
- Improve validation error message on missing type case

## 0.2.3
- Support multiple types on TypeValidator
- Fix validation bug on missing type resource

## 0.2.2
- Change action name: `serverkit diff` -> `serverkit check`
- Load gems from Gemfile before running action

## 0.2.1
- Change action name: `serverkit check` -> `serverkit diff`

## 0.2.0
- Support multiple hosts
- Change `--host=` option to `--hosts=`
- Change variables use on ERB template
- Force recipe validation on all actions

## 0.1.0
- Support execution over SSH with --host option
- Remove --recipe=... option and require recipe path in 2nd command-line argument

## 0.0.6
- Add `serverkit inspec` action
- Define required ruby version with 2.0.0 or higher in gemspec
- Improve recipe validation accuracy

## 0.0.5
- Add `recipe` resource type
- Improve validation error message

## 0.0.4
- Support ERB recipe and variables injection

## 0.0.3
- Support JSON, executable, and directory recipe
- Support service resource experimentally
- Validate attribute type
- Validate no resources recipe
- Rename resource.name with resource.id
- Rename package.package with package.name

## 0.0.2
- Add `serverkit validate` action

## 0.0.1
- 1st Release on 2015-03-30
- Support `serverkit check` and `serverkit apply` actions
