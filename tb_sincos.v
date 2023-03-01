module tb_sincos();

wire signed[31:0] sin, cos, trigonomethric_one;
reg signed[31:0] angle;
reg refclk;

sincos u_sincos (
	.clk_in(refclk),
	.angle(angle),
	.sin(sin),
	.cos(cos),
	.trigonomethric_one(trigonomethric_one)
);


initial begin
	angle = 32'b01_000000000000000000000000000000;
	forever
	begin
		refclk = 0;
		#10;
		refclk = 1;
		#10;
	end
end


endmodule