const w4 = @import("w4");

var mouse: w4.Mouse = .{};
var button: w4.Button = .{};

export fn start() void {
    w4.palette(.{ 0x271d2c, 0x7b6960, 0xfff8ed, 0xe01f3f });
}

export fn update() void {
    mouse.update();
    button.update();

    draw();
}

fn input() void {}

fn draw() void {
    for ([4]w4.Box{
        .init(0, 0, 160, 40),
        .init(0, 40, 160, 40),
        .init(0, 80, 160, 40),
        .init(0, 120, 160, 40),
    }, 0..) |box, i| {
        box.fill(@intCast(i + 1));
    }
}
