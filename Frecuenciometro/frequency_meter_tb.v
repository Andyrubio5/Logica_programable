`timescale 1ns/1ps

module frequency_meter_tb();
    // Parámetros del módulo
    localparam INVERT_RST = 1;
    localparam DEBOUNCE_THRESHOLD = 50; // Reducido para la simulación
    localparam SEGMENTOS = 7;
    localparam BIT_SIZE = 20;
    
    // Señales de prueba
    reg clk;
    reg rst;
    reg signal_in;
    wire [0:SEGMENTOS-1] un, dec, cen, un_millar, dec_millar, cen_millar;
    
    // Instancia del módulo bajo prueba
    frequency_meter #(
        .INVERT_RST(INVERT_RST),
        .DEBOUNCE_THRESHOLD(DEBOUNCE_THRESHOLD),
        .SEGMENTOS(SEGMENTOS),
        .BIT_SIZE(BIT_SIZE)
    ) UUT (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .un(un),
        .dec(dec),
        .cen(cen),
        .un_millar(un_millar),
        .dec_millar(dec_millar),
        .cen_millar(cen_millar)
    );
    
    // Generación de reloj (20ns = 50MHz)
    always begin
        clk = 0;
        #10;
        clk = 1;
        #10;
    end
    
    // Definición de frecuencias de prueba (en Hz)
    localparam FREQ_1KHZ = 1000;
    localparam FREQ_10KHZ = 10000;
    localparam FREQ_100KHZ = 100000;
    
    // Tarea para generar una señal de entrada con frecuencia específica
    task generate_signal;
        input integer freq_hz;
        integer half_period_ns;
        begin
            // Calculamos el medio período en ns
            half_period_ns = 1_000_000_000 / (freq_hz * 2);
            
            // Generamos 10 ciclos de la señal
            repeat (10) begin
                signal_in = 0;
                #(half_period_ns);
                signal_in = 1;
                #(half_period_ns);
            end
        end
    endtask
    
    // Procedimiento de prueba
    initial begin
        // Inicialización
        clk = 0;
        rst = 0;
        signal_in = 0;
        
        // Reset inicial
        #100;
        rst = 1;
        #100;
        rst = 0;
        #100;
        
        // Prueba con 1 KHz
        generate_signal(FREQ_1KHZ);
        #10000; // Esperamos que se estabilice la lectura
        
        // Prueba con 10 KHz
        generate_signal(FREQ_10KHZ);
        #10000;
        
        // Prueba con 100 KHz
        generate_signal(FREQ_100KHZ);
        #10000;
        
        // Prueba de reset durante medición
        generate_signal(FREQ_1KHZ);
        #1000;
        rst = 1;
        #100;
        rst = 0;
        #5000;
        
       //STOP 
		 $stop;
    end
endmodule