const w4 = @import("w4");

var mouse: w4.Mouse = .{};
var button: w4.Button = .{};

export fn start() void {
    w4.palette(.{
        0x2b2b26,
        0x706b66,
        0xa89f94,
        0xe0dbcd,
    });
}

export fn update() void {
    mouse.update();
    button.update();

    draw();
}

fn draw() void {
    for (0..4) |i| w4.Box
        .init(0, @intCast(i * 40), 160, 40)
        .fill(@intCast(i + 1));
}
