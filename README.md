# minetestserver
Nix files for setting up a minetest server in a container.
minetest.nix is based on the default.nix of the minetest package at https://github.com/NixOS/nixpkgs/tree/nixos-20.09/pkgs/games/minetest

## Build

Build using nix-build 

    mintest-docker.nix.

Load into docker using

    docker load < result
    
Run using

    docker run --name minetest-server -p 30000:30000 -v <worlds>:/worlds <image-name>

to create and run a container that offers minetest on port 30000, keeps its worlds in directory <worlds> and is named minetest-server.
