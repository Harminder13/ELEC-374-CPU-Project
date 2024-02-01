
module restoringDivider (
    input [31:0] dividend,
    input [31:0] divisor,
    input clk,
    input rst_n,
    output reg [31:0] quotient,
    output reg [31:0] remainder
);

    // We can assigne thease register to 4 of the R0 to R15 registers 
    reg [31:0] A;
    reg [31:0] M;
    reg [31:0] Q;
    reg [4:0] n;

    always @(posedge clk or negedge rst_n) 
	 
	 begin
        if (!rst_n) 
		  begin
            // Reset on active low
            A <= 32'b0;
            Q <= dividend;
            M <= divisor;
				// Initialize counter to the number of bits in dividend
            n <= 5'b1;  
            quotient <= 32'b0;
            remainder <= 32'b0;
			end 
			
			else begin
            // Main algorithm
				
				// Shift left {A, Q}, (This value will be updated immediately)
            {A, Q} = {A, Q} << 1; 
				//A = A - M, (This value will be updated immediately)
            A = A - M;             
				
				// Check sign bit of A
            if (A[31] == 0) 
				begin    
                // Set least significant bit(LSB) of Q as 0
                Q[0] <= 1'b0;

            end 
				
				else begin
                // Set LSB of Q as 1, and restore A
                Q[0] <= 1'b1;
					 // (This value will be updated immediately)
                A = A + M;
            end

            // Decrement count
            n <= n - 1;
				
				// Check if counter value n is zero
            if (n == 5'b0) 
				begin  
                // Result is in Q, and remainder is in A
                quotient <= Q;
                remainder <= A;
            end
        end
    end

endmodule
