module And (input wire [31:0] A, B, output reg [31: 0] result);

	initial begin
		integer i;
		for (i = 0; i < 32; i = i + 1) begin
			assign result [i] = A [i] & B [i];
		end
	end
endmodule


module Or (input wire [31:0] A, B, output reg [31: 0] result);

	initial begin
		integer i;
		for (i = 0; i < 32; i = i + 1) begin
			result [i] = A [i] | B [i];
		end
	end
endmodule


module CLA (input wire [31:0] A, B, output wire [32: 0] result, output wire carry_out);

	initial begin
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
	
		result = sum;
		carry_out = C[32];
	end

endmodule


module SeqMultiplier (input wire [31:0] M, Q, output wire [63: 0] result);

	CLA adder (
				.A(M),
				.B(acc),
				.result (tmp),
				.carry_out (carry)
				);
	
	initial begin
		reg [31:0] acc;
		reg [31:0] tmp;
		reg carry;
		integer i;
		for (i = 0; i < 32; i = i + 1) begin
			acc[i] = 0;
		end
		
		for (i = 0; i < 32; i = i + 1) begin
			if (Q[0] == 1) begin
				/* 32 bit adder to add M with A, store 32 bit sum in A,
					store carry out in reg carry*/
			end
			Q = Q >> 1;
			if (M[0] == 1)
				Q[31] = 1;
			acc = acc >> 1;
			if (carry == 1)
				S[31] = 1;
			carry = carry >> 1;
		end
		result = {acc, Q};
	end
endmodule
