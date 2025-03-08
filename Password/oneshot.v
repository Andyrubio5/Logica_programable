module oneshot (
	input boton_a,    // Entrada del botón o switch a monitorear
	      clk,        // Señal de reloj
	output reg oneshot // Señal de pulso único de salida
);
    // Registro auxiliar para almacenar el estado anterior
    reg delay_b;      // Guarda el estado anterior del botón para detectar cambios
    
    always @ (posedge clk)
    begin
        delay_b <= boton_a; // Guardamos el estado anterior del botón a
        
        // Si el estado del botón ha cambiado (delay_b != boton_a) 
        // y ahora está en alto (boton_a == 1), generamos un pulso
        if ((delay_b != boton_a) && boton_a == 1)
            oneshot <= 1;   // Activamos el pulso de salida por un ciclo
        else 
            oneshot <= 0;   // Mantenemos la salida en bajo el resto del tiempo
    end
endmodule