module clk_div #(parameter FREQ = 1_000)(
    input clk,         // Señal de reloj de entrada (típicamente 50MHz)
    input rst,         // Señal de reset (activo bajo)
    output reg clk_div // Señal de reloj dividida (salida)
);
    // Calcular el valor de división basado en la frecuencia deseada
    localparam constanN = 50_000_000;                 // Frecuencia base de 50MHz
    localparam count_max = constanN / (2 * FREQ);     // Cálculo del contador máximo
    
    // Registro para el contador
    reg [31:0] count;  // Contador de 32 bits para la división
    
    // Lógica de división
    // Se ejecuta en cada flanco positivo del reloj o flanco negativo del reset
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count <= 0;          // Reiniciar contador en caso de reset
            clk_div <= 0;        // Reiniciar salida del reloj dividido
        end else begin
            if (count == count_max - 1) begin
                count <= 0;              // Reiniciar contador al alcanzar el máximo
                clk_div <= ~clk_div;     // Alternar la salida (genera un ciclo completo)
            end else begin
                count <= count + 1;      // Incrementar contador
            end
        end
    end
endmodule