# cook
[ WORK IN PROGRESS ]
cook is a tool that allows you to install packages using a common syntax for different packet managers and declare your own "Recipes".

## Usage

To use cook, simply execute the `cook` command with the names of the packages you want to install
Example:

```bash
vlibs cook [parameters] package1 package2 
```

This install the packages using your system's packet manager and cache the script for future use.

By default, cook will first search for recipes in the specified repository and execute them, and only if it doesn't find a recipe will it try to install the package using your system's packet manager. To disable this behavior, use the `--no-recipe` flag.

### Recipes

Recipes allow you to define custom, scripts that provide instructions for the installation of packages. You can add your own recipe repository by adding it to the `REPOSITORY_LIST` in the config file.

It is recommended that you use the `--recipe` flag to specify the name of the recipe you want to use.

Example:

```bash
hello-world.recipe.bash

# Add dependencies here
# These will be installed with any package manager before using the recipe
COMMON_INGREDIENTS=(
    "git"
    "other-recipe" # You can also specify other recipes as dependencies
)

# You can add package-manager specific ingredients by declaring an array with the name of the package manager
APT_INGREDIENTS=(
    "nano"
)

# This is the recipe that will be executed for any package manager
function hello-world_common_recipe {
    echo "Hello World!"
}

# This is the recipe that will be executed for apt
function hello-world_apt_recipe {
    echo "Apt!"
}

```

This recipe will:

- Try to install all the elements in the `COMMON_INGREDIENTS` array
- If the package manager is apt, it will try to install all the elements in the `APT_INGREDIENTS` array ( same for pacman )
- Execute the `hello-world_common_recipe` function
- Execute the `hello-world_apt_recipe` function if the package manager is apt ( same for pacman )

## Custom recipe repository

You can use custom recipe repositories by adding them to the `REPOSITORY_LIST` in the config file.

Example:

```yaml
REPOSITORY_LIST:
  - name: my-recipe-repository
    url: https://example.com/my-recipe-repository
```

To specify the repository from which to fetch the recipes, add `@my-recipe-repository` after the recipe name.

Example:

```bash
vlibs cook --recipe hello-world@my-recipe-repository
```

This will fetch the recipe from the `my-recipe-repository` repository and execute it.
