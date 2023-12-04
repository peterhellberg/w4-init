const w4 = @import("w4");

const Cart = struct {
    fn start(_: *Cart) void {
        w4.palette(.{ 0x1e1e3c, 0x50506e, 0xbebee6, 0xe6e6ff });
    }
    fn update(_: *Cart) void {}
    fn draw(_: *Cart) void {}
};

var cart = Cart{};

export fn start() void {
    cart.start();
}

export fn update() void {
    cart.update();
    cart.draw();
}
