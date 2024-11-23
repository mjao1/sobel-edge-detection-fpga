`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 06:24:43 PM
// Design Name: 
// Module Name: image_rom
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


module image_rom (
    input wire clk,
    input wire [16:0] addr,
    output reg [7:0] dout
);

    // Declare memory array with block ram
    (* rom_style = "block" *) reg [7:0] mem [0:76799];

    // Initialize memory
    initial begin
        $readmemh("image.mem", mem);
    end

    // Read memory
    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule
