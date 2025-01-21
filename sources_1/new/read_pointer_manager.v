`timescale 1ns / 1ps

module read_pointer_manager #(parameter PTR_WIDTH = 4) (
    input clk_read,
    input reset_n,
    input req_read,
    input [PTR_WIDTH-1:0] ptr_write, 
    output [PTR_WIDTH-1:0] ptr_read,
    output en_read,
    output flag_empty,
    output flag_uf
);

reg [PTR_WIDTH-1:0] reg_read_ptr;    
reg reg_uf;

assign ptr_read = reg_read_ptr; 
assign flag_empty = (reg_read_ptr == ptr_write);
assign en_read = req_read;
assign flag_uf = reg_uf;

always @(posedge clk_read or negedge reset_n) begin
    if (!reset_n) begin
        reg_read_ptr <= {PTR_WIDTH{1'b0}};
        reg_uf <= 1'b0;
    end else if (req_read && !flag_empty) begin
        reg_read_ptr <= reg_read_ptr + 1; 
        reg_uf <= 1'b0;
    end else begin
        reg_uf <= 1'b1;
    end
end

endmodule

/* Circular FIFO

`timescale 1ns / 1ps

module read_pointer_manager #(parameter PTR_WIDTH = 4) (
    input clk_read,
    input reset_n,
    input req_read,
    input [PTR_WIDTH:0] ptr_write,
    output [PTR_WIDTH:0] ptr_read,
    output en_read,
    output flag_empty,
    output flag_uf
);

reg [PTR_WIDTH:0] reg_read_ptr;
reg reg_uf;

assign ptr_read = reg_read_ptr;
assign flag_empty = (reg_read_ptr == ptr_write);
assign en_read = req_read;
assign flag_uf = reg_uf;

wire [PTR_WIDTH-1:0] read_ptr_mod = reg_read_ptr[PTR_WIDTH-1:0];

always @(posedge clk_read or negedge reset_n) begin
    if (!reset_n) begin
        reg_read_ptr <= {PTR_WIDTH+1{1'b0}};
        reg_uf <= 1'b0;
    end else if (req_read && !flag_empty) begin
        if (read_ptr_mod == {(PTR_WIDTH){1'b1}}) begin
            reg_read_ptr <= {~reg_read_ptr[PTR_WIDTH], {(PTR_WIDTH){1'b0}}};
        end else begin
            reg_read_ptr <= reg_read_ptr + 1;
        end
        reg_uf <= 1'b0;
    end else if (req_read && flag_empty) begin
        reg_uf <= 1'b1;
    end
end

endmodule */

