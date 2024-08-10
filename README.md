# Personal dotfiles

My dotfiles

## Dependencies

- Brew dependencies: https://docs.brew.sh/Homebrew-on-Linux#requirements
  - To install brew packages

- Flatpak: https://flatpak.org/setup/
  - To install flatpak apps

- VSCode
  - To install vscode extensions

## Run

Just run the setup script.

```cmd
./setup.sh
```

## Final words

This dotfiles assumes your default login shell is bash which will start fish shell interactivelly.

It might be beneficial to setup some type of cron to execute `dump-packages` in order to have the
package files updated in the background

Some brew packages can be started as a service, they should be started as:

```bash
brew services start <package_name>
```

You can get more info in the output of setup.sh on the brew package install step
