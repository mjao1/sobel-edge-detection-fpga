`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 06:24:43 PM
// Design Name: 
// Module Name: edge_detection_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_detection_top(
    input clk_100MHz,
    input rst,
    input [3:0] switches,
    input btn_reset,
    output [3:0] vga_red,
    output [3:0] vga_green, 
    output [3:0] vga_blue,
    output hsync,
    output vsync
);
    localparam IMG_WIDTH = 320;
    localparam IMG_HEIGHT = 240;
    localparam H_OFFSET = 160;
    localparam V_OFFSET = 120;
    
    // Clock generation
    wire clk_25MHz;
    wire clk_locked;
    clk_wiz_0 clk_wiz_inst (
        .clk_out1(clk_25MHz),
        .clk_in1(clk_100MHz),
        .reset(rst),
        .locked(clk_locked)
    );

    // VGA signals
    wire [10:0] h_cnt;
    wire [9:0] v_cnt;
    wire display_area;
    
    vga_controller vga_inst (
        .clk(clk_25MHz),
        .rst(rst),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .hsync(hsync),
        .vsync(vsync),
        .display_area(display_area)
    );

    // Control Unit
    wire [7:0] threshold;
    control_unit control_inst (
        .clk(clk_25MHz),
        .rst(rst),
        .switches(switches),
        .btn_reset(btn_reset),
        .threshold(threshold)
    );

    // Image address generation
    reg [8:0] x_cnt;
    reg [7:0] y_cnt;
    wire active_window;
    wire in_image_area;
    
    assign in_image_area = (h_cnt >= H_OFFSET && h_cnt < H_OFFSET + IMG_WIDTH &&
                           v_cnt >= V_OFFSET && v_cnt < V_OFFSET + IMG_HEIGHT);
    
    // Address calculation
    wire [16:0] read_addr;
    assign read_addr = y_cnt * IMG_WIDTH + x_cnt;
    
    // Pixel position tracking
    always @(posedge clk_25MHz) begin
        if (rst) begin
            x_cnt <= 0;
            y_cnt <= 0;
        end else if (in_image_area) begin
            if (x_cnt == IMG_WIDTH-1) begin
                x_cnt <= 0;
                if (y_cnt == IMG_HEIGHT-1)
                    y_cnt <= 0;
                else
                    y_cnt <= y_cnt + 1;
            end else begin
                x_cnt <= x_cnt + 1;
            end
        end
    end

    // Image ROM with registered output
    wire [7:0] pixel_in;
    reg [16:0] rom_addr_reg;
    
    always @(posedge clk_25MHz) begin
        if (in_image_area)
            rom_addr_reg <= read_addr;
        else
            rom_addr_reg <= 0;
    end
    
    image_rom rom_inst (
        .clk(clk_25MHz),
        .addr(rom_addr_reg),
        .dout(pixel_in)
    );

    // Edge detection with synchronous reset
    wire [7:0] pixel_out;
    sobel_edge_detection sobel_inst (
        .clk(clk_25MHz),
        .rst(rst),
        .pixel_in(pixel_in),
        .threshold(threshold),
        .x_pos(x_cnt),
        .y_pos(y_cnt),
        .valid_in(in_image_area),
        .pixel_out(pixel_out)
    );

    // Output registers
    reg [3:0] vga_red_reg, vga_green_reg, vga_blue_reg;
    reg [2:0] output_delay;
    reg display_valid;
    
    always @(posedge clk_25MHz) begin
        if (rst) begin
            vga_red_reg <= 0;
            vga_green_reg <= 0;
            vga_blue_reg <= 0;
            display_valid <= 0;
            output_delay <= 0;
        end else begin
            output_delay <= {output_delay[1:0], in_image_area};
            display_valid <= output_delay[2];
            
            if (display_area && display_valid) begin
                vga_red_reg <= pixel_out[7:4];
                vga_green_reg <= pixel_out[7:4];
                vga_blue_reg <= pixel_out[7:4];
            end else begin
                vga_red_reg <= 0;
                vga_green_reg <= 0;
                vga_blue_reg <= 0;
            end
        end
    end

    assign vga_red = vga_red_reg;
    assign vga_green = vga_green_reg;
    assign vga_blue = vga_blue_reg;

endmodule