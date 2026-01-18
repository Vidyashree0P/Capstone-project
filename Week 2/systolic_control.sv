`timescale 1ns / 1ps
module systolic_control (
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic        mem_we,
    input  logic [3:0]  mem_addr,
    input  logic [31:0] weight_din,
    input  logic [31:0] act_din,
    input  logic signed [31:0] layer_scale,

    output logic [31:0] inP1, inP5, inP9, inP13,
    output logic [511:0] weight_flat_out,
    output logic        done
);
    typedef enum logic [2:0] {IDLE, FETCH_ADDR, FETCH_DATA, EXECUTE, CAPTURE, DONE} state_t;
    state_t state;
    
    logic [3:0]  addr, count;
    logic [31:0] weight_reg [16];
    logic [31:0] act_reg [16];

    for (genvar fi = 0; fi < 16; fi++) begin : out_flat
        assign weight_flat_out[fi*32 +: 32] = weight_reg[fi];
    end

    logic signed [7:0]  w8, w8_sram;
    logic signed [31:0] w32;
    logic [31:0]        act_out;

    int32_to_int8_compressor COMP (weight_din, layer_scale, w8);
    int8_to_int32_decompressor DECOMP (w8_sram, layer_scale, w32);

    asic_sram_macro #(8,4)  W_SRAM (clk, 1'b1, mem_we, mem_we ? mem_addr : addr, w8, w8_sram);
    asic_sram_macro #(32,4) A_SRAM (clk, 1'b1, mem_we, mem_we ? mem_addr : addr, act_din, act_out);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            addr  <= 4'd0;
            count <= 4'd0;
            done  <= 1'b0;
            {inP1, inP5, inP9, inP13} <= '0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin addr <= 4'd0; state <= FETCH_ADDR; end
                end
                FETCH_ADDR: state <= FETCH_DATA;
                FETCH_DATA: begin
                    weight_reg[addr] <= w32;
                    act_reg[addr]    <= act_out;
                    if (addr == 4'd15) begin addr <= 4'd0; count <= 4'd0; state <= EXECUTE; end
                    else begin addr <= addr + 4'd1; state <= FETCH_ADDR; end
                end
                EXECUTE: begin
                    case (count)
                        4'd0: begin inP1 <= act_reg[0]; end
                        4'd1: begin inP1 <= act_reg[4];  inP5 <= act_reg[1]; end
                        4'd2: begin inP1 <= act_reg[8];  inP5 <= act_reg[5];  inP9 <= act_reg[2]; end
                        4'd3: begin inP1 <= act_reg[12]; inP5 <= act_reg[9];  inP9 <= act_reg[6];  inP13 <= act_reg[3]; end
                        4'd4: begin inP1 <= 0;           inP5 <= act_reg[13]; inP9 <= act_reg[10]; inP13 <= act_reg[7]; end
                        4'd5: begin                      inP5 <= 0;           inP9 <= act_reg[14]; inP13 <= act_reg[11]; end
                        4'd6: begin                                           inP9 <= 0;           inP13 <= act_reg[15]; end
                        4'd7: begin                                                                inP13 <= 0; state <= CAPTURE; end
                    endcase
                    count <= count + 4'd1;
                end
                CAPTURE: state <= DONE;
                DONE:    begin done <= 1'b1; state <= IDLE; end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
