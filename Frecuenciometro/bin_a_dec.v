module bin_a_dec #(parameter N = 17, SEG = 7)(
    input [N-1:0] bin,
    output reg [3:0] cm, dm, um, cen, dec, un
);
    // Utilizamos asignaciones separadas para mejorar la legibilidad y evitar problemas de síntesis
    always @(*) begin
        // Centenas de millar (100,000 - 999,999)
        cm = (bin / 100000) % 10;
        
        // Decenas de millar (10,000 - 99,999)
        dm = (bin / 10000) % 10;
        
        // Unidades de millar (1,000 - 9,999)
        um = (bin / 1000) % 10;
        
        // Centenas (100 - 999)
        cen = (bin / 100) % 10;
        
        // Decenas (10 - 99)
        dec = (bin / 10) % 10;
        
        // Unidades (0 - 9)
        un = bin % 10;
    end
endmodule