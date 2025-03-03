module counter#(parameter N = 14)(
    input clk,  
    input rst, 
    input enable,
    input direction, // 1 para sumar, 0 para restar
    input [5:0] sw,  
    input load,       // Señal para cargar el valor desde los switches
    output reg [N-1:0] count // 14 bits para contar hasta 9999
);

always @(posedge clk or posedge rst) begin  
    if (rst) 
        count <= 14'd0;  // Reinicio a 0
    else if (load) 
        count <= sw; // Carga el valor de los switches en los 4 bits
    else if (enable) begin  
        if (direction) begin  // Modo suma
            if (count >= 14'd9999)  
                count <= 14'd0;  
            else 
                count <= count + 1;
        end 
        else begin  // Modo resta
            if (count == 14'd0)  
                count <= 14'd9999;  
            else 
                count <= count - 1;
        end
    end
end

endmodule
