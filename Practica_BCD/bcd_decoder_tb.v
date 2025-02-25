
module bcd_decoder_tb #(parameter N = 10, SEG = 7, IT = 10)();

reg [N-1:0] bin_sw;

wire [0:SEG -1] d_unidades;
wire [0:SEG -1] d_decenas;
wire [0:SEG -1] d_centenas;
wire [0:SEG -1] d_unidadmillar;

bcd_decoder DUT(
	.switches(bin_sw),
	.display_unidades(d_unidades),
	.display_decenas(d_decenas),
	.display_centenas(d_centenas),
	.display_unidades_millar(d_unidadmillar)
	);
	
task set_input();
	begin
	bin_sw = $urandom_range(0,2**N-1);
	$display("Valor a probar = %d", bin_sw);
	#10;
	end
endtask

	integer i;
	
	initial 
		begin
			for(i = 0; i < IT; i = i + 1)
			begin
				set_input();
			end
		end
endmodule