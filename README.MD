# Vlibs - a collection of bash scripts for common tasks

Vlibs is a tool that allows you to execute bash scripts from anywhere.

## Usage

To use Vlibs, simply execute the `vlibs` command with the name of the script you want to execute, followed by any arguments you want to pass to the script.

Example:

```bash
vlibs hello-world arg1 arg2
```

This will cache the script and execute it with the given arguments.

To clear the cache, use the `--clear-cache` flag:

## Available Scripts

For now, the following scripts are available:

- [hello-world](lib/hello-world/hello-world.bash)
 This script simply prints "Hello World" and prints any parameters passed to it.
- [install](lib/install/install.bash) Installs any passed dependencies using the appropriate package manager.

## Install

To install Vlibs, you can manually add the contents of the `vlibs_alias.bash` file to your .bashrc file
or use the following command:

```bash
mkdir -p ~/.config/vlibs
wget -qO ~/.config/vlibs/vlibs_alias.bash https://raw.githubusercontent.com/Vladastos/vlibs/main/vlibs_alias.bash
echo "source ~/.config/vlibs/vlibs_alias.bash" >> ~/.bashrc
source ~/.bashrc
```
