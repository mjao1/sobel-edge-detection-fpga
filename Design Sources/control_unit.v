`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 06:24:43 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input clk,
    input rst,
    input [3:0] switches,
    input btn_reset,
    output reg [7:0] threshold
);
    always @(posedge clk or posedge rst) begin
        if (rst || btn_reset) begin
            threshold <= 8'd128;
        end else begin
            threshold <= {switches, 4'b0}; // Use switches to adjust threshold
        end
    end
endmodule
