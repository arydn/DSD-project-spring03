module tb_4bit;
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg signed [3:0] data_in;
    wire signed [3:0] data_out;
    wire empty;
    wire full;
    wire overflow;

    stack #(
        .DATA_WIDTH(4),
        .STACK_DEPTH(16)
    ) st (
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
        data_in = 4'sd3; // 3 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 4'sd5; // 5 in decimal
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
        data_in = 4'sd7; // 7 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 4'sd8; // 8 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform addition (with overflow)
        opcode = 3'b100; // Add
        #10;
        if (overflow) begin
            $display("Addition (overflow) result: %d + %d = %d, Overflow: 1", 7, 8, data_out);
        end else begin
            $display("Addition (without overflow) result: %d + %d = %d", 7, 8, data_out);
        end

        // Pop values after addition
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after addition", data_out);

        // Push negative numbers for addition overflow test
        opcode = 3'b110; // Push
        data_in = -4'sd7; // -7 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = -4'sd8; // -8 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform addition (with overflow)
        opcode = 3'b100; // Add
        #10;
        if (overflow) begin
            $display("Addition (overflow) result: %d + %d = %d, Overflow: 1", -7, -8, data_out);
        end else begin
            $display("Addition (without overflow) result: %d + %d = %d", -7, -8, data_out);
        end

        // Pop values after addition
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after addition", data_out);

        // Push data for multiplication tests
        opcode = 3'b110; // Push
        data_in = 4'sd3; // 3 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 4'sd3; // 3 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (without overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication result: %d * %d = %d, Overflow: 1", 3, 3, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 3, 3, data_out);
        end

        // Push data for multiplication overflow tests
        opcode = 3'b110; // Push
        data_in = 4'sd7; // 7 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 4'sd2; // 2 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (with overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication (overflow) result: %d * %d = %d, Overflow: 1", 7, 2, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 7, 2, data_out);
        end

        // Push data for signed multiplication tests
        opcode = 3'b110; // Push
        data_in = -4'sd3; // -3 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = -4'sd4; // -4 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (without overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication result: %d * %d = %d, Overflow: 1", -3, -4, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", -3, -4, data_out);
        end

        // Push data for signed multiplication tests
        opcode = 3'b110; // Push
        data_in = 4'sd3; // 3 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = -4'sd4; // -4 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (without overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication result: %d * %d = %d, Overflow: 1", 3, -4, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 3, -4, data_out);
        end

        // Pop a value after multiplication
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after multiplication", data_out);

        // Test cases without overflow

        // Push data for addition without overflow
        opcode = 3'b110; // Push
        data_in = 4'sd1; // 1 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 4'sd2; // 2 in decimal
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

        // Push data for multiplication without overflow
        opcode = 3'b110; // Push
        data_in = 4'sd2; // 2 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        data_in = 4'sd3; // 3 in decimal
        $display("Pushing data %d onto the stack", data_in);
        #10;

        // Perform multiplication (without overflow)
        opcode = 3'b101; // Multiply
        #10;
        if (overflow) begin
            $display("Multiplication result: %d * %d = %d, Overflow: 1", 2, 3, data_out);
        end else begin
            $display("Multiplication (without overflow) result: %d * %d = %d", 2, 3, data_out);
        end

        // Pop values after multiplication
        opcode = 3'b111; // Pop
        #10;
        $display("Popping data %d from the stack after multiplication", data_out);

        // Check for stack empty
        opcode = 3'b111; // Pop
        #10;
        if (empty) begin
            $display("Stack is empty, cannot pop any more data");
        end else begin
            $display("Popping data %d from the stack", data_out);
        end

        // Final stack contents display
        $display("Final stack contents:");
        for (i = 0; i < st.sp; i = i + 1) begin
            $display("stack_mem[%0d] = %0d", i, st.stack_mem[i]);
        end

        // End of simulation
        $stop;
    end
endmodule
