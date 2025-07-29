//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias


module ula_control(
    input [2:0] ALUOp,          // Entrada de 3 bits vinda da Unidade de Controle Principal 
    input [5:0] funct,          // Entrada de 6 bits vinda da instrução(funct) 
    output reg [3:0] alu_operate // Saída de 4 bits que vai para a ULA
);

always @(*) begin

    case (ALUOp)
	 
	 
		  3'b000: begin//lw, sw e addi 
				alu_operate = 4'b0010; 
		  end
		  
		  
		  3'b001: begin//beq e bne
				alu_operate = 4'b0110;
        end
		  

        3'b010: begin // Se for R-type
		  
            case (funct)
				
					 6'b100100: alu_operate = 4'b0000; // funct and
					 6'b100101: alu_operate = 4'b0001; // funct or
					 6'b100000: alu_operate = 4'b0010; // funct add 
					 6'b100110: alu_operate = 4'b0011; // func xor
					 6'b000000: alu_operate = 4'b0100; // funct sll
					 6'b000010: alu_operate = 4'b0101; // funct srl
                6'b100010: alu_operate = 4'b0110; // funct sub
					 6'b101010: alu_operate = 4'b0111; // funct slt 
					 6'b100111: alu_operate = 4'b1100; // funct nor
					 6'b000011: alu_operate = 4'b1101; // funct sra
					 6'b101011: alu_operate = 4'b1111; // funct sltu
					 6'b000100: alu_operate = 4'b1000; // funct sllv 
					 6'b000110: alu_operate = 4'b1001; // funct srlv
					 6'b000111: alu_operate = 4'b1010; // funct srav
					 
                default: alu_operate = 4'bxxxx; // Para qualquer outro funct
            endcase
        end
		   
		  
		  3'b011: begin //andi 
            alu_operate = 4'b0000; 
        end
		  
		  
		  3'b100: begin //ori 
            alu_operate = 4'b0001; 
        end
		  
		  
		  3'b101: begin //xori 
            alu_operate = 4'b0011; 
        end
		  
		  
		  3'b110: begin //slti 
            alu_operate = 4'b0111; 
        end
		  
		  
		  3'b111: begin //sltiu
            alu_operate = 4'b1111; 
        end
		  
		  
		  
        default: alu_operate = 4'bxxxx;
    endcase

end

endmodule
