`timescale 1ns / 1ps

module synchronizer #(parameter WIDTH = 4) (
    input clk_src,
    input clk_dest,
    input reset_n,
    input [WIDTH-1:0] data_in,
    output [WIDTH-1:0] data_out
);

reg [WIDTH-1:0] src_domain_reg;
reg [WIDTH-1:0] dest_domain_reg1;
reg [WIDTH-1:0] dest_domain_reg2;

assign data_out = dest_domain_reg2;

always @(posedge clk_src or negedge reset_n) begin
    if (!reset_n)
        src_domain_reg <= 0;
    else
        src_domain_reg <= data_in;
end

always @(posedge clk_dest or negedge reset_n) begin
    if (!reset_n) begin
        dest_domain_reg1 <= 0;
        dest_domain_reg2 <= 0;
    end
    else begin
        dest_domain_reg1 <= src_domain_reg;
        dest_domain_reg2 <= dest_domain_reg1;
    end
end

endmodule
