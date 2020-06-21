# What's this
This project allows you to build a custom AWS cli docker container in under 75mb.

## Why bother?
Why _not_? I needed a container that uses AWS client to do _one thing_ as part of a CI pipeline. I don't like the fact that my container was over 350mb in size even though it had a single Python module and the AWS cli.

## How does it work?
* We `pip install` the AWS cli v2 (Oh yes you _can_! See [this](https://github.com/aws/aws-cli/issues/4947#issuecomment-585948174) comment.)
* We add a list of the commands we need our containerized AWS cli to support
* We remove pieces one-by-one while testing the AWS cli commands

### script 1: find_aws_command_dependencies
This script requires `files/aws_cli_commands_list.txt`, a text file with a list of AWS commands that our container will support. Example:
```
aws sts help
aws codeartifact login --domain my-domain --repository my-repository twine
```
This script produces a file called "keep_components.txt". If `files/keep_components.txt` already exists, `find_aws_command_dependencies` will not run

### script 2: remove_aws_cli_components
This script removes directories 'extras' and 'customizations' from the awscli and also removes all `${PYTHONPATH}/botocore/data` directories that are not listed in the "keep_components.txt" file.

## Authenticating the AWS client
For the component testing to work, the AWS client must be authenticated. If you are running it on an EC2 instance which has a role attached, authentication should be automatic. However, if you are running this on your laptop, you should copy your `~/.aws/*` files to the awscreds directory (this is added to .gitignore)

# Questions?
## Why are you using `pip` to install AWS cli?
My primary reason is that my container already has a requirement for Python 3.x and pip. If you install those, and then use the recommended installation method for the AWS cli, you will end up with two copies of the rather-large libpython library. Also: it works just fiiiine.

## Does it work?
Kind of! If you have issues with it, or suggestions for improving it, let me know
