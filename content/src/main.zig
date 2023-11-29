const w4 = @import("w4");

var mouse = w4.Mouse{};
var button = w4.Button{};

fn input() void {
    mouse.update();
    button.update();
}

fn draw() void {
    w4.clear(2);
    w4.line(w4.SCREEN_SIZE, 0, mouse.x, mouse.y);
    w4.color(0x41);
    w4.circle(mouse.x, mouse.y, 6);
    w4.text("Hello, World!", 8, 10);
}

export fn start() void {
    // Tangerine Noir Palette
    // https://lospec.com/palette-list/tangerine-noir
    w4.palette(.{
        0xfcfcfc, // White
        0x393541, // Gray
        0x191a1f, // Black
        0xee964b, // Orange
    });
}

export fn update() void {
    input();
    draw();
}
