module bcd_decoder #(parameter N = 10, SEG = 7)(

    input [N-1:0] switches, // 10 switches de entrada
    
    output [0:SEG -1] display_unidades,  
    output [0:SEG -1] display_decenas, 
    output [0:SEG -1] display_centenas, 
    output [0:SEG -1] display_unidades_millar
);

 // Almacena y transmite los valores convertidos del número binario a decimal
 
wire [3:0] unidades;
wire [3:0] decenas;
wire [3:0] centenas; 
wire [3:0] unidades_millar; 

// Conversión de binario a decimal
bin_a_dec DUT(
    .bin(switches),
    .um(unidades_millar),
    .cen(centenas),
    .dec(decenas),
    .un(unidades)
);

// Decodificador para 7 segmentos

segment7 DISPLAY_UM (
    .decoder_in(unidades_millar),
    .decoder_out(display_unidades_millar)
);

segment7 DISPLAY_CEN (
    .decoder_in(centenas),
    .decoder_out(display_centenas)
);

segment7 DISPLAY_DEC ( 
    .decoder_in(decenas),
    .decoder_out(display_decenas)
);

segment7 DISPLAY_UN (
    .decoder_in(unidades),
    .decoder_out(display_unidades)
);

endmodule
