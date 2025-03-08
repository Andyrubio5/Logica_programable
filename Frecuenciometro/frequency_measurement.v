// Módulo combinado que integra captura de período y cálculo de frecuencia
module frequency_measurement(
    input clock,                     // Reloj del sistema
    input clear_all,                 // Señal de reinicio
    input edge_detected,             // Señal de flanco detectado
    output reg [19:0] freq_value     // Valor de frecuencia calculado
);
    // Registros para la captura de período
    reg [23:0] time_counter;         // Contador de ciclos de reloj
    reg [23:0] last_edge_time;       // Tiempo del último flanco detectado
    reg initial_edge;                // Bandera para el primer flanco
    reg [23:0] time_measure;         // Valor del período medido
    
    always @(posedge clock) begin
        if (clear_all) begin
            // Reiniciamos todos los registros
            time_counter <= 0;
            last_edge_time <= 0;
            time_measure <= 0;
            initial_edge <= 1;       // Marcamos que esperamos el primer flanco
            freq_value <= 0;         // Reiniciamos también la frecuencia
        end else begin
            // Incrementamos el contador en cada ciclo
            time_counter <= time_counter + 1;
            
            // Si detectamos un flanco de subida
            if (edge_detected) begin
                if (initial_edge) begin
                    // En el primer flanco solo guardamos el tiempo
                    last_edge_time <= time_counter;
                    initial_edge <= 0;
                end else begin
                    // En flancos subsecuentes, calculamos la diferencia
                    time_measure <= time_counter - last_edge_time;
                    last_edge_time <= time_counter;
                    
                    // Calculamos la frecuencia inmediatamente
                    if (time_counter != last_edge_time) // Evitamos división por cero
                        freq_value <= 50000000 / (time_counter - last_edge_time);
                end
            end
        end
    end
    
    // NOTA: La combinación de estos módulos optimiza el procesamiento
    // al calcular la frecuencia inmediatamente después de medir el período,
    // evitando latencias adicionales.
endmodule