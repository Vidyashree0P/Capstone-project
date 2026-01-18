`timescale 1ns / 1ps
// --- Simple SRAM ---
module asic_sram_macro #(
    parameter int DATA_W = 32,
    parameter int ADDR_W = 4
)(
    input  logic               clk,
    input  logic               cs,
    input  logic               we,
    input  logic [ADDR_W-1:0]  addr,
    input  logic [DATA_W-1:0]  din,
    output logic [DATA_W-1:0]  dout
);
    logic [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];

    always_ff @(posedge clk) begin
        if (cs) begin
            if (we) mem[addr] <= din;
            else    dout      <= mem[addr];
        end
    end
endmodule
