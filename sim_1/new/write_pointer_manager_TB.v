`timescale 1ns / 1ps

module write_pointer_manager_TB();

    reg clk_write;
    reg reset_n;
    reg req_write;
    reg [3:0] ptr_read;
    wire [3:0] ptr_write;
    wire en_write;
    wire flag_full;
    wire flag_of;

    write_pointer_manager uut (
        .clk_write(clk_write),
        .reset_n(reset_n),
        .req_write(req_write),
        .ptr_read(ptr_read),
        .ptr_write(ptr_write),
        .en_write(en_write),
        .flag_full(flag_full),
        .flag_of(flag_of)
    );

    initial clk_write = 0;
    always #5 clk_write = ~clk_write;

    initial
    begin
        reset_n = 1;
        repeat (2) 
        begin
            #($random % 5 + 10) reset_n = 0; 
        end
        reset_n = 1;
    end

    initial 
    begin
        req_write = 0;
        forever #15 req_write = ~req_write;
    end

    initial
     begin
        ptr_read = 4'd0;
        forever #10 ptr_read = ptr_read + 1;
    end

    initial
     begin
        #200; // Simulation ends after 200 time units
        $display("Simulation Results:");
        $display("Final ptr_write: %b", ptr_write);
        $display("Final flag_full: %b", flag_full);
        $display("Final flag_of: %b", flag_of);
        $stop;
    end

endmodule



   

