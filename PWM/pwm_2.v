// módulo de PWM que sirve para controlar un servomotor de 180 grados
module pwm_2(
    input pb_inc, // botón incrementar posición
          pb_dec, // botón decrementar posición
          clk,    // reloj (50MHz)
          rst,    // reset
    output reg pwm_out // salida de PWM
);
    // negamos las entradas de incremento y decremento porque los botones funcionan al revés
    wire neg_pb_inc = ~pb_inc;
    wire neg_pb_dec = ~pb_dec;
     
    // registro de duty cycle para servomotor de 180 grados
    // con una frecuencia de 50Hz (periodo 20ms)
    // 1ms = 50,000 ciclos (0° - inicio del rango)
    // 2ms = 100,000 ciclos (180° - fin del rango)
    reg [31:0] DC = 32'd75_000;   // posición inicial 90 grados (mitad del rango)
    reg [31:0] counter = 32'd0;   // counter para la señal PWM 
    
    // límites de pulso para el servomotor de 180 grados
    parameter MIN_DC = 32'd50_000;   // 1ms (0°)
    parameter MAX_DC = 32'd100_000;  // 2ms (180°)
    parameter STEP = 32'd2_778;      // incremento para 18 pasos (10 grados cada uno)
    
    // generamos parámetros para calcular el periodo
    parameter freq_base = 32'd50_000_000; // frecuencia base (50 MHz)
    parameter freq_final = 32'd50;        // frecuencia final (50 Hz)
    parameter periodo = freq_base / freq_final; // periodo = 1,000,000 ciclos
    
    // Variables para manejar el muestreo de botones (en lugar de usar debouncer externo)
    reg [31:0] btn_counter = 0;     // contador para ralentizar lectura de botones
    reg [2:0] pb_inc_reg = 0;       // registro para detectar incremento
    reg [2:0] pb_dec_reg = 0;       // registro para detectar decremento
    
    // control del duty cycle con límites específicos para servomotor
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            DC <= 32'd75_000;       // Reset a posición central (90°)
            btn_counter <= 0;
            pb_inc_reg <= 0;
            pb_dec_reg <= 0;
        end
        else begin
            // Muestreo de botones con detección de flanco
            pb_inc_reg <= {pb_inc_reg[1:0], neg_pb_inc};
            pb_dec_reg <= {pb_dec_reg[1:0], neg_pb_dec};
            
            // Incrementamos contador para ralentizar la detección de botones
            btn_counter <= btn_counter + 1;
            
            // Procesamos entradas cada ~20ms (50Hz)
            if (btn_counter >= freq_base/50) begin
                btn_counter <= 0;
                
                // Detección de botón incremento (activo y estable por 3 ciclos)
                if (pb_inc_reg == 3'b111) begin
                    // incrementa pero limita al máximo
                    if (DC < MAX_DC - STEP)
                        DC <= DC + STEP;
                    else
                        DC <= MAX_DC;
                end
                
                // Detección de botón decremento (activo y estable por 3 ciclos)
                if (pb_dec_reg == 3'b111) begin
                    // decrementa pero limita al mínimo
                    if (DC > MIN_DC + STEP)
                        DC <= DC - STEP;
                    else
                        DC <= MIN_DC;
                end
            end
        end
    end
       
    // generamos la señal de PWM a 50Hz 
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            counter <= 32'd0;
            pwm_out <= 1'b0;
        end
        else begin
            // Incrementamos el contador
            counter <= counter + 32'd1;
            
            // Reiniciamos el contador al completar un periodo
            if (counter >= periodo)
                counter <= 32'd0;
            
            // Generamos la salida PWM
            if (counter < DC)
                pwm_out <= 1'b1;
            else
                pwm_out <= 1'b0;
        end
    end
    
endmodule