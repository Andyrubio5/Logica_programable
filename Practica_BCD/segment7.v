
module segment7 (
	input [3:0] decoder_in,
	output reg [0:6] decoder_out
	
);

always @(*)
	begin 
		case(decoder_in)
		  0:decoder_out=7'b0000001;
		  1:decoder_out=7'b1001111;
		  2:decoder_out=7'b0010010;
		  3:decoder_out=7'b0000110;
		  4:decoder_out=7'b1001100;
		  5:decoder_out=7'b0100100;
		  6:decoder_out=7'b0100000;
		  7:decoder_out=7'b0001111;
		  8:decoder_out=7'b0000000;
		  9:decoder_out=7'b0000100;
		endcase
	end
endmodule