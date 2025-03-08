module counter_debouncer #(parameter STABILITY_TIME = 5000)(
	input clock,                                          // Reloj principal del sistema
    output reg [calculate_bits(STABILITY_TIME)-1:0] tick_count = 0,
    output reg stability_flag                             // Indica cuando la señal ha sido estable por suficiente tiempo
);
// Implementación del proceso de conteo
always @(posedge clock) // Se sincroniza con los flancos positivos del reloj
begin
    if(tick_count >= STABILITY_TIME - 1) // Verificamos si alcanzamos el umbral de estabilidad
    begin
        tick_count <= 0;       // Reiniciamos el contador para un nuevo ciclo
        stability_flag <= 1;   // Activamos bandera indicando estabilidad alcanzada
    end
    else
    begin
        tick_count <= tick_count + 1; // Incrementamos el contador en cada ciclo
        stability_flag <= 0;          // Mantenemos la bandera inactiva durante el conteo
    end
end
// Función auxiliar para determinar el ancho de bits óptimo según el umbral
function integer calculate_bits;
	input integer data;
	integer i, result;
	begin
		for(i = 0; 2**i < data; i = i + 1)
			result = i + 1;
		calculate_bits = result;
	end
	
endfunction
endmodule