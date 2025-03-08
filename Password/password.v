module password(
    input [9:0] codigo,    // Entrada de 10 bits para los interruptores (SW9-SW0)
    input clk,             // Señal de reloj del sistema
    input rst,             // Señal de reset del sistema (activo bajo)
    output reg [3:0] leds, // 4 LEDs para mostrar el progreso
    output reg [6:0] HEX0, // Display de 7 segmentos #0
    output reg [6:0] HEX1, // Display de 7 segmentos #1
    output reg [6:0] HEX2, // Display de 7 segmentos #2
    output reg [6:0] HEX3, // Display de 7 segmentos #3
    output reg [6:0] HEX4  // Display de 7 segmentos #4
);

    // Estados de la FSM (máquina de estados finitos)
    localparam IDLE = 3'b000;      // Estado inicial, esperando primer dígito
    localparam prim_dig = 3'b001;  // Primer dígito ingresado
    localparam seg_dig = 3'b011;   // Segundo dígito ingresado
    localparam ter_dig = 3'b010;   // Tercer dígito ingresado
    localparam DONE = 3'b110;      // Contraseña completa y correcta
    localparam ERROR = 3'b101;     // Error, contraseña incorrecta
    
    // Definición de la contraseña (qué switches deben activarse)
    localparam 
        primer_num  = 1'b1,   // SW1 debe estar activo (posición 1)
        segun_num   = 1'b1,   // SW7 debe estar activo (posición 7)
        tercer_num  = 1'b1,   // SW2 debe estar activo (posición 2)
        cuarto_num  = 1'b1;   // SW0 debe estar activo (posición 0)
    
    // Patrones para displays de 7 segmentos (ánodo común, activo bajo)
    localparam [6:0] 
        DISPLAY_APAGADO = 7'b1111111,  // Todos los segmentos apagados
        DISPLAY_GUION   = 7'b0111111,  // Solo segmento g encendido (guion)
        DISPLAY_D       = 7'b0100001,  // Letra 'd' minúscula
        DISPLAY_O       = 7'b0100011,  // Letra 'o' minúscula
        DISPLAY_N       = 7'b0101011,  // Letra 'n' minúscula
        DISPLAY_E       = 7'b0000110,  // Letra 'E' mayúscula
        DISPLAY_ERR_E   = 7'b0000110,  // Letra 'E' mayúscula para "Error"
        DISPLAY_ERR_R   = 7'b0101111,  // Letra 'r' minúscula para "Error"
        DISPLAY_ERR_O   = 7'b0100011;  // Letra 'o' minúscula para "Error"
    
    // Registros para la máquina de estados
    reg [2:0] current_state;      // Estado actual
    reg [2:0] next_state;         // Siguiente estado
    
    // Señales del divisor de reloj
    wire clk_div;                 // Reloj dividido principal
    wire clk_1000_Hz;             // Reloj de 1000Hz para los oneshots
    
    // Registro para el valor previo de los switches
    reg [9:0] sw_prev;            // Guarda el valor anterior de los switches
    
    // Señal para los oneshots (detección de un solo pulso)
    wire [9:0] sw_debouncer;      // Un bit por cada switch para detectar pulsaciones únicas

    // Instanciación del divisor de reloj principal
    clk_div #(.FREQ(1000)) clk_div_inst (
        .clk(clk),                // Entrada: reloj del sistema
        .rst(rst),                // Entrada: reset del sistema
        .clk_div(clk_div)         // Salida: reloj dividido
    );
	 
    // Instanciación del divisor de reloj para oneshot (1000Hz)
    clk_div #(.FREQ(1000)) clk_1000_divider (
        .clk(clk),                // Entrada: reloj del sistema
        .rst(rst),                // Entrada: reset del sistema
        .clk_div(clk_1000_Hz)     // Salida: reloj de 1000Hz
    );
    
    // Instanciación de los oneshots para cada switch (antirebote)
    genvar i;
    generate 
        // Crea 10 instancias, una para cada bit de 'codigo'
        for (i=0; i<10; i=i+1) begin: oneshot_instanciado
            oneshot ONS(
                .clk(clk_1000_Hz),       // Reloj para el oneshot
                .boton_a(codigo[i]),      // Switch a debounce
                .oneshot(sw_debouncer[i]) // Salida limpia (un solo pulso)
            );
        end 
    endgenerate
    
    // Manejo del registro sw_prev (trasladado desde clock_divider)
    // Actualiza el valor anterior de los switches en cada ciclo de reloj
    always @(posedge clk_div or negedge rst) begin
        if (!rst) begin
            // En reset, inicializa todos los bits a 0
            sw_prev <= 10'b0000000000;
        end else begin
            // En cada ciclo de reloj, guarda el valor actual
            sw_prev <= codigo;
        end
    end
    
    // Primer always: Actualización de estado actual (síncrono)
    // Se ejecuta en cada ciclo de reloj para actualizar el estado de la FSM
    always @(posedge clk_div or negedge rst) begin
        if (!rst) begin 
            // En reset, vuelve al estado inicial
            current_state <= IDLE;
        end else begin
            // En cada ciclo, avanza al siguiente estado calculado
            current_state <= next_state;
        end
    end
    
    // Segundo always: Lógica de próximo estado (combinacional)
    // Determina cuál será el próximo estado basado en las entradas y el estado actual
    always @(*) begin
        // Por defecto, mantener el estado actual (evita latches no intencionados)
        next_state = current_state;
        
        case (current_state)
            IDLE: begin
                // En estado inicial, esperando el primer switch correcto (SW1)
                if (codigo[1] == primer_num) begin
                    next_state = prim_dig;  // Si SW1 está activo, avanza al primer dígito
                // Si cualquier otro switch está activo (excepto SW1)
                // La operación "|codigo" verifica si algún bit está activo
                // "~codigo[1]" niega el bit 1, así que busca cualquier bit activo excepto el 1
                end else if (|codigo & ~codigo[1]) begin 
                    next_state = ERROR;     // Error si se activa otro switch
                end
            end
            
            prim_dig: begin
                // Esperando el segundo switch correcto (SW7)
                if (codigo[7] == segun_num) begin
                    next_state = seg_dig;   // Si SW7 está activo, avanza al segundo dígito
                // Comprueba si hay algún switch incorrecto activado
                // La máscara 10'b0000000010 | 10'b0010000000 representa SW1 y SW7
                // El operador & con la negación verifica cualquier bit activo que no sea SW1 o SW7
                end else if (|(codigo & ~(10'b0000000010 | 10'b0010000000))) begin 
                    next_state = ERROR;     // Error si se activa otro switch
                end
            end
            
            seg_dig: begin
                // Esperando el tercer switch correcto (SW2)
                if (codigo[2] == tercer_num) begin
                    next_state = ter_dig;   // Si SW2 está activo, avanza al tercer dígito
                // Comprueba si hay algún switch incorrecto activado
                // La máscara ahora incluye SW1, SW7 y SW2
                end else if (|(codigo & ~(10'b0000000010 | 10'b0010000000 | 10'b0000000100))) begin 
                    next_state = ERROR;     // Error si se activa otro switch
                end
            end
            
            ter_dig: begin
                // Esperando el cuarto switch correcto (SW0)
                if (codigo[0] == cuarto_num) begin
                    next_state = DONE;      // Si SW0 está activo, contraseña completa correcta
                // Comprueba si hay algún switch incorrecto activado
                // La máscara ahora incluye SW1, SW7, SW2 y SW0
                end else if (|(codigo & ~(10'b0000000010 | 10'b0010000000 | 10'b0000000100 | 10'b0000000001))) begin 
                    next_state = ERROR;     // Error si se activa otro switch
                end
            end
            
            DONE: begin
                // En estado DONE (contraseña correcta)
                // Si se desactivan todos los switches, volver a IDLE
                if (codigo == 10'b0000000000) begin
                    next_state = IDLE;      // Reinicia sistema cuando todos los switches están inactivos
                end
            end
            
            ERROR: begin
                // En estado ERROR (contraseña incorrecta)
                // Si se desactivan todos los switches, volver a IDLE
                if (codigo == 10'b0000000000) begin
                    next_state = IDLE;      // Reinicia sistema cuando todos los switches están inactivos
                end
            end
            
            default: begin
                // Por seguridad, vuelve a IDLE si el estado no es reconocido
                next_state = IDLE;
            end
        endcase
    end
    
    // Tercer always: Lógica de salidas (síncrono)
    // Controla qué mostrar en los LEDs y displays según el estado actual
    always @(posedge clk_div or negedge rst) begin
        if (!rst) begin
            // En reset, apaga todas las salidas
            leds <= 4'b0000;             // Todos los LEDs apagados
            HEX0 <= DISPLAY_APAGADO;     // Todos los displays apagados
            HEX1 <= DISPLAY_APAGADO; 
            HEX2 <= DISPLAY_APAGADO;
            HEX3 <= DISPLAY_APAGADO; 
            HEX4 <= DISPLAY_APAGADO;
        end else begin
            // Según el estado actual, configura las salidas
            case (current_state)
                IDLE: begin
                    // Estado inicial - todo apagado excepto LED0 si SW1 activo
                    leds <= 4'b0000;           // Inicia con todos los LEDs apagados
                    HEX0 <= DISPLAY_APAGADO;   // Todos los displays apagados
                    HEX1 <= DISPLAY_APAGADO; 
                    HEX2 <= DISPLAY_APAGADO;
                    HEX3 <= DISPLAY_APAGADO; 
                    HEX4 <= DISPLAY_APAGADO;
                    leds[0] <= codigo[1];      // LED0 refleja estado de SW1
                end
                
                prim_dig: begin
                    // Primer dígito correcto - LED0 y LED1 reflejan SW1 y SW7
                    leds[0] <= codigo[1];      // LED0 refleja estado de SW1
                    leds[1] <= codigo[7];      // LED1 refleja estado de SW7
                    HEX0 <= DISPLAY_GUION;     // Muestra un guion en HEX0
                    HEX1 <= DISPLAY_APAGADO;   // Resto de displays apagados
                    HEX2 <= DISPLAY_APAGADO;
                    HEX3 <= DISPLAY_APAGADO; 
                    HEX4 <= DISPLAY_APAGADO;
                end
                
                seg_dig: begin
                    // Segundo dígito correcto - LEDs 0,1,2 reflejan switches
                    leds[0] <= codigo[1];      // LED0 refleja estado de SW1
                    leds[1] <= codigo[7];      // LED1 refleja estado de SW7
                    leds[2] <= codigo[2];      // LED2 refleja estado de SW2
                    HEX0 <= DISPLAY_GUION;     // Muestra guiones en HEX0 y HEX1
                    HEX1 <= DISPLAY_GUION;     // indicando progreso
                    HEX2 <= DISPLAY_APAGADO;   // Resto de displays apagados
                    HEX3 <= DISPLAY_APAGADO; 
                    HEX4 <= DISPLAY_APAGADO;
                end
                
                ter_dig: begin
                    // Tercer dígito correcto - Todos los LEDs reflejan switches
                    leds[0] <= codigo[1];      // LED0 refleja estado de SW1
                    leds[1] <= codigo[7];      // LED1 refleja estado de SW7
                    leds[2] <= codigo[2];      // LED2 refleja estado de SW2
                    leds[3] <= codigo[0];      // LED3 refleja estado de SW0
                    HEX0 <= DISPLAY_GUION;     // Tres guiones en displays
                    HEX1 <= DISPLAY_GUION;     // mostrando progreso
                    HEX2 <= DISPLAY_GUION;
                    HEX3 <= DISPLAY_APAGADO;   // Resto de displays apagados
                    HEX4 <= DISPLAY_APAGADO;
                end
                
                DONE: begin
                    // Contraseña correcta - Todos los LEDs encendidos
                    leds <= 4'b1111;           // Enciende todos los LEDs
                    // Muestra "donE" en los displays
                    HEX3 <= DISPLAY_D;         // d
                    HEX2 <= DISPLAY_O;         // o
                    HEX1 <= DISPLAY_N;         // n
                    HEX0 <= DISPLAY_E;         // E
                    HEX4 <= DISPLAY_APAGADO;   // HEX4 apagado
                end
                
                ERROR: begin
                    // Contraseña incorrecta - Todos los LEDs apagados
                    leds <= 4'b0000;           // Apaga todos los LEDs
                    // Muestra "Error" en los displays
                    HEX4 <= DISPLAY_ERR_E;     // E
                    HEX3 <= DISPLAY_ERR_R;     // r
                    HEX2 <= DISPLAY_ERR_R;     // r
                    HEX1 <= DISPLAY_ERR_O;     // o
                    HEX0 <= DISPLAY_ERR_R;     // r
                end
                
                default: begin
                    // Estado no reconocido - Apaga todo por seguridad
                    leds <= 4'b0000;           // Todos los LEDs apagados
                    HEX0 <= DISPLAY_APAGADO;   // Todos los displays apagados
                    HEX1 <= DISPLAY_APAGADO; 
                    HEX2 <= DISPLAY_APAGADO;
                    HEX3 <= DISPLAY_APAGADO; 
                    HEX4 <= DISPLAY_APAGADO;
                end
            endcase
        end
    end

endmodule