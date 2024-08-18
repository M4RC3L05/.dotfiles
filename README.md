# Personal dotfiles

My dotfiles

## Dependencies

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
