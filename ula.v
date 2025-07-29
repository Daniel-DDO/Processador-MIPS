//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias

module ula
//Entradas
(input [31:0] In1, In2,
input [3:0] OP,
//Saídas
output reg [31:0] result,
output zero_flag);

//Recalcular depois de qualquer alteração nas entradas
always @(*) begin
	case (OP)
		4'b0000:							//0000 -> AND
			result = In1 & In2;
			
		4'b0001:							//0001 -> OR
			result = In1 | In2;
			
		4'b0010:							//0010 -> add
			result = In1 + In2;
			
		4'b0011:							//0011 -> XOR
			result = In1 ^ In2;
			
		4'b0100:							//0100 -> SLL (Shift Left Logical)
			result = In1 << In2[4:0];				// 5 bits menos significativos de In1 = quantidade de deslocamento
			
		4'b0101:							//0101 -> SRL (Shift Right Logical)
			result = In1 >> In2[4:0];				// 5 bits menos significativos de In2 = quantidade de deslocamento
			
		4'b0110:							//0110 -> SUB
			result = In1 - In2;
			
		4'b0111:							//0111 -> SLT (Set on Less Than) (Signed (considera bit de sinal))
			result = ($signed(In1) < $signed(In2)) ? 32'd1 : 32'd0;
			
		4'b1000:                            // 1000 -> SLLV (Shift Left Logical Variable)
        result = In1 << In2[4:0];       // Desloca In2 pela quantidade em In1
		  
      4'b1001:                            // 1001 -> SRLV (Shift Right Logical Variable)
        result = In1 >> In2[4:0];       // Deslocamento lógico
		  
      4'b1010:                            // 1010 -> SRAV (Shift Right Arithmetic Variable)
        result = $signed(In1) >>> In2[4:0]; // Deslocamento aritmético com sinal
		  
		4'b1100:							//1100 -> NOR
			result = ~(In1 | In2);
		4'b1101:							//1101 -> SRA (Shift Right Arithmetic) (Mantém o bit de sinal)
			result = $signed(In1) >>> In2[4:0];	// 5 bits menos significativos de In2 = quantidade de deslocamento
			
		4'b1111:							//1111 -> SLTU (Set on Less Than Unsigned)
			result = (In1 < In2) ? 32'd1 : 32'd0;
			
		default: 
			result = 32'd0;			//Em caso de OP inválido, result é = 0
	endcase
end

assign zero_flag = (result == 32'b0);	//Zero_flag é 1 quando result == 0, e 0 quando result != 0

endmodule
