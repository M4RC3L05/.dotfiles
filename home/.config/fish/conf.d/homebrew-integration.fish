if status --is-interactive
  if test -d /home/linuxbrew/.linuxbrew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source

    fish_add_path --move --append --path $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin

    if test -d $HOMEBREW_PREFIX/share/fish/completions;
      if not contains -- $HOMEBREW_PREFIX/share/fish/completions $fish_complete_path
        set -ga fish_complete_path $HOMEBREW_PREFIX/share/fish/completions
      end
    end

    if test -d $HOMEBREW_PREFIX/share/fish/vendor_completions.d;
      if not contains -- $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
        set -ga fish_complete_path $HOMEBREW_PREFIX/share/fish/vendor_completions.d
      end
    end
  end
end