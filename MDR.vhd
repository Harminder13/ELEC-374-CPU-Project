// MDR 2-1 Mux and MDR Data Register


module MDR #(parameter N=32)(
    input wire [N-1:0] BusMuxOut, MDataIn,
    input wire Read,
	 input wire clk,          // Synchronous clock input
    input wire MDRin,        // Control signal to enable MDR update 
	 input wire Clear,        // Clear signal 
    output reg [N-1:0] InputD,
    output reg [N-1:0] Q
);

// Combinational Mux Logic
assign InputD = Read ? MDataIn : BusMuxOut;

// Register Update
always @(posedge clk)
begin 
		if (Clear)
			Q <= {N{1'B0}}; //Clear Q to all zeros 
		else if (MDRin)
			Q <= InputD;
end


// Output Q can go to BusMuxIn-MDR, or to memory chip.

endmodule   
