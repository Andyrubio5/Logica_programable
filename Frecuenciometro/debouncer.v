module debouncer #(parameter DEBOUNCE_THRESHOLD = 5000, INVERT_LOGIC = 0)(
	input clk, 					// Reloj del sistema para sincronización
		  debouncer_in,			// Entrada proveniente de botón físico con rebotes
	output reg debouncer_out	// Salida estabilizada sin rebotes
);

// Declaración de señales internas
wire [ceillog2(DEBOUNCE_THRESHOLD) - 1: 0] counter_out; // Salida del contador con tamaño calculado automáticamente
wire counter_match;						  // Señal que indica cuando el contador alcanza el umbral
wire debouncer_in_processed;
assign debouncer_in_processed = (INVERT_LOGIC) ? ~debouncer_in : debouncer_in; // Procesa la entrada según el parámetro de inversión lógica

// Instancia del módulo contador para medir el tiempo de estabilidad de la señal
counter_debouncer #(.STABILITY_TIME(DEBOUNCE_THRESHOLD)) CONTADOR_ESTABILIDAD(
	.clock(clk),
	.tick_count(counter_out),
	.stability_flag(counter_match)
);

// Bloque secuencial para actualizar la salida cuando la señal es estable
always @(posedge counter_match)
begin
	if(counter_match)
		debouncer_out <= debouncer_in_processed; 	// Actualiza la salida con el valor estable
	else
		debouncer_out <= debouncer_out; // Mantiene el valor anterior mientras no haya estabilidad
end

// Función para calcular el logaritmo en base 2 redondeado hacia arriba
// Determina la cantidad de bits necesarios para representar el umbral de debounce
function integer ceillog2;
	input integer data;
	integer i, result;
	begin
		for(i = 0; 2**i < data; i = i + 1)
			result = i + 1;
		ceillog2 = result;
	end
	
endfunction
endmodule