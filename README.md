# What's this, then?
This project allows you to build a minimal AWS cli docker container. It's much smaller than any other AWS cli docker container I've found.

## Why?
I have a need for a container that does literally _one thing_ with AWS cli as part of my CI pipeline. I don't like the fact that this container ends up over 350mb even though it's a single Python module and a docker-entrypoint.sh. This process results in an image size of less than 75mb. (Also: Why the hell not?)

## How?
1. Pip install AWS cli v2 (Oh yes you _can_! See [this](https://github.com/aws/aws-cli/issues/4947#issuecomment-585948174) comment.)
2. Make a list of AWS cli commands your container needs (eg: `aws sts`, `aws codeartifact login twine`)
3. Remove all non-essential components

### How do you find out which components you need?
Once you pip install the AWS cli, you end up with a lot of subdirectories under `${install_path}../botocore/data`. If your container has pretty simple requirements, there's likely about 80mb of 'stuff' that you do not require. To find out what 'stuff' you need to keep, add your list of commands to a file called `command_list.txt` and build this container. This step is pretty slow because the script needs to verify  that your commands still work after removing each component from the AWS cli. However, once you've identified those components, you can delete the `files/aws_cli_commands_list.txt` file and add the list of components to the `files/keep_components.txt`.

### Authenticating AWS client
For the component testing to work, the AWS client must be authenticated. There are two ways that this can be done, depending on where you build the container:
1. Locally, you must copy your `~/.aws/*` files to the awscreds directory (this is added to .gitignore)
2. Run the docker build on an EC2 instance which has an appropriate role attached - aws cli uses host metadata to authenticate

### Why are you using `pip` to install AWS cli?
My primary reason is that my container already has a requirement for Python 3.x and pip. If you install those, and then use the recommended installation method for the AWS cli, you will end up with two copies of the rather-large libpython library. Also: it works just fiiiine.

## Status
Not working yet! I flung this stuff in here and changed to a python alpine base. I need to spend 20 minutes ironing out kinks. It might still be useful, even as a reference. If you feel like sending a PR, go for it.
