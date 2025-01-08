`timescale 1ns / 1ps

module synchronizer_TB;

    reg clk_src;
    reg clk_dest;
    reg reset_n;
    reg [3:0] data_in;
    wire [3:0] data_out;

    synchronizer uut (
        .clk_src(clk_src),
        .clk_dest(clk_dest),
        .reset_n(reset_n),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        clk_src = 0; clk_dest = 0; reset_n = 0; data_in = 4'b0000;
        #10 reset_n = 1;
        #10 data_in = 4'b1010;
        #20 data_in = 4'b0111;
        #20 data_in = 4'b0101;
        #20 data_in = 4'b1110;
        #30 reset_n = 0; #10 reset_n = 1; // Test reset behavior
        #40 $stop;
    end

    always #10 clk_src = ~clk_src; // Source clock
    always #5 clk_dest = ~clk_dest; // Destination clock

endmodule
