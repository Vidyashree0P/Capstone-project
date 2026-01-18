`timescale 1ns / 1ps

module tb_systolic_top;

    reg clk, rst, start, mem_we;
    reg [3:0] mem_addr;
    reg [31:0] weight_din, act_din;
    reg signed [31:0] layer_scale;

    wire done;
    wire [63:0] Re1, Re2, Re3, Re4;

    // Output matrix
    reg [63:0] C [0:3][0:3];

    // Weight and activation storage
    reg [31:0] W [0:15];
    reg [31:0] A [0:15];

    integer i, r;

    // DUT
    systolic_top DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .weight_din(weight_din),
        .act_din(act_din),
        .layer_scale(layer_scale),
        .done(done),
        .Re1(Re1),
        .Re2(Re2),
        .Re3(Re3),
        .Re4(Re4)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // SRAM write task
    task load_entry;
        input [3:0] addr;
        input [31:0] w;
        input [31:0] a;
        begin
            @(negedge clk);
            mem_we     = 1;
            mem_addr   = addr;
            weight_din = w;
            act_din    = a;
            @(posedge clk);
            mem_we = 0;
        end
    endtask

    initial begin
        // -------------------------
        // Init
        // -------------------------
        rst = 1;
        start = 0;
        mem_we = 0;
        weight_din = 0;
        act_din = 0;
        layer_scale = 32'd256;

        repeat (5) @(posedge clk);
        rst = 0;

        // -------------------------
        // Define WEIGHTS (scaled)
        // -------------------------
        W[0]=256;  W[1]=512;  W[2]=768;  W[3]=1024;
        W[4]=1280; W[5]=1536; W[6]=1792; W[7]=2048;
        W[8]=2304; W[9]=2560; W[10]=2816; W[11]=3072;
        W[12]=3328; W[13]=3584; W[14]=3840; W[15]=4096;

        // -------------------------
        // Define ACTIVATIONS (Identity)
        // -------------------------
      A[0]=1; A[1]=0; A[2]=0; A[3]=0;
        A[4]=0; A[5]=1; A[6]=0; A[7]=0;
        A[8]=0; A[9]=0; A[10]=1; A[11]=0;
        A[12]=0; A[13]=0; A[14]=0; A[15]=1;

        // -------------------------
        // Load SRAM
        // -------------------------
        for (i = 0; i < 16; i = i + 1)
            load_entry(i[3:0], W[i], A[i]);

        // -------------------------
        // Run 4 wavefronts (ROWS)
        // -------------------------
        for (r = 0; r < 4; r = r + 1) begin

            // Launch wavefront
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Wait for controller to finish
            wait(done);

            // 🔥 CRITICAL: pipeline drain
            repeat (8) @(posedge clk);

            // Capture outputs
            C[r][0] = Re1;
            C[r][1] = Re2;
            C[r][2] = Re3;
            C[r][3] = Re4;
        end

        // -------------------------
        // Print results
        // -------------------------
        $display("\n===== MATRIX C (INT32) =====");
        for (r = 0; r < 4; r = r + 1) begin
            $display("%0d %0d %0d %0d",
                C[r][0]/layer_scale,
                C[r][1]/layer_scale,
                C[r][2]/layer_scale,
                C[r][3]/layer_scale);
        end

        $finish;
    end

    initial begin
        $dumpfile("systolic.vcd");
        $dumpvars(0, tb_systolic_top);
    end

endmodule
