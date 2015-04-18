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
- Return exit code 1 if any resource failed

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
