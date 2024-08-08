function without_user_paths --description 'Executes a command without user/brew paths'
  set -f filtered_path (string join ":" (string match -v "/home/main*" (string match -v "/home/linuxbrew*" $PATH)))
  set -f filtered_manpath (string join ":" (string match -v "/home/linuxbrew*" $MANPATH))
  set -f filtered_infopath (string join ":" (string match -v "/home/linuxbrew*" $INFOPATH))

  env PATH=$filtered_path MANPATH=$filtered_manpath INFOPATH=$filtered_infopath HOMEBREW_PREFIX="" HOMEBREW_CELLAR="" HOMEBREW_REPOSITORY="" $argv
end