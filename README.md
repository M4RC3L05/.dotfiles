# Personal dotfiles

My dotfiles

## Dependencies

- Flatpak: https://flatpak.org/setup

## Run

Just run the setup script.

```cmd
./setup
```

## Testing

Build and run the docker image on `.docker` folder using podman.
This will start with systemd and ask for login.

```cmd
podman build -t dotfiles:latest . -f ./.docker/Dockerfile && podman run -it --rm dotfiles:latest
```

Once inside the running docker image, cd into `~/.dotfiles` and execute `./setup`

## Final words

This dotfiles assumes your user is `main` and home dir is `/home/main`.
