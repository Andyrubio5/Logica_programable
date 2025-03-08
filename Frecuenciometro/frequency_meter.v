// Módulo principal del frecuencímetro (usando los módulos combinados)
module frequency_meter #(parameter INVERT_RST = 1, DEBOUNCE_THRESHOLD = 5000, SEGMENTOS = 7, BIT_SIZE = 20, FREQ = 1, DATA_IN_SIZE = 6)(
    input clk,                    // Reloj de 50 MHz
    input rst,                    // Botón de reset
    input signal_in,              // Señal a medir
    output [0:SEGMENTOS-1] un, dec, cen, un_millar, dec_millar, cen_millar // Salidas para display
);
    // Señal de reset debounceada y con one-shot
    wire clean_rst;
    debouncer_one_shot #(.INVERT_LOGIC(INVERT_RST), .DEBOUNCE_THRESHOLD(DEBOUNCE_THRESHOLD)) DEB_ONE_SHOT_RST (
        .clk(clk),
        .signal(rst),
        .signal_one_shot(clean_rst)
    );
    
    // Procesamiento de señal (sincronización + detección de flancos)
    wire edge_pulse;
    signal_processor SIGNAL_PROC (
        .clock(clk),
        .raw_signal(signal_in),
        .pos_pulse(edge_pulse)
    );
    
    // Medición de frecuencia (captura de período + cálculo de frecuencia)
    wire [BIT_SIZE-1:0] freq_result;
    frequency_measurement FREQ_MEASURE (
        .clock(clk),
        .clear_all(clean_rst),
        .edge_detected(edge_pulse),
        .freq_value(freq_result)
    );
    
    // Decodificador BCD para mostrar la frecuencia en los displays
    bcd_decoder DISPLAY(
        .switches(freq_result),
        .display_unidades(un),
        .display_decenas(dec),
        .display_centenas(cen),
        .display_unidades_millar(un_millar),
        .display_decenas_millar(dec_millar),
        .display_centenas_millar(cen_millar)
    );
endmodule