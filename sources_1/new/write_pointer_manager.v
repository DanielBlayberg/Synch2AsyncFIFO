`timescale 1ns / 1ps

module write_pointer_manager #(parameter PTR_WIDTH = 4) (
    input clk_write,
    input reset_n,
    input req_write,
    input [PTR_WIDTH-1:0] ptr_read, 
    output [PTR_WIDTH-1:0] ptr_write,  
    output en_write,             
    output flag_full,
    output flag_of
);

reg [PTR_WIDTH-1:0] reg_write_ptr;    
reg reg_of;
wire [PTR_WIDTH-1:0] next_write_ptr;

assign ptr_write = reg_write_ptr;
assign next_write_ptr = reg_write_ptr + 1;   
assign flag_full = (ptr_read == next_write_ptr) ? 1'b1 : 1'b0;
assign en_write = req_write;
assign flag_of = reg_of;

always @(posedge clk_write or negedge reset_n) begin
    if (!reset_n) begin
        reg_of <= 1'b0;
        reg_write_ptr <= {PTR_WIDTH{1'b0}};
    end else if (en_write && !flag_full) begin
        reg_of <= 1'b0;
        reg_write_ptr <= reg_write_ptr + 1;
    end else if (en_write && flag_full) begin
        reg_of <= 1'b1;
    end
end

endmodule



/* Circular FIFO

`timescale 1ns / 1ps

module write_pointer_manager #(parameter PTR_WIDTH = 4) (
    input clk_write,
    input reset_n,
    input req_write,
    input [PTR_WIDTH:0] ptr_read, 
    output [PTR_WIDTH:0] ptr_write, 
    output en_write,             
    output flag_full,
    output flag_of
);

reg [PTR_WIDTH:0] reg_write_ptr;
reg reg_of;
wire [PTR_WIDTH:0] next_write_ptr;


assign ptr_write = reg_write_ptr; 
assign next_write_ptr = reg_write_ptr + 1;  
assign flag_full = (ptr_read == next_write_ptr) ? 1'b1 : 1'b0; 
assign en_write = req_write;
assign flag_of = reg_of;

wire [PTR_WIDTH-1:0] write_ptr_mod = reg_write_ptr[PTR_WIDTH-1:0];

always @(posedge clk_write or negedge reset_n) begin
    if (!reset_n) begin
        reg_of <= 1'b0;
        reg_write_ptr <= {PTR_WIDTH+1{1'b0}}; 
    end else if (en_write && !flag_full) begin
        reg_of <= 1'b0;
        if (write_ptr_mod == {(PTR_WIDTH){1'b1}}) begin 
            reg_write_ptr <= {~reg_write_ptr[PTR_WIDTH], {(PTR_WIDTH){1'b0}}}; 
        end else begin
            reg_write_ptr <= reg_write_ptr + 1; 
        end
    end else if (en_write && flag_full) begin
        reg_of <= 1'b1; 
    end
end

endmodule */
