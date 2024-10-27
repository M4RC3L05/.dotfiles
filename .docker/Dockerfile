FROM debian:latest

RUN apt update && apt install -y curl build-essential procps file git sudo passwd flatpak nano

RUN groupadd -g 1000 main
RUN useradd -m -u 1000 -g 1000 -s /bin/bash main && \
  echo "main:main" | chpasswd && \
  usermod -aG sudo main

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER main

WORKDIR /home/main

COPY --chown=main:main . ./.dotfiles

ENTRYPOINT ["/home/main/.dotfiles/.docker/entrypoint.sh"]
CMD ["/bin/bash"]
