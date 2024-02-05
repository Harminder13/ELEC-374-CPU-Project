module alu2 (
	input wire[31:0] A,
	input wire[31:0] B,
	input wire[31:0] Op,
	output reg[31:0] alu_out);
	
always @(Op) begin
	case (Op)
		4'b0000: alu_out = A+B;
		4'b0001: alu_out = A-B;
		4'b0010: alu_out = A/B;
		4'b0011: alu_out = A*B;
		4'b0100: alu_out = A & B;
		4'b0101: alu_out = A | B;
		4'b0110: alu_out = A << 1;
		4'b0111: alu_out = A >> 1;
		4'b1000: alu_out = {A[30:0],A[31]};
		4'b1001: alu_out = {A[0],A[31:0]};
		4'b1010: alu_out = A | B;

		default alu_out = 1'bz;
	endcase
end

function [31:0] And (input wire [31:0] A, B);

	begin
		integer i;
		reg[31:0] result;
		for (i = 0; i < 32; i = i + 1) begin
			assign result [i] = A [i] & B [i];
		end
		assign And = result;
	end
endfunction


function [31:0] Or (input wire [31:0] A, B);

	begin
		integer i;
		reg[31:0] result;
		for (i = 0; i < 32; i = i + 1) begin
			result [i] = A [i] | B [i];
		end
		assign Or = result;
	end
endfunction


function [31:0] CLA (input wire [31:0] A, B);

	begin
		reg [32:0] C;
		reg [31:0] G, P, sum;
	
		integer i;
		assign C[0] = 0;
		for (i = 0; i < 32; i = i + 1) begin
			G[i] = A[i] & B[i];
			P[i] = A[i] | B[i];
			C[i + 1] = G[i] | (P[i] & C[i]);
			sum[i] = A[i] ^ B[i] ^ C[i];
		end
		assign CLA = sum;
	end

endfunction

function [31:0] LogicalRightShift (input wire [31:0] unshifted);

	begin
		reg[31:0] shifted;
		integer i;
		for (i = 0; i < 31; i = i + 1) begin
			shifted [i] = unshifted [i + 1];
		end
		shifted [31] = 0;
		assign LogicalRightShift = shifted;
	end
endfunction


function [31:0] ArithmeticRightShift (input wire [31:0] unshifted);

	begin
		reg[31:0] shifted;
		integer i;
		for (i = 0; i < 31; i = i + 1) begin
			shifted [i] = unshifted [i + 1];
		end
		shifted [31] = unshifted [31];
		assign ArithmeticRightShift = shifted;
	end
endfunction


function [31:0] LeftShift (input wire [31:0] unshifted);

	begin
		reg[31:0] shifted;
		integer i;
		for (i = 1; i < 32; i = i + 1) begin
			shifted [i] = unshifted [i - 1];
		end
		shifted [0] = 0;
		assign LeftShift = shifted;
	end
endfunction


function [31:0] RotateRight (input wire [31:0] unrotated);

	begin
	reg[31:0] rotated;
		integer i;
		for (i = 0; i < 31; i = i + 1) begin
			rotated [i] = unrotated [i + 1];
		end
		rotated [31] = unrotated [0];
		assign RotateRight = rotated;
	end
endfunction


function [31:0] RotateLeft (input wire [31:0] unrotated);
	
	begin
	reg[31:0] rotated;
		integer i;
		for (i = 1; i < 32; i = i + 1) begin
			rotated [i] = unrotated [i - 1];
		end;
		rotated [0] = unrotated [31];
		assign RotateLeft = rotated;
	end
endfunction

endmodule




//TestBench
module TB();
reg [31:0]A,B;
reg [3:0] Op;
wire [31:0] alu_out;

alu2 a1(A,B,Op,alu_out);

initial
begin
    Op = 4'b0000; A=12; B=6;
    #10;

    end

endmodule
