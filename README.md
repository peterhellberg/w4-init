# w4-init :sparkles:

This is a command line tool that acts as a companion to my
[w4](https://github.com/peterhellberg/w4) module
for [Zig](https://ziglang.org/) :zap:

`w4-init` is used to create a directory containing code that
allows you to promptly get started coding on a cart for the
lovely little fantasy console [WASM-4](https://wasm4.org/).

The Zig build `.target` is declared as `.{ .cpu_arch = .wasm32, .os_tag = .wasi }`
and `.optimize` is set to `.ReleaseSmall`

> [!Important]
> No need to specify `-Doptimize=ReleaseSmall`

## Installation

(Requires you to have [Go](https://go.dev/) installed)

```sh
go install github.com/peterhellberg/w4-init@latest
```

## Usage

(Requires you to have an up to date (_nightly_) version of
[Zig](https://ziglang.org/download/#release-master) installed.

```sh
w4-init mycart
cd mycart
zig build run
```

> [!Note]
> There is also a `zig build spy` command.

:seedling:
