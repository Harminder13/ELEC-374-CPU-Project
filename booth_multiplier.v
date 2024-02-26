module booth_multiplier(
    input signed [31:0] multiplicand,       // Input: 32-bit signed multiplicand
    input signed [31:0] multiplier,        // Input: 32-bit signed multiplier
    input clk,                              // Input: Clock signal
    input reset,                            // Input: Reset signal
    output reg signed [31:0] UpperBits, LowerBits         // Outputs for the result's high and low parts
);

    reg signed [63:0] product_reg;         // Register to hold the product
    reg signed [31:0] recoded_multiplier;  // Register to store the recoded multiplier
    reg [5:0] counter;                     // Counter to control the looping 

    // Clocked process to perform the multiplication
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Reset product and counter
            product_reg <= 0;
            counter <= 0;
        end
        else if (counter <32) begin
            // Sign extend multiplicand to allow for storage of larger numbers
            reg signed [63:0] extended_multiplicand;
            extended_multiplicand = {{32{multiplicand[31]}}, multiplicand};
 
            // Booth multiplier recoding table
            case ({multiplier[counter], (counter == 0) ? multiplier[0] : multiplier[counter-1]})
                2'b11: recoded_multiplier[counter] <= 0;   // no adjustment
                2'b10: recoded_multiplier[counter] <= 1;   // +1 adjustment
                2'b01: recoded_multiplier[counter] <= -1;  // -1 adjustment
                2'b00: recoded_multiplier[counter] <= 0;   // no adjustment
            endcase

            // Perform addition or subtraction based on recoded multiplier
            case (recoded_multiplier[counter])
                1: product_reg <= product_reg + extended_multiplicand; // Addition
               -1: product_reg <= product_reg - extended_multiplicand; // Subtraction
                default: ; // No adjustment
            endcase

            // Arithemtic shift product_reg to the right by one bit
            product_reg <= product_reg >>> 1;


            // Increment counter
            counter <= counter + 1;
        end
        else if (counter == 32) begin
            UpperBits <= product_reg[63:32];  // Assigning the upper bits to the register 
            LowerBits <= product_reg[31:0];    // Assigning the lower bits to the register 
            counter <= 0; // Resetting the counter for the next operation
        end
    end
endmodule
