`timescale 1ns / 1ps

module block(
    input  wire [63:0] p_sum,
    input  wire [31:0] w_b,
    input  wire [31:0] inp_west,
    input  wire        clk,
    input  wire        rst,
    output reg  [31:0] outp_east,
    output reg  [63:0] result
);

    wire [63:0] mult = inp_west * w_b;

    // prevent X propagation
    wire [63:0] safe_p_sum = (^p_sum === 1'bX) ? 64'd0 : p_sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result    <= 64'd0;
            outp_east <= 32'd0;
        end else begin
            result    <= safe_p_sum + mult;
            outp_east <= inp_west;
        end
    end
endmodule
