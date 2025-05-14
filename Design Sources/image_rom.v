`timescale 1ns / 1ps

module image_rom (
    input wire clk,
    input wire [18:0] addr,
    output reg [7:0] dout
);

    // Declare memory array with block ram
    (* rom_style = "block" *) reg [7:0] mem [0:691199];

    // Initialize memory
    initial begin
        $readmemh("image.mem", mem);
    end

    // Read memory
    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule
