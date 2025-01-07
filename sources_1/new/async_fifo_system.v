`timescale 1ns / 1ps

module async_fifo_system #(
    parameter DATA_WIDTH = 32,
    parameter PTR_WIDTH = 4
)(
    input reset_i,
    input clk_write_i,
    input clk_read_i,
    input write_req_i,
    input read_req_i,
    input [DATA_WIDTH-1:0] data_in_i,
    output [DATA_WIDTH-1:0] data_out_o,
    output empty_o,
    output full_o,
    output uf_o,
    output of_o
);

    wire [PTR_WIDTH-1:0] mem_ptr_read;
    wire [PTR_WIDTH-1:0] mem_ptr_write;
    wire mem_read;
    wire mem_write;

    wire [PTR_WIDTH-1:0] gray_ptr_write_sync;
    wire [PTR_WIDTH-1:0] gray_ptr_write;
    wire [PTR_WIDTH-1:0] binary_ptr_write_sync;

    wire [PTR_WIDTH-1:0] gray_ptr_read_sync;
    wire [PTR_WIDTH-1:0] gray_ptr_read;
    wire [PTR_WIDTH-1:0] binary_ptr_read_sync;

    Memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(PTR_WIDTH)
    ) fifo_memory (
        .input_data(data_in_i),
        .addr_read(mem_ptr_read),
        .addr_write(mem_ptr_write),
        .enable_read(mem_read),
        .enable_write(mem_write),
        .clk_read(clk_read_i),
        .clk_write(clk_write_i),
        .output_data(data_out_o)
    );

    write_pointer_manager #(
        .PTR_WIDTH(PTR_WIDTH)
    ) write_ctrl (
        .clk_write(clk_write_i),
        .reset_n(reset_i),
        .req_write(write_req_i),
        .ptr_read(binary_ptr_read_sync),
        .ptr_write(mem_ptr_write),
        .en_write(mem_write),
        .flag_full(full_o),
        .flag_of(of_o)
    );

    read_pointer_manager #(
        .PTR_WIDTH(PTR_WIDTH)
    ) read_ctrl (
        .clk_read(clk_read_i),
        .reset_n(reset_i),
        .req_read(read_req_i),
        .ptr_write(binary_ptr_write_sync),
        .ptr_read(mem_ptr_read),
        .en_read(mem_read),
        .flag_empty(empty_o),
        .flag_uf(uf_o)
    );

    synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) write_synchronizer (
        .clk_src(clk_write_i),
        .clk_dest(clk_read_i),
        .reset_n(reset_i),
        .data_in(gray_ptr_write),
        .data_out(gray_ptr_write_sync)
    );

    synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) read_synchronizer (
        .clk_src(clk_read_i),
        .clk_dest(clk_write_i),
        .reset_n(reset_i),
        .data_in(gray_ptr_read),
        .data_out(gray_ptr_read_sync)
    );

    bin2gray #(
        .WIDTH(PTR_WIDTH)
    ) bin_to_gray_write (
        .binary_in(mem_ptr_write),
        .gray_out(gray_ptr_write)
    );

    gray2bin #(
        .WIDTH(PTR_WIDTH)
    ) gray_to_bin_write (
        .gray_in(gray_ptr_write_sync),
        .binary_out(binary_ptr_read_sync)
    );

    bin2gray #(
        .WIDTH(PTR_WIDTH)
    ) bin_to_gray_read (
        .binary_in(mem_ptr_read),
        .gray_out(gray_ptr_read)
    );

    gray2bin #(
        .WIDTH(PTR_WIDTH)
    ) gray_to_bin_read (
        .gray_in(gray_ptr_read_sync),
        .binary_out(binary_ptr_write_sync)
    );

endmodule
