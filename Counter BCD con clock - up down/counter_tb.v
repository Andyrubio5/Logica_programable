module counter_tb;
    reg clk, rst, enable, direction;
    wire [5:0] count;

    // Instancia del módulo
    counter uut (
        .clk(clk), 
        .rst(rst), 
        .enable(enable), 
        .direction(direction), 
        .count(count)
    );

    // Generar reloj (50MHz = 20ns por ciclo)
    always #1 clk = ~clk;

    initial begin
        clk = 0; rst = 1; enable = 0; direction = 1;
        #10 rst = 0;  // 🔄 Quitar reset después de 50ns
        #10 enable = 1;  // ✅ Activar enable después de 20ns
        #10 enable = 0;  // ❌ Desactivar enable después de 200ns
        #10 enable = 1;  // ✅ Volver a activarlo después de 100ns
        #10 direction = 0;  // 🔁 Cambiar a cuenta regresiva después de 200ns
        #10 $stop;  // 🛑 Detener simulación después de 400ns
    end
endmodule
