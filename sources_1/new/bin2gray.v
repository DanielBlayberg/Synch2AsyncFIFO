module bin2gray #(parameter WIDTH = 4) (
    input [WIDTH-1:0] binary_in,
    output [WIDTH-1:0] gray_out
);
    assign gray_out = binary_in ^ (binary_in >> 1);
endmodule

/*module bin2gray #(parameter WIDTH = 4) (
    input [WIDTH-1:0] binary_in,
    output [WIDTH-1:0] gray_out
);
    wire [WIDTH-1:0] temp;
    assign temp = {1'b0, binary_in[WIDTH-1:1]};
    assign gray_out = temp ^ binary_in;
endmodule */
