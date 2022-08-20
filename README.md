# zig-master.nix

A Nix flake providing pre-built master releases of the Zig programming language
and toolchain.

The packaged version of Zig tracks the master version as given in the
[download index](https://ziglang.org/download/index.json) and is updated
automatically by a [GitHub Actions workflow](./.github/workflows/update.yml).

## Usage

Add this flake to your flake's inputs and use the `zig` package provided by this flake at `zig-master.packages.${system}.zig`.

If you want, you can also use this flake's template to create a Zig development environment for your Zig project:

```console
$ mkdir zig-project/
$ cd zig-project/
$ nix flake init -t 'github:jessestricker/zig-master.nix'
wrote: .../zig-project/flake.nix

$ nix develop -c zig version
warning: creating lock file '.../zig-project/flake.lock'
0.10.0-dev.3659+e5e6eb983

$ nix develop -c zig init-exe
info: Created build.zig
info: Created src/main.zig
info: Next, try `zig build --help` or `zig build run`

$ nix develop -c zig build run
All your codebase are belong to us.
Run `zig build test` to run the tests.
```
