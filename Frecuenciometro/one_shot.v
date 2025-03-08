module one_shot(
    input clk,                   // Señal de reloj del sistema
    input boton_a,               // Señal de entrada (botón o señal a convertir en pulso único)
    output reg signal_with_one_shot   // Salida que genera un pulso de un ciclo de reloj
);

// Registros internos
reg delay_boton_a;               // Registro para almacenar el valor anterior de boton_a
reg signal_clk;                  // Señal intermedia para detectar transiciones

// Bloque secuencial que se ejecuta en cada flanco de subida del reloj
always @(posedge clk) begin
    delay_boton_a <= boton_a;    // Guarda el estado anterior de boton_a
    signal_clk = delay_boton_a ^ clk; // Operación XOR para detectar cambio entre valor actual y anterior
    signal_with_one_shot = signal_clk & boton_a; // Genera pulso solo cuando hay transición y boton_a está activo
end
endmodule