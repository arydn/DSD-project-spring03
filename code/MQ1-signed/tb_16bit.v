module tb_16bit;
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg signed [15:0] data_in;
    wire signed [15:0] data_out;
    wire empty;
    wire full;
    wire overflow;

    stack #(
        .DATA_WIDTH(16),
        .STACK_DEPTH(16)
    ) stack (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full),
        .overflow(overflow)
    );

    integer i; // Loop variable declaration

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        opcode = 3'b000;
        data_in = 0;

        // Apply reset
        rst = 1;
        #10;
        rst = 0;
        #10;

        // Push some data
        opcode = 3'b110; // Push
        data_in = 16'sd3; // 3 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 16'sd5; // 5 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform addition (without overflow)
        opcode = 3'b100; // Add
        #10;
        if (overflow) begin
            $display("Addition result: %d + %d = %d, Overflow: 1", 3, 5, data_out);
        end else begin
            $display("Addition (without overflow) result: %d + %d = %d", 3, 5, data_out);
        end

        // Push more data for overflow test
        opcode = 3'b110; // Push
        data_in = 16'sd32767; // 32767 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 16'sd2; // 2 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform addition (with overflow)
        opcode = 3'b100; // Add
        #10;
        if (overflow) begin
            $display("Addition (overflow) result: %d + %d = %d, Overflow: 1", 32767, 2, data_out);
        end else begin
            $display("Addition (without overflow) result: %d + %d = %d", 32767, 2, data_out);
        end

        // Pop values after addition
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after addition", data_out);

        // Push negative numbers for addition overflow test
        opcode = 3'b110; // Push
        data_in = -16'sd32768; // -32768 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = -16'sd1; // -1 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform addition (with overflow)
        opcode = 3'b100; // Add
        #10;
        if (overflow) begin
            $display("Addition (overflow) result: %d + %d = %d, Overflow: 1", -32768, -1, data_out);
        end else begin
            $display("Addition (without overflow) result: %d + %d = %d", -32768, -1, data_out);
        end

        // Pop values after addition
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after addition", data_out);

        // Push data for multiplication tests
        opcode = 3'b110; // Push
        data_in = 16'sd10; // 10 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 16'sd12; // 12 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (without overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication result: %d * %d = %d, Overflow: 1", 10, 12, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 10, 12, data_out);
        end

        // Push data for multiplication overflow tests
        opcode = 3'b110; // Push
        data_in = 16'sd256; // 256 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 16'sd128; // 128 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (with overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication (overflow) result: %d * %d = %d, Overflow: 1", 256, 128, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 256, 128, data_out);
        end

        // Push data for additional multiplication overflow tests
        opcode = 3'b110; // Push
        data_in = 16'sd300; // 300 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 16'sd200; // 200 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (with overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication (overflow) result: %d * %d = %d, Overflow: 1", 300, 200, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 300, 200, data_out);
        end

        // Push data for signed multiplication tests
        opcode = 3'b110; // Push
        data_in = -16'sd20; // -20 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = -16'sd5; // -5 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (without overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication result: %d * %d = %d, Overflow: 1", -20, -5, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", -20, -5, data_out);
        end

        // Push data for signed multiplication tests
        opcode = 3'b110; // Push
        data_in = 16'sd7; // 7 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = -16'sd8; // -8 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (with overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication result: %d * %d = %d, Overflow: 1", 7, -8, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 7, -8, data_out);
        end

        // Pop a value after multiplication
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after multiplication", data_out);

        // Test cases without overflow

        // Push data for addition without overflow
        opcode = 3'b110; // Push
        data_in = 16'sd1; // 1 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 16'sd2; // 2 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform addition (without overflow)
        opcode = 3'b100; // Add
        #10;
        if (overflow) begin
            $display("Addition result: %d + %d = %d, Overflow: 1", 1, 2, data_out);
        end else begin
            $display("Addition (without overflow) result: %d + %d = %d", 1, 2, data_out);
        end

        // Pop values after addition
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after addition", data_out);

        // Final stack contents display
        $display("Final stack contents:");
        for (i = 0; i < stack.sp; i = i + 1) begin
            $display("stack_mem[%0d] = %0d", i, stack.stack_mem[i]);
        end

        // End of simulation
        $stop;
    end
endmodule
