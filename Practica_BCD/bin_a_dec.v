
module bin_a_dec #(parameter N = 10, SEG = 7)(
	
	input [N-1:0] bin,
	
	output reg [0:SEG - 1] um,cen,dec,un
	);

	 always @ (*) 
		begin
		 um = bin % 10000 /1000;
		 cen = bin % 1000 / 100;
		 dec = bin % 100 /10;
		 un = bin % 10;
		 end
endmodule