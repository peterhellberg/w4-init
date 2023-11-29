# tic-init :sparkles:

This is a command line tool that acts as a companion to my
[tic](https://github.com/peterhellberg/tic) module
for [Zig](https://ziglang.org/) :zap:

`tic-init` is used to create a directory containing code that
allows you to promptly get started coding on a cart for the
lovely little fantasy console [TIC-80](https://tic80.com/).

The Zig build `.target` is declared as `.{ .cpu_arch = .wasm32, .os_tag = .wasi }`
and `.optimize` is set to `.ReleaseSmall`

> [!Important]
> No need to specify `-Doptimize=ReleaseSmall`

## Installation

(Requires you to have [Go](https://go.dev/) installed)

```sh
go install github.com/peterhellberg/tic-init@latest
```

## Usage

(Requires you to have an up to date (_nightly_) version of
[Zig](https://ziglang.org/download/#release-master) installed,
as well as the [PRO version](https://nesbox.itch.io/tic80) of TIC-80)

```sh
tic-init mycart
cd mycart
zig build run
```

> [!Note]
> There is also a `zig build spy` command.

:seedling:
