const std = @import("std");

pub fn build(b: *std.Build) !void {
    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32,
            .os_tag = .wasi,
        }),
        .optimize = .ReleaseSmall,
    });

    const exe = b.addExecutable(.{
        .name = "cart",
        .root_module = mod,
    });

    exe.root_module.addImport("w4", b.dependency("w4", .{}).module("w4"));

    exe.root_module.export_symbol_names = &[_][]const u8{
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
}
