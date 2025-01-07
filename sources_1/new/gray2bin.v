module gray2bin #(parameter WIDTH = 4) (
    input [WIDTH-1:0] gray_in,
    output [WIDTH-1:0] binary_out
);
    wire [WIDTH-1:0] temp;
    assign temp[WIDTH-1] = gray_in[WIDTH-1]; // MSB remains the same
    genvar i;
    generate
        for (i = 0; i < WIDTH-1; i = i + 1) begin : gray_to_bin
            assign temp[WIDTH-2-i] = gray_in[WIDTH-2-i] ^ temp[WIDTH-1-i];
        end
    endgenerate
    assign binary_out = temp;
endmodule
