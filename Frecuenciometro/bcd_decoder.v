module bcd_decoder #(parameter N = 10, SEG = 7)(

    input [N-1:0] switches, // 10 switches de entrada
    
    output [0:SEG -1] display_unidades,  
    output [0:SEG -1] display_decenas, 
    output [0:SEG -1] display_centenas, 
    output [0:SEG -1] display_unidades_millar,
    output [0:SEG -1] display_decenas_millar,
    output [0:SEG -1] display_centenas_millar
);

 // Almacena y transmite los valores convertidos del número binario a decimal
 
wire [3:0] unidades;
wire [3:0] decenas;
wire [3:0] centenas; 
wire [3:0] unidades_millar; 
wire [3:0] decenas_millar;
wire [3:0] centenas_millar;

// Conversión de binario a decimal
bin_a_dec DUT(
    .bin(switches),
	 .cm(centenas_millar),
	 .dm(decenas_millar),
    .um(unidades_millar),
    .cen(centenas),
    .dec(decenas),
    .un(unidades)
);

// Decodificador para 7 segmentos

decoder_7_seg DISPLAY_UM (
    .decoder_in(unidades_millar),
    .decoder_out(display_unidades_millar)
);

decoder_7_seg DISPLAY_CEN (
    .decoder_in(centenas),
    .decoder_out(display_centenas)
);

decoder_7_seg DISPLAY_DEC ( 
    .decoder_in(decenas),
    .decoder_out(display_decenas)
);

decoder_7_seg DISPLAY_UN (
    .decoder_in(unidades),
    .decoder_out(display_unidades)
);

decoder_7_seg DISPALY_DM(
	 .decoder_in(decenas_millar),
    .decoder_out(display_decenas_millar)
);

decoder_7_seg DISPALY_CM(
	 .decoder_in(centenas_millar),
    .decoder_out(display_centenas_millar)
);


endmodule
