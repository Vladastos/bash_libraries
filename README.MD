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
- [cook](lib/cook/cook.bash) Installs any passed dependencies using the appropriate package manager.

## Install

To install Vlibs, use the following command:

```bash
bash <(curl -s https://raw.githubusercontent.com/Vladastos/vlibs/main/install.bash)
```
