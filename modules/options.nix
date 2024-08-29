{ config, pkgs, lib, ... }: {
  options = {
    dns = lib.mkOption {
      type = lib.types.str;
      description = "dns server used in sandbox";
      default = "223.5.5.5";
    };
    display = lib.mkOption {
      type = lib.types.int;
      description = "DISPLAY used by Xvfb and x11vnc";
      default = 114;
    };
    port = lib.mkOption {
      type = lib.types.int;
      description = "listen port of x11vnc";
      default = 5900;
    };
    password = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "password of x11vnc";
      default = null;
    };
  };
}