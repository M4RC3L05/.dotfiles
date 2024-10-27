# Personal dotfiles

My dotfiles

## Dependencies

- Flatpak: https://flatpak.org/setup
  - To install flatpak apps

## Run

Just run the setup script.

```cmd
./setup
```

## Testing

Build and run the docker image on `.docker` folder

```cmd
podman build -t dotfiles:latest . -f ./.docker/Dockerfile && podman run -it --rm --init dotfiles:latest
```

Once inside the running docker image, cd into `~/.dotfiles` and execute `./setup`

## Final words

This dotfiles assumes your default login shell is bash and the user is `main` and home dir is `/home/main`.
