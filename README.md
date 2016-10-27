# zpm

A simple zsh package manager.

## What is this

A simple zsh package manager implementation. This project is an example project
of [kmhjs/zcl](https://github.com/kmhjs/zcl) .

## Usage

1. Clone this project. (Or download `zpm` file)
2. Clone [kmhjs/zcl](https://github.com/kmhjs/zcl) project. (Or download `zcl` file)
3. Update your `FPATH` with path to `zpm` and `zcl` file.
4. Call `autoload -Uz zcl` and `autoload -Uz zpm` in `.zshrc` etc.
5. Configure your `plugin.conf` .

### Dry-run mode

If you want to use dry-run mode, pass `zpm_dry_run=1` to zpm as environment variable.

```shell
zpm_dry_run=1 zpm --update
```

## Configuration

### Configuration file path

Normal configuration file path is `${HOME}/.config/zpm/plugin.conf` .  
If you want to change the path, define path as variable `ZPM_CONFIGURATION_PATH` .

### Configuration format

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
