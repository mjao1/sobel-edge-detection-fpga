`timescale 1ns / 1ps

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
