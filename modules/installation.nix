{ config, pkgs, lib, ... }: {
  options.installation = lib.mkOption {
    type = lib.types.path;
    description = "wechat installtion";
  };
  config.installation = pkgs.runCommand "installtion" {} ''
    function key() {
      ${pkgs.xdotool}/bin/xdotool key $1
      sleep 0.5
    }
    mkdir -p $out
    ${pkgs.xorg.xorgserver}/bin/Xvfb :1 &
    export DISPLAY=:1
    USER=root WINEPREFIX=$out/.wine ${pkgs.wineWowPackages.full}/bin/wine ${config.wechat-setup} &
    while :; do
      sleep 5
      if ${pkgs.xdotool}/bin/xdotool search 'Wechat Setup'; then
        key Tab; key Tab; key Tab; key Tab
        key space
        key Tab; key Tab; key Tab; key Tab; key Tab; key Tab; key Tab
        key Return
        sleep 20
        key Tab; key Tab
        key Return
        break
      fi
    done
  '';
}