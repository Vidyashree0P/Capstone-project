`timescale 1ns / 1ps
module int32_to_int8_compressor (
    input  logic signed [31:0] in_w,
    input  logic [31:0]        scale,   // one-hot power-of-two
    output logic signed [7:0]  out_w
);

    logic [5:0] sh;        // shift amount (0-31)
    logic signed [31:0] q; // quantized intermediate

    // ----------------------------------------------
    // Decode shift from one-hot scale (priority encoder)
    // ----------------------------------------------
    always_comb begin
        sh = 6'd0;
        for (int i = 0; i < 32; i++) begin
            if (scale[i])
                sh = i;
        end
    end

    // ----------------------------------------------
    // Symmetric rounding right shift
    // q = round(in_w / 2^sh)
    // ----------------------------------------------
    always_comb begin
        if (sh == 0)
            q = in_w;
        else
            q = (in_w + (in_w[31] ? -(32'sd1 <<< (sh-1))
                                  :  (32'sd1 <<< (sh-1))))
                >>> sh;
    end

    // ----------------------------------------------
    // Saturation to INT8
    // ----------------------------------------------
    always_comb begin
        if (q > 32'sd127)
            out_w = 8'sd127;
        else if (q < -32'sd128)
            out_w = -8'sd128;
        else
            out_w = q[7:0];
    end

endmodule
