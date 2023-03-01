module sincos (
	input wire clk_in,
	input wire signed [31:0] angle,
	output reg signed[31:0] sin,
	output reg signed[31:0] cos,
	output reg [31:0] trigonomethric_one
);

parameter N = 14;
parameter K = 32'b00_100110110111000101110101100011; //scaling factor

wire signed[31:0] atan_table[0:14];

assign atan_table[0] = 32'b00_111111010010010000111111011011; //signed_bit->0.0.110010010000111111011010101000 -> 0.785398163
assign atan_table[1] = 32'b00_111110111011010110001100111000;
assign atan_table[2] = 32'b00_111110011110101101101110110000;
assign atan_table[3] = 32'b00_111101111111101010110111010101;
assign atan_table[4] = 32'b00_111101011111111010101011011110;
assign atan_table[5] = 32'b00_000001111111111101010101011011;
assign atan_table[6] = 32'b00_000000111111111111101010101010;
assign atan_table[7] = 32'b00_000000011111111111111101010101;
assign atan_table[8] = 32'b00_000000001111111111111111101010;
assign atan_table[9] = 32'b00_000000000111111111111111111100;
assign atan_table[10] = 32'b00_000000000011111111111111111111;
assign atan_table[11] = 32'b00_000000000001111111111111111111;
assign atan_table[12] = 32'b00_000000000000111111111111111111;
assign atan_table[13] = 32'b00_000000000000011111111111111111;
assign atan_table[14] = 32'b00_000000000000001111111111111111;

reg signed[31:0] x[0:N], y[0:N], z[0:N], x_shifted, y_shifted, sinx, cosx;
reg signed[63:0] sin_factor, cos_factor; //factor for multiplication
reg [61:0] sin_factor_power, cos_factor_power;
reg sign;
integer i;

always @*
begin
	x[0] = 32'b01_000000000000000000000000000000;
	y[0] = 32'b00_000000000000000000000000000000;
	z[0] = angle;
	sign = 1'b1; //1-positive, 0-negative
	for(i = 0;i<N;i=i+1)
	begin
		if(z[i] < 0)
			sign = 1'b1;
		else
			sign = 1'b0;
		
		x_shifted = x[i] >> i;
		y_shifted = y[i] >> i;
		
		x[i+1] = sign ? x[i] + y_shifted : x[i] - y_shifted;
		y[i+1] = sign ? y[i] - x_shifted : y[i] + x_shifted;
		z[i+1] = sign ? z[i] + atan_table[i] : z[i] - atan_table[i];
	end
	cos_factor = x[i] * K;
	sin_factor = y[i] * K;
	cosx = cos_factor[47:16];
	sinx = sin_factor[47:16];
	
	cos_factor = x[i][31:1] * x[i][31:1];
	sin_factor = y[i][31:1] * y[i][31:1];
	trigonomethric_one = cos_factor[46:15] + sin_factor[46:15];
end


always@(posedge clk_in)
begin
	sin <= y[i];
	cos <= x[i];
end


endmodule