module seqMultiplier (
input [31:0] multuplicand,
input [31:0} multiplier,
input clk,
input rst_n,
output reg [63:0] product 
);

reg [31:0] A;
reg [31:0] Q;
reg [31:0] M;
reg C;
reg [31:0] temp;
integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset on active low
            A <= 32'b0;
            Q <= dividend;
            M <= divisor;
			C <= 1'b0
            multuplicand <= 32'b0;
            multiplier <= 32'b0;
			i=0;
        end 
		else begin 
		for (i=0; i<32; i=i+1) 
		if (Q[0]==1) 
		{A , C} = M + Q;
		{C, A, Q} = {C, A, Q} >> 1;
		}
		else if (Q[0]!=1)(
		{C, A, Q} = {C, A, Q} >> 1;
		{A , C} = M + Q;
		)
		end
		else begin
		product<= {A,Q}; 
		end
		endmodule 
