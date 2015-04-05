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
