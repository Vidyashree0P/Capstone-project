`timescale 1ns / 1ps

module int8_to_int32_decompressor (
    input  logic signed [7:0]  in_w,
    input  logic [31:0]        scale,
    output logic signed [31:0] out_w
);
    assign out_w = $signed(in_w) * $signed(scale);
endmodule
