# zpm

A simple zsh package manager.

## What is this

A simple zsh package manager implementation. This project is an example project
of [kmhjs/zcl](https://github.com/kmhjs/zcl) .

# Usage

1. Clone this project. (Or download `zpm` file)
2. Update your `FPATH` with path to zpm file.
3. Call `autoload -Uz zpm` in `.zshrc` etc.

## Configuration file path

Normal configuration file path is `${HOME}/.config/zpm/plugin.conf` .  
If you want to change the path, define path as variable `ZPM_CONFIGURATION_PATH` .

## Configuration format

```
(
  :name      zsh-syntax-highlighting
  :url       https://github.com/zsh-users/zsh-syntax-highlighting.git
  :base_path ./plugin
)
(
  :name      zsh-completions
  :url       https://github.com/zsh-users/zsh-completions.git
  :base_path ./plugin/plugin-sub
)
```

## License

This project is distributed under MIT License. See `LICENSE` .

## Misc

Currently, this project is under development.
