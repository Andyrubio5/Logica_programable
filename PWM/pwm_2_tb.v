`timescale 1ns / 1ps

module pwm_2_tb();
    // Señales para conectar al DUT (Device Under Test)
    reg pb_inc;
    reg pb_dec;
    reg clk;
    reg rst;
    wire pwm_out;
    
    // Parámetros de tiempo
    parameter CLK_PERIOD = 20; // 50 MHz clock (20ns)
    
    // Instancia del módulo a testear
    pwm_2 DUT(
        .pb_inc(pb_inc),
        .pb_dec(pb_dec),
        .clk(clk),
        .rst(rst),
        .pwm_out(pwm_out)
    );
 
   
    
    // Generación del reloj
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Estímulos de prueba
    initial begin
        // Inicialización
        pb_inc = 1; // Botones no presionados (activos en bajo)
        pb_dec = 1;
        rst = 1;
        
        // Reset inicial
        #10;
        rst = 0;
        #10;
        
        // Verificar estado inicial (50% duty cycle)

        #50000; // Esperar a ver varios ciclos del PWM
        
        // Incrementar duty cycle varias veces

        repeat(3) begin
            pb_inc = 0; // Presionar botón (activo en bajo)
            #500;
            pb_inc = 1; // Soltar botón
            #5000;     // Esperar a ver el efecto
        end
        
        // Decrementar duty cycle varias veces
        repeat(5) begin
            pb_dec = 0; // Presionar botón (activo en bajo)
            #500;
            pb_dec = 1; // Soltar botón
            #5000;     // Esperar a ver el efecto
        end
        
        // Verificar límites (no debería bajar de 5%)
        repeat(5) begin
            pb_dec = 0; // Presionar botón (activo en bajo)
            #500;
            pb_dec = 1; // Soltar botón
            #5000;     // Esperar a ver el efecto
        end
        
        // Incrementar de nuevo y verificar comportamiento
        repeat(20) begin
            pb_inc = 0; // Presionar botón (activo en bajo)
            #500;
            pb_inc = 1; // Soltar botón
            #5000;     // Esperar a ver el efecto
        end
        
        // Reset durante operación
        rst = 1;
        #100;
        rst = 0;
        #50000;

    end


endmodule