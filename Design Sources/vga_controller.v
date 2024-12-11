`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 06:24:43 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
    input clk,
    input rst,
    output reg [10:0] h_cnt,
    output reg [9:0] v_cnt,
    output reg hsync,
    output reg vsync,
    output reg display_area
);
    parameter H_PIXELS = 960;  
    parameter H_FP = 48;      
    parameter H_PULSE = 96;   
    parameter H_BP = 144;       
    parameter V_LINES = 540; 
    parameter V_FP = 3;      
    parameter V_PULSE = 5;     
    parameter V_BP = 14;  
    
    parameter H_TOTAL = H_PIXELS + H_FP + H_PULSE + H_BP;
    parameter V_TOTAL = V_LINES + V_FP + V_PULSE + V_BP;
    
    // Horizontal counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            h_cnt <= 0;
        else if (h_cnt == H_TOTAL - 1)
            h_cnt <= 0;
        else
            h_cnt <= h_cnt + 1;
    end
    
    // Vertical counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            v_cnt <= 0;
        else if (h_cnt == H_TOTAL - 1) begin
            if (v_cnt == V_TOTAL - 1)
                v_cnt <= 0;
            else
                v_cnt <= v_cnt + 1;
        end
    end
    
    // hsync and vsync signals
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hsync <= 1;
            vsync <= 1;
        end else begin
            // hsync
            if (h_cnt >= H_PIXELS + H_FP && h_cnt < H_PIXELS + H_FP + H_PULSE)
                hsync <= 0;
            else
                hsync <= 1;
            // vsync
            if (v_cnt >= V_LINES + V_FP && v_cnt < V_LINES + V_FP + V_PULSE)
                vsync <= 0;
            else
                vsync <= 1;
        end
    end
    
    // Display area
    always @(posedge clk or posedge rst) begin
        if (rst)
            display_area <= 0;
        else begin
            if (h_cnt < H_PIXELS && v_cnt < V_LINES)
                display_area <= 1;
            else
                display_area <= 0;
        end
    end
endmodule
