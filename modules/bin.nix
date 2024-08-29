{ config, pkgs, lib, ... }: {
  options = {
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
  config = {
    wechat-setup = pkgs.fetchurl {
      name = "wechat-setup.exe";
      url = "https://github.com/tom-snow/wechat-windows-versions/releases/download/v3.9.10.19/WeChatSetup-3.9.10.19.exe";
      hash = "sha256-lgKsuFQI7kjuaJRo9jVlSW37EvH+Ia1nSqQjAp44hWw=";
    };
    injector = pkgs.fetchurl {
      name = "injector.exe";
      url = "https://github.com/adamhlt/DLL-Injector/releases/download/DLL-Injector/Inject-x64.exe";
      hash = "sha256-0OVGqFs+xmIYFgFJMcR6o5lLtQgbrewJbE4GVF3rSD4=";
    };
    wxhelper-dll = pkgs.fetchurl {
      name = "wxhelper.dll";
      url = "https://github.com/ttttupup/wxhelper/releases/download/3.9.10.19-v1/wxhelper.dll";
      hash = "sha256-JPQ/+C04Ip6UJDwCRU7+ylhUVgSFAMreWyxKjfMAXjM=";
    };
  };
}