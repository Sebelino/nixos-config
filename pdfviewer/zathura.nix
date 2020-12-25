{
  enable = true;
  options = {
    highlight-active-color = "#FF0000";
    recolor = true;
    recolor-keephue = true;
    recolor-lightcolor = "#000000";
    selection-clipboard = "clipboard";
    statusbar-bg = "#080808";
    statusbar-fg = "#008000";
  };
  extraConfig = ''
    map y navigate previous
    map e navigate next
    map i set recolor
  '';
}
