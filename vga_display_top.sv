module vga_display(
    input wire clk,  
    output wire hsync, vsync,
    output wire [3:0] red, green, blue  // 4-bit color channels
);

wire clk25;
wire [9:0] x, y;
wire video_on;

pll pll(
	.areset(),
	.inclk0(clk),
	.c0(clk25),
	.locked()
);
	
// Instantiate the VGA sync generator
vga_sync_gen sync_gen(
	.clk(clk25), // 25.175 MHz clock for 640x480 @ 60Hz
	.hsync(hsync), 
	.vsync(vsync), 
	.x(x), 
	.y(y), 
	.video_on(video_on)
);

// Simple logic to draw a box on the screen
wire draw_box;
assign draw_box = (x > 100 && x < 200) && (y > 100 && y < 200);


// Set color if we're within the box and the display is active

// RED
//assign red = (video_on && draw_box) ? 4'hF : 4'h0;            
//assign green = (video_on && draw_box) ? 4'h0 : 4'h0;
//assign blue = (video_on && draw_box) ? 4'h0 : 4'h0;

// PURPLE
assign red = (video_on && draw_box) ? 4'hFFFF : 4'h3333;
assign green = (video_on && draw_box) ? 4'h2222 : 4'h6666;
assign blue = (video_on && draw_box) ? 4'hFFFF : 4'h4444;



endmodule