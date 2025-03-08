`timescale 1ns / 1ps
module password_tb();
    // Señales para conectar al DUT (Device Under Test)
    reg [9:0] codigo;
    reg clk;
    reg rst;
    wire [3:0] leds;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
    
    // Parámetros de la simulación
    localparam CLK_PERIOD = 20;  // 50MHz = 20ns de periodo
    
    // Secuencia correcta de la contraseña según el código:
    // SW1 -> SW7 -> SW2 -> SW0
    
    // Instancia del módulo a probar
    password DUT (
        .codigo(codigo),
        .clk(clk),
        .rst(rst),
        .leds(leds),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4)
    );
    
    // Generación de la señal de reloj
    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end
    
    // Procedimiento de prueba
    initial begin
        // Inicialización
        codigo = 10'b0000000000;
        rst = 0;  // Reset activo bajo, comenzamos en reset
        
        // Aplicamos reset por un tiempo
        #100;
        rst = 1;  // Desactivamos reset
        #100;
        
        // Verificamos estado inicial
        if (leds !== 4'b0000) begin
        end else begin
        end
		  
        // Paso 1: Activar SW1
        codigo = 10'b0000000010;  // SW1 = 1
        #5000;  // Esperamos varios ciclos para que el divisor de reloj actúe
        
        if (leds[0] !== 1'b1) begin
        end else begin
        end
        
        // Paso 2: Activar SW7
        codigo = 10'b0000000010 | 10'b0010000000;  // SW1 y SW7 = 1
        #5000;
        
        if (leds[1:0] !== 2'b11) begin
        end else begin
        end
        
        // Paso 3: Activar SW2
        codigo = 10'b0000000010 | 10'b0010000000 | 10'b0000000100;  // SW1, SW7 y SW2 = 1
        #5000;
        
        if (leds[2:0] !== 3'b111) begin
        end else begin
        end
        
        // Paso 4: Activar SW0 (último dígito)
        codigo = 10'b0000000010 | 10'b0010000000 | 10'b0000000100 | 10'b0000000001;  // Todos los dígitos correctos
        #5000;
        
        if (leds !== 4'b1111) begin
        end else begin
        end
        
        // Volver al estado inicial desactivando todos los switches
        codigo = 10'b0000000000;
        #5000;
        
        if (leds !== 4'b0000) begin
        end else begin
        end
        
        // Activar un switch incorrecto desde el principio (SW5)
        codigo = 10'b0000100000;  // SW5 = 1
        #5000;
        
        if (leds !== 4'b0000) begin
        end else begin
        end
        
        // Volver al estado inicial
        codigo = 10'b0000000000;
        #5000;
        
        
        // Paso 1: Activar SW1 (correcto)
        codigo = 10'b0000000010;  // SW1 = 1
        #5000;
        
        // Paso 2: Activar SW1 y SW7 (correcto)
        codigo = 10'b0000000010 | 10'b0010000000;  // SW1 y SW7 = 1
        #5000;
        
        // Paso 3: Activar switch incorrecto (SW8) en lugar de SW2
        codigo = 10'b0000000010 | 10'b0010000000 | 10'b0100000000;  // SW1, SW7 y SW8 = 1
        #5000;
        
        if (leds !== 4'b0000) begin
        end else begin
        end
        
        // Volver al estado inicial
        codigo = 10'b0000000000;
        #5000;
        
        // Paso 1: Activar SW1 (correcto)
        codigo = 10'b0000000010;  // SW1 = 1
        #5000;
        
        // Paso 2: Activar SW1 y SW7 (correcto)
        codigo = 10'b0000000010 | 10'b0010000000;  // SW1 y SW7 = 1
        #5000;
        
        // Aplicar reset
        rst = 0;  // Reset activo bajo
        #100;
        rst = 1;  // Desactivar reset
        #100;
        
        if (leds !== 4'b0000) begin
        end else begin
        end
        
        $stop;
    end
    
endmodule