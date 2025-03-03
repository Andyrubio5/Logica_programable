module counter_bcd#(
    parameter N=10, 
    SEGMENTOS = 7
)(
    input clk,
    input rst,
    input enable,   
    input direction,
    input [5:0] sw,  // 4 switches para ingresar un número inicial
    input load,       // Señal para cargar el valor desde los switches
    output [0:SEGMENTOS-1] display_unidades,  
    output [0:SEGMENTOS-1] display_decenas, 
    output [0:SEGMENTOS-1] display_centenas, 
    output [0:SEGMENTOS-1] display_unidades_millar
);

// Auxiliares
wire clk_div_to_clk_counter;
wire [15:0] counter_to_BCD;
// Auxiliares display
wire [3:0] unidades_wire;
wire [3:0] decenas_wire;
wire [3:0] centenas_wire;
wire [3:0] miles_wire;

// Instanciamos clk_div (Divisor de reloj para ralentizar el conteo)
clk_div CLK_DIV(
    .clk(clk),
    .rst(rst), 
    .clk_div(clk_div_to_clk_counter)
);

// Instanciamos el counter asegurando que use el reloj dividido
counter COUNTER(
    .clk(clk_div_to_clk_counter),  
    .rst(rst),
    .enable(enable), 
    .direction(direction),
    .sw(sw),         // Se pasa la entrada de switches al contador
    .load(load),     // Se pasa la señal de carga al contador
    .count(counter_to_BCD)
);

// Instanciamos el conversor de binario a decimal
bin_a_dec CONVERT_BIN_TO_DEC (
    .bin(counter_to_BCD), 
    .um(miles_wire), 
    .cen(centenas_wire), 
    .dec(decenas_wire), 
    .un(unidades_wire)
);

// Instancias de los displays de 7 segmentos
segment7 DISPLAY_UM (
    .decoder_in(miles_wire),  
    .decoder_out(display_unidades_millar)
);
segment7 DISPLAY_CEN (
    .decoder_in(centenas_wire),  
    .decoder_out(display_centenas)
);
segment7 DISPLAY_DEC ( 
    .decoder_in(decenas_wire),  
    .decoder_out(display_decenas)
);
segment7 DISPLAY_UN (
    .decoder_in(unidades_wire),  
    .decoder_out(display_unidades)
);

endmodule
