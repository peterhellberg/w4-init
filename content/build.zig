const std = @import("std");

pub fn build(b: *std.Build) !void {
    const exe = b.addExecutable(.{
        .name = "cart",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = .{ .cpu_arch = .wasm32, .os_tag = .wasi },
        .optimize = .ReleaseSmall,
    });

    exe.addModule("w4", b.dependency("w4", .{}).module("w4"));

    exe.export_symbol_names = &[_][]const u8{
        "start",
        "update",
    };

    exe.entry = .disabled;
    exe.import_memory = true;
    exe.initial_memory = 65536;
    exe.max_memory = 65536;
    exe.stack_size = 14752;

    b.installArtifact(exe);

    const run_cmd = b.addSystemCommand(&[_][]const u8{
        "w4",
        "run",
        "--no-open",
        "--no-qr",
        "zig-out/bin/cart.wasm",
    });
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the cart in WASM-4");
    run_step.dependOn(&run_cmd.step);

    const spy_cmd = b.addSystemCommand(&[_][]const u8{
        "spy",
        "--exc",
        "zig-cache",
        "--inc",
        "**/*.zig",
        "-q",
        "clear-zig",
        "build",
    });
    const spy_step = b.step("spy", "Run spy watching for file changes");
    spy_step.dependOn(&spy_cmd.step);
}
