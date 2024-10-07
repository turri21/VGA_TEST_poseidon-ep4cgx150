module vga_sync_gen(
    input wire clk,  // Input clock
    output wire hsync, vsync,  // Horizontal and Vertical sync signals
    output reg [9:0] x,  // Pixel x position
    output reg [9:0] y,  // Pixel y position
    output wire video_on  // Signal to indicate if we're in the visible area
);

// Defining timing constants
parameter H_VISIBLE = 640;
parameter H_FRONT = 16;
parameter H_SYNC = 96;
parameter H_BACK = 48;
parameter H_TOTAL = 800;  // Total pixels per line

parameter V_VISIBLE = 480;
parameter V_FRONT = 10;
parameter V_SYNC = 2;
parameter V_BACK = 33;
parameter V_TOTAL = 525;  // Total lines per frame

// Horizontal and vertical counters
reg [9:0] h_count = 0;
reg [9:0] v_count = 0;

// Generating sync signals and counting positions
always @(posedge clk) begin
    if(h_count < H_TOTAL-1) begin
        h_count <= h_count + 1;
    end else begin
        h_count <= 0;
        if(v_count < V_TOTAL-1) begin
            v_count <= v_count + 1;
        end else begin
            v_count <= 0;
        end
    end
end

assign hsync = (h_count < (H_VISIBLE + H_FRONT) || h_count >= (H_VISIBLE + H_FRONT + H_SYNC)) ? 1'b1 : 1'b0;
assign vsync = (v_count < (V_VISIBLE + V_FRONT) || v_count >= (V_VISIBLE + V_FRONT + V_SYNC)) ? 1'b1 : 1'b0;

// Output current pixel position
always @(posedge clk) begin
    if(h_count < H_VISIBLE && v_count < V_VISIBLE) begin
        x <= h_count;
        y <= v_count;
    end else begin
        x <= 0;
        y <= 0;
    end
end

// Enable video output only in the visible area
assign video_on = (h_count < H_VISIBLE && v_count < V_VISIBLE) ? 1'b1 : 1'b0;

endmodule