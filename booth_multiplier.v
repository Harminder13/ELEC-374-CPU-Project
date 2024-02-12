module booth_multiplier(
    input signed [31:0] multiplicand,
    input signed [31:0] multiplier,
    input clk,
    input reset,
    output signed [63:0] product
);

    reg signed [63:0] product_reg;
    reg signed [31:0] recoded_multiplier;
    integer i;
    reg signed [63:0] extended_multiplicand;

    always @(*) begin
        // Booth multiplier recoding table
        for (i = 0; i < 32; i = i + 1) begin
            case ({multiplier[i], (i == 0) ? multiplier[0] : multiplier[i-1]})
                2'b11: recoded_multiplier[i] = 0;   // no adjustment
                2'b10: recoded_multiplier[i] = 1;   // +1 adjustment
                2'b01: recoded_multiplier[i] = -1;  // -1 adjustment
                2'b00: recoded_multiplier[i] = 0;   // no adjustment
            endcase
        end
    end

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            product_reg <= 0;
        end
        else begin
            // Sign extend multiplicand to match the width of product_reg
            extended_multiplicand = {{32{multiplicand[31]}}, multiplicand};

            // Add or subtract sign-extended multiplicand based on recoded multiplier
            case (recoded_multiplier)
                1: product_reg <= product_reg + extended_multiplicand; // Addition
               -1: product_reg <= product_reg - extended_multiplicand; // Subtraction
                default: product_reg <= product_reg; // No adjustment
            endcase
            
            // Shift product_reg to the left by one bit
            product_reg <= {product_reg[62:0], 1'b0};
        end
    end

    assign product = product_reg;

endmodule
