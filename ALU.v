module ALU (
	input wire[31:0] A,
	input wire[31:0] B,
	input wire[31:0] Op,
	output reg[31:0] alu_out,
	output reg[63:0] alu_out2);
	
always @(Op) begin
	case (Op)
		4'b0000: alu_out = CLA (A, B);
		4'b0001: alu_out = subtract (A, B);
		4'b0010: alu_out = A/B;
		4'b0011: alu_out2 = Mul(A,B);
		4'b0100: alu_out = And (A, B);
		4'b0101: alu_out = Or (A, B);
		4'b0110: alu_out = LogicalRightShift (A);
		4'b0111: alu_out = ArithmeticRightShift (A);
		4'b1000: alu_out = LeftShift (A);
		4'b1001: alu_out = RotateRight (A);
		4'b1010: alu_out = RotateLeft (A);

		default alu_out = 1'bz;
	endcase
end

function [31:0] And (input [31:0] A, B);
      integer i;
		reg[31:0] result;
	begin
		
		for (i = 0; i < 32; i = i + 1) begin
			 result [i] = A [i] & B [i];
		end
		assign And = result;
	end
endfunction


function [31:0] Or (input [31:0] A, B);
	
	integer i;
	reg[31:0] result;
	
	begin
		for (i = 0; i < 32; i = i + 1) begin
			result [i] = A [i] | B [i];
		end
		assign Or = result;
	end
endfunction


function [31:0] CLA (input [31:0] A, B);
	
	reg [32:0] C;
	reg [31:0] G, P, sum;
	integer i;
	
	begin
		
		 C[0] = 0;
		for (i = 0; i < 32; i = i + 1) begin
			G[i] = A[i] & B[i];
			P[i] = A[i] | B[i];
			C[i + 1] = G[i] | (P[i] & C[i]);
			sum[i] = A[i] ^ B[i] ^ C[i];
		end
		assign CLA = sum;
	end

endfunction

function [31:0] subtract (input [31:0] A, B);

	B = ~B + 1;
	reg [32:0] C;
	reg [31:0] G, P, diff;
	integer i;
	
	begin
		
		C[0] = 0;
		for (i = 0; i < 32; i = i + 1) begin
			G[i] = A[i] & B[i];
			P[i] = A[i] | B[i];
			C[i + 1] = G[i] | (P[i] & C[i]);
			diff[i] = A[i] ^ B[i] ^ C[i];
		end
		
		if (C [32] == 0)
			diff = ~diff + 1;
			
		assign subtract = diff;
	end

endfunction

function [31:0] LogicalRightShift (input [31:0] unshifted);
	
	reg[31:0] shifted;
	integer i;
	begin
		for (i = 0; i < 31; i = i + 1) begin
			shifted [i] = unshifted [i + 1];
		end
		shifted [31] = 0;
		assign LogicalRightShift = shifted;
	end
endfunction


function [31:0] ArithmeticRightShift (input [31:0] unshifted);
	
	reg[31:0] shifted;
	integer i;
	
	begin
		for (i = 0; i < 31; i = i + 1) begin
			shifted [i] = unshifted [i + 1];
		end
		shifted [31] = unshifted [31];
		assign ArithmeticRightShift = shifted;
	end
endfunction


function [31:0] LeftShift (input [31:0] unshifted);

   reg[31:0] shifted;
	integer i;
	begin
		for (i = 1; i < 32; i = i + 1) begin
			shifted [i] = unshifted [i - 1];
		end
		shifted [0] = 0;
		assign LeftShift = shifted;
	end
endfunction


function [31:0] RotateRight (input [31:0] unrotated);
	integer i;
	reg[31:0] rotated;
	
	begin
		
		for (i = 0; i < 31; i = i + 1) begin
			rotated [i] = unrotated [i + 1];
		end
		rotated [31] = unrotated [0];
		assign RotateRight = rotated;
	end
endfunction


function [31:0] RotateLeft (input [31:0] unrotated);
	
	reg[31:0] rotated;
	integer i;
	
	begin
	
		for (i = 1; i < 32; i = i + 1) begin
			rotated [i] = unrotated [i - 1];
		end
		rotated [0] = unrotated [31];
		assign RotateLeft = rotated;
	end
endfunction

// Multiplicant= A , Multiplier= B
function [63:0] Mul (input [31:0] A, B);

	reg signed [63:0] product_reg;         
	reg signed [31:0] recoded_multiplier;  
	reg [5:0] counter; 
	reg signed [63:0] extended_multiplicand;
	extended_multiplicand = {{32{A[31]}}, A};
	
	integer prdouct_reg <=0;
	integer counter<=0;
	
	while (counter<32) begin 
	
		case ({B[counter], (counter == 0) ? B[0] : B[counter-1]})
			2'b11: recoded_multiplier[counter] <= 0;   // no adjustment
			2'b10: recoded_multiplier[counter] <= 1;   // +1 adjustment
			2'b01: recoded_multiplier[counter] <= -1;  // -1 adjustment
			2'b00: recoded_multiplier[counter] <= 0;   // no adjustment
		endcase

		case (recoded_multiplier[counter])
			1: product_reg <= product_reg + extended_multiplicand; // Addition
			-1: product_reg <= product_reg - extended_multiplicand; // Subtraction
			default: ; // No adjustment
		endcase
	
		product_reg <= product_reg >>> 1;
		counter <= counter + 1;
	end
	counter <= 0; 
	assign results = product_reg[63:0];     
	end
endfunction



























	
endmodule


