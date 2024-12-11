`timescale 1ns / 1ps

module sobel_edge_detection(
    input clk,
    input rst,
    input [7:0] pixel_in,
    input [7:0] threshold,
    input [9:0] x_pos,
    input [9:0] y_pos,
    input valid_in,
    output reg [7:0] pixel_out
);
    // Parameters
    localparam IMG_WIDTH = 960;
    
    // Line buffers
    (* ram_style = "block" *) reg [7:0] line_buffer_1 [0:IMG_WIDTH-1];
    (* ram_style = "block" *) reg [7:0] line_buffer_2 [0:IMG_WIDTH-1];
    
    // 3x3 window registers
    reg [7:0] p11, p12, p13;
    reg [7:0] p21, p22, p23;
    reg [7:0] p31, p32, p33;
    
    // Pipeline control
    reg [2:0] valid_pipeline;
    reg [9:0] x_pipeline [0:2];
    reg [9:0] y_pipeline [0:2];
    
    integer i;
    
    // Buffer write logic
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < IMG_WIDTH; i = i + 1) begin
                line_buffer_1[i] <= 0;
                line_buffer_2[i] <= 0;
            end
        end else if (valid_in) begin
            // Shift values through line buffers
            line_buffer_2[x_pos] <= line_buffer_1[x_pos];
            line_buffer_1[x_pos] <= pixel_in;
        end
    end
    
    // Window update logic
    always @(posedge clk) begin
        if (rst) begin
            {p11, p12, p13, p21, p22, p23, p31, p32, p33} <= 0;
            valid_pipeline <= 0;
        end else if (valid_in) begin
            // Update window registers
            p13 <= line_buffer_2[x_pos];
            p12 <= p13;
            p11 <= p12;
            
            p23 <= line_buffer_1[x_pos];
            p22 <= p23;
            p21 <= p22;
            
            p33 <= pixel_in;
            p32 <= p33;
            p31 <= p32;
            
            // Update position pipeline
            x_pipeline[0] <= x_pos;
            y_pipeline[0] <= y_pos;
            for (i = 1; i < 3; i = i + 1) begin
                x_pipeline[i] <= x_pipeline[i-1];
                y_pipeline[i] <= y_pipeline[i-1];
            end
            
            // Update valid pipeline
            valid_pipeline <= {valid_pipeline[1:0], (x_pos >= 2 && y_pos >= 2)};
        end else begin
            valid_pipeline <= {valid_pipeline[1:0], 1'b0};
        end
    end
    
    // Sobel computation
    reg signed [10:0] gx, gy;
    reg [10:0] mag;
    
    always @(posedge clk) begin
        if (rst) begin
            gx <= 0;
            gy <= 0;
            mag <= 0;
            pixel_out <= 0;
        end else if (valid_pipeline[1]) begin
            // Sobel X gradient
            gx <= (p13 + (p23 << 1) + p33) - (p11 + (p21 << 1) + p31);
            // Sobel Y gradient
            gy <= (p31 + (p32 << 1) + p33) - (p11 + (p12 << 1) + p13);
            // Magnitude approximation
            mag <= (gx[10] ? -gx : gx) + (gy[10] ? -gy : gy);
            // Threshold
            pixel_out <= (mag > threshold) ? 8'hFF : 8'h00;
        end else begin
            pixel_out <= 0;
        end
    end

endmodule
