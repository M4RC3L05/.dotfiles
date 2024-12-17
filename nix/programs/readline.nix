{
  enable = true;
  includeSystemConfig = true;
  bindings = {
    "\\e[A" = "history-search-backward";
    "\\e[B" = "history-search-forward";
    "\\e[1;5D" = "backward-word";
    "\\e[1;5C" = "forward-word";
    TAB = "menu-complete";
    "\\e[Z" = "menu-complete-backward";
  };
  variables = {
    "bell-style" = "none";
    "colored-stats" = "on";
    "visible-stats" = "on";
    "mark-symlinked-directories" = "on";
    "colored-completion-prefix" = "on";
    "menu-complete-display-prefix" = "on";
    "show-all-if-ambiguous" = "on";
    "completion-ignore-case" = "on";
    "completion-map-case" = "on";
    "skip-completed-text" = "on";
  };
}
