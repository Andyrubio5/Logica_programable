module decoder_7_seg(
    input wire [3:0] decoder_in,     // Entrada BCD de 4 bits
    output reg [0:6] decoder_out     // Salida de 7 bits (segmentos a-g)
);
    always @(*) begin
        case (decoder_in)
            4'h0: decoder_out = 7'b1000000; // '0'
            4'h1: decoder_out = 7'b1111001; // '1'
            4'h2: decoder_out = 7'b0100100; // '2'
            4'h3: decoder_out = 7'b0110000; // '3'
            4'h4: decoder_out = 7'b0011001; // '4'
            4'h5: decoder_out = 7'b0010010; // '5'
            4'h6: decoder_out = 7'b0000010; // '6'
            4'h7: decoder_out = 7'b1111000; // '7'
            4'h8: decoder_out = 7'b0000000; // '8'
            4'h9: decoder_out = 7'b0010000; // '9'
            default: decoder_out = 7'b1111111; // Apagar todo
        endcase
    end
endmodule