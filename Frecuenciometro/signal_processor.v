// Módulo combinado que integra sincronización y detección de flancos
module signal_processor(
    input clock,                    // Reloj del sistema
    input raw_signal,               // Señal de entrada sin sincronizar
    output pos_pulse                // Pulso de salida al detectar flanco
);
    // Señales internas para la sincronización
    reg intermediate;
    reg clean_signal;
    
    // Señal interna para el detector de flancos
    reg data_prev;
    
    // Primera parte: Sincronizador de dos etapas
    always @(posedge clock) begin
        intermediate <= raw_signal;   // Primera etapa
        clean_signal <= intermediate; // Segunda etapa
    end
    
    // Segunda parte: Detector de flancos
    always @(posedge clock) begin
        data_prev <= clean_signal;
    end
    
    // Generamos un pulso en el flanco de subida
    assign pos_pulse = clean_signal & ~data_prev;
    
    // NOTA: Esta combinación simplifica la interconexión y reduce
    // la cantidad de módulos necesarios en el diseño general.
endmodule