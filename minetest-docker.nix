{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; } }:

with pkgs;
let 
  sha256 = "03ga3j3cg38w4lg4d4qxasmnjdl8n3lbizidrinanvyfdyvznyh6";
  dataSha256 = "0b2fvwkpbrdrwm48dphpliscachhnv76lbb3bb6pliz3yiy979lc";
  dataRev = "1e3bc0cecb55921b16b1429d78c05dccd9ee92c6";
  #minetest_game = fetchGit {
  #      url = https://github.com/Foghrye4/minetest_saturn.git;
  #      rev = dataRev;
  #    };
  cmeMod = {
    name = "cme";
    path = fetchGit {
      url=https://github.com/BlockMen/cme.git;
      rev = "1694be3f325821c1ab4e504716bf67062606b90b";
    };
  };
  creaturesMod = {
    name = "creatures";
    path = fetchGit {
      url = https://github.com/MirceaKitsune/minetest_mods_creatures.git;
      rev = "adca784b964f28f7393669b3da71c99750099e7b";
    };
  };
  zombiesMod = {
    name = "zombies";
    path = fetchGit {
      url = https://github.com/minetest-mods/zombies.git;
      rev = "0e633a5b1c7174e73c57cb2cdd676470eab9d627";
    };
  };
  cityscapeMod = {
    name = "cityscape";
    path = fetchGit {
      url = https://github.com/duane-r/cityscape.git;
      rev = "06009a08044bc93798ed388b44d65d1ce96a8e2f";
    };
  };
  whitelistMod = {
    name = "whitlist";
    path = fetchGit {
      url = https://github.com/ShadowNinja/whitelist.git;
      rev = "041737f01989ccdfa200e5eaa78547fd4bf12f2d";
    };
  };

  minetest_game = fetchFromGitHub {
        owner = "minetest";
        repo = "minetest_game";
        rev = dataRev;
        sha256 = dataSha256;
      };

  minetestserver = (callPackage ./minetest.nix {
    inherit (darwin) libiconv;
    inherit (darwin.apple_sdk.frameworks) OpenGL OpenAL Carbon Cocoa;
    inherit minetest_game;
    mods = [ cmeMod cityscapeMod whitelistMod ];
    adminName = "notker";}).minetestserver_5;
in
pkgs.dockerTools.buildImage {
  name = "minetest";
  config = {
    Cmd = [ "${minetestserver}/bin/minetestserver" "--world" "/worlds/world" "--config" "${minetestserver}/share/minetest/games/minetest_game/minetest.conf" ];
    Volumes = {
      "/worlds" = {};
    };
    ExposedPorts = {
      "30000/upd" = {};
    };
  };
}
