`timescale 1ns / 1ps

module Memory #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 4) (
    input [DATA_WIDTH-1:0] input_data,
    input [ADDR_WIDTH-1:0] addr_read,
    input [ADDR_WIDTH-1:0] addr_write,
    input enable_read,
    input enable_write,
    input clk_read,         
    input clk_write,
    output [DATA_WIDTH-1:0] output_data
); 

reg [DATA_WIDTH-1:0] memory_array [(2**ADDR_WIDTH)-1:0]; 
reg [DATA_WIDTH-1:0] output_data_reg;

assign output_data = output_data_reg;

always @(posedge clk_write) 
begin
    if (enable_write && addr_write < (2**ADDR_WIDTH))
        memory_array[addr_write] <= input_data;
    else if (enable_write)
        $display("Error: Invalid write address %h", addr_write);
end

always @(posedge clk_read)
 begin
    if (enable_read && addr_read < (2**ADDR_WIDTH))
        output_data_reg <= memory_array[addr_read];
    else if(enable_read)
        $display("Error: Invalid read address %h", addr_read);
end

/*if (enable_write && enable_read && addr_write == addr_read)
    $display("Warning: Simultaneous read and write to address %h", addr_write);*/

endmodule
