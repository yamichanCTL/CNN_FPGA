`timescale 100 ns / 10 ps

module floatMult_TB ();

reg [15:0] floatA;
reg [15:0] floatB;
wire [15:0] product;

initial begin
	
	// 4 * 5
	#0
	floatA = 16'h4400;
	floatB = 16'h4500;

	// 0.0004125 * 0
	#10
	floatA = 16'h0EC2;
	floatB = 16'h0000;

	#10
	$stop;
end

floatMult16 FM
(
	.floatA(floatA),
	.floatB(floatB),
	.product(product)
);

endmodule
