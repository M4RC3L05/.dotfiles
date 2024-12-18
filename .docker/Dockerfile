FROM debian:latest

RUN apt update && apt install -y curl build-essential procps file git sudo passwd nano flatpak

RUN groupadd -g 1000 main
RUN useradd -m -u 1000 -g 1000 -s /bin/bash main && \
  echo "main:main" | chpasswd && \
  usermod -aG sudo main

COPY --chown=main:main . /home/main/.dotfiles

RUN echo "/home/main/.dotfiles/.docker/entrypoint.sh" >> /home/main/.bashrc

CMD ["/sbin/init"]
