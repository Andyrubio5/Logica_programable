
module clk_div #(parameter FREQ = 1_000)( 

	input clk,
	input rst,
	output reg clk_div
	);
	
localparam constanN = 50_000_000;

localparam count_max = (constanN/2*FREQ);

reg [31:0] count;


always @ (posedge clk or posedge rst)
begin
	if (rst == 1)
		count <= 32'b0;
	else if (count == constanN - 1)
		count <= 32'b0;
	else 
		count <= count + 1;
end		
always @ (posedge clk or posedge rst)
begin
	if (rst==1)
		clk_div <= 1'b0;
	else if(count == constanN - 1)
		clk_div <= ~clk_div;
	else 
		clk_div <= clk_div;
end
endmodule