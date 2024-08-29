{ config, pkgs, lib, ... }: let
  cfg = config.wxhelper;
in {
  options.wxhelper.wxhelper = lib.mkOption {
    type = lib.types.path;
    description = "wxhelper";
  };
  config.wxhelper.wxhelper = pkgs.writeScriptBin "wxhelper" ''
    #!${pkgs.runtimeShell}
    mkdir -p data
    ${pkgs.bubblewrap}/bin/bwrap \
      --unshare-all \
      --share-net \
      --as-pid-1 \
      --uid 0 --gid 0 \
      --clearenv \
      --ro-bind /nix/store /nix/store \
      --bind ./data /root \
      --proc /proc \
      --dev /dev \
      --tmpfs /tmp \
      ${pkgs.writeScript "sandbox" ''
        #!${pkgs.runtimeShell}
        set -e

        createService() {
          mkdir -p /services/$1
          echo -e "#!${pkgs.runtimeShell}\n$2" > /services/$1/run
          chmod +x /services/$1/run
        }

        export PATH=${lib.makeBinPath (with pkgs; [
          busybox xorg.xorgserver x11vnc
          wineWowPackages.full
        ])}

        mkdir -p /etc
        mkdir -p /usr/bin /bin
        export HOME=/root
        echo "root:x:0:0::/root:${pkgs.runtimeShell}" > /etc/passwd
        echo "root:x:0:" > /etc/group
        echo "nameserver ${cfg.dns}" > /etc/resolv.conf
        ln -s $(which env) /usr/bin/env
        ln -s $(which sh) /bin/sh

        if [ ! -e /root/.wine ]; then
          cp -r ${cfg.installation}/.wine /root/.wine
          chmod +w -R /root/.wine
        fi

        export DISPLAY=':${toString cfg.display}'
        createService xvfb 'Xvfb :${toString cfg.display}'
        createService x11vnc 'x11vnc ${lib.concatStringsSep " " [
          "-forever" "-display :${toString cfg.display}"
          "-rfbport ${toString cfg.port}"
          (lib.optionalString (cfg.password != null) "-passwd ${cfg.password}")
        ]}'
        createService wechat ${pkgs.writeScript "wechat" ''
          #!${pkgs.runtimeShell}
          set -e
          wine /root/.wine/drive_c/Program\ Files/Tencent/WeChat/Wechat.exe &
          wine ${cfg.injector} ${cfg.wxhelper-dll} WeChat.exe
          wait
        ''}
        runsvdir /services
      ''}
  '';
}