{ config, pkgs, lib, ... }: {
  options.wxhelper = {
    wechat-setup = lib.mkOption {
      type = lib.types.path;
      description = "wechat setup";
    };
    injector = lib.mkOption {
      type = lib.types.path;
      description = "injector";
    };
    wxhelper-dll = lib.mkOption {
      type = lib.types.path;
      description = "wxhelper";
    };
  };
  config.wxhelper = {
    wechat-setup = pkgs.fetchurl {
      name = "wechat-setup.exe";
      url = "https://github.com/tom-snow/wechat-windows-versions/releases/download/v3.9.10.19/WeChatSetup-3.9.10.19.exe";
      hash = "sha256-lgKsuFQI7kjuaJRo9jVlSW37EvH+Ia1nSqQjAp44hWw=";
    };
    wxhelper-dll = pkgs.fetchurl {
      name = "wxhelper.dll";
      url = "https://github.com/ttttupup/wxhelper/releases/download/3.9.10.19-v1/wxhelper.dll";
      hash = "sha256-JPQ/+C04Ip6UJDwCRU7+ylhUVgSFAMreWyxKjfMAXjM=";
    };
    # https://github.com/ttttupup/wxhelper/tree/main/source
    injector = ./injector.exe;
  };
}