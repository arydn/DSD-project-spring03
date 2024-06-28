module stack #(parameter DATA_WIDTH = 8, parameter STACK_DEPTH = 16) (
    input clk,
    input rst,
    input [2:0] opcode,
    input signed [DATA_WIDTH-1:0] data_in,
    output reg signed [DATA_WIDTH-1:0] data_out,
    output empty,
    output full,
    output reg overflow
);

    reg signed [DATA_WIDTH-1:0] stack_mem [0:STACK_DEPTH-1];
    reg [$clog2(STACK_DEPTH)-1:0] sp;

    reg signed [DATA_WIDTH-1:0] sum;
    reg signed [2*DATA_WIDTH-1:0] product;

    assign empty = (sp == 0);
    assign full = (sp == STACK_DEPTH);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            overflow <= 0;
            data_out <= 0;
        end else begin
            overflow <= 0; // Reset overflow flag
            if (opcode == 3'b110) begin // Push
                if (!full) begin
                    stack_mem[sp] <= data_in;
                    sp <= sp + 1;
                end
            end else if (opcode == 3'b111) begin // Pop
                if (!empty) begin
                    data_out <= stack_mem[sp-1];
                    sp <= sp - 1;
                end
            end else if (opcode == 3'b100) begin // Add
                if (sp > 1) begin
                    // Perform addition and check for overflow
                    sum = stack_mem[sp-2] + stack_mem[sp-1];
                    // Check for overflow
                    if ((stack_mem[sp-2] > 0 && stack_mem[sp-1] > 0 && sum < 0) ||
                        (stack_mem[sp-2] < 0 && stack_mem[sp-1] < 0 && sum > 0)) begin
                        overflow <= 1;
                    end
                    data_out <= sum;
                end
            end else if (opcode == 3'b101) begin // Multiply
                if (sp > 1) begin
                    // Perform multiplication and check for overflow
                    product = stack_mem[sp-2] * stack_mem[sp-1];
                    // Check for overflow by comparing to max and min values of the original data width
                    if (product > $signed({1'b0, {(DATA_WIDTH-1){1'b1}}}) || 
                        product < $signed({1'b1, {(DATA_WIDTH-1){1'b0}}})) begin
                        overflow <= 1;
                    end
                    data_out <= product[DATA_WIDTH-1:0]; // Truncate to the original data width
                end
            end
        end
    end
endmodule

