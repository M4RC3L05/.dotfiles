# Personal dotfiles

My dotfiles to be configured with GNU Stow + Brew

## Dependencies

- Brew dependencies: https://docs.brew.sh/Homebrew-on-Linux#requirements
- Flatpak: https://flatpak.org/setup/

## Run

Just run the setup script.

```cmd
./setup.sh
```

## Final words

This dotfiles assumes your default login shell is bash which will start fish shell interactivelly.
It might be beneficial to setup some type of cron to execute `dump-packages` in order to have the
package files updated in the background
