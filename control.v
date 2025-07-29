//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias


module control(
    input [5:0] opcode, 
	 input [5:0] funct,
    
    //Sinais de Controle 
    output reg [1:0]RegDst,     // Mux: Escolhe entre rt, rd e ra como registrador de destino
    output reg ALUSrc,          // Mux: Escolhe o uso de imediato (1) ou registrador (0) para a entrada da ULA
    output reg [1:0] MemtoReg,  // Mux: Escolhe o que escrever no registrador (ULA ou memória)
    output reg RegWrite,        // habilita a escrita no banco de registradores
    output reg MemRead,         // habilita a leitura da memória de dados
    output reg MemWrite,        // habilita a escrita na memória de dados
    output reg [1:0] Branch,    // Sinal para desvios condicionais (beq e bne)
    output reg [2:0] ALUOp,     // Sinal de 3 bits para o ula_control
	 output reg JumpReg,         // Salto Jr
	 output reg ALUSrcShamt, //origem do shamt [10:6] ou registrador rt
	 output reg ExtSign, //extende (0) ou não o sinal (1)
	 output reg Jump, // saltos incondionais (j e jal)
	 output reg Shift //para instruções do tipo shift
);


always @(*) begin

    //inicia todos os sinais com valores padrão (0 ou 'x')
    RegDst = 2'bxx;
    ALUSrc = 0;
    MemtoReg = 2'bxx;
    RegWrite = 0;
    MemRead = 0;
    MemWrite = 0;
    Branch = 2'b00;
    ALUOp = 3'bxxx;
	 JumpReg = 0;
	 ALUSrcShamt = 0;
	 ExtSign = 1'bx;
	 Jump = 0;
	 Shift = 1'b0;
	 

    //decodifica o opcode para gerar os sinais corretos
    case (opcode) //case pra verificar o valor do opcode
		  
		 6'b000000: begin //Instruções R-type

				  // jr?
				  if (funct == 6'b001000) begin
						RegWrite    = 0;
						JumpReg     = 1;
						// O resto não importa, pois não há escrita no reg ou acesso à memória
						RegDst      = 2'bxx;
						ALUSrc      = 1'bx;
						MemtoReg    = 2'bxx;
						MemRead     = 0;
						MemWrite    = 0;
						Branch      = 2'b00;
						ALUSrcShamt = 1'bx;
						ALUOp       = 3'bxxx;
				  end
				  //sll=000000 e srl=000010
				  else if (funct == 6'b000000 || funct == 6'b000010) begin
				
						RegWrite    = 1'b1;
						RegDst      = 2'b01;
						ALUSrcShamt = 1'b1;
						JumpReg     = 1'b0;
						Branch      = 2'b00;
						MemRead     = 1'b0;
						MemWrite    = 1'b0;
						ALUSrc      = 1'b0; 
						MemtoReg    = 2'b00;
						ALUOp       = 3'b010;
						Shift       = 1'b1;
				  end
				  
				  //sra
				  else if (funct == 6'b000011) begin
				
						RegWrite    = 1'b1;
						RegDst      = 2'b01;
						ALUSrcShamt = 1'b1;
						JumpReg     = 1'b0;
						Branch      = 2'b00;
						MemRead     = 1'b0;
						MemWrite    = 1'b0;
						ALUSrc      = 1'b0;
						MemtoReg    = 2'b00;
						ALUOp       = 3'b010;
						Shift       = 1'b1;
				  end
				  
				  //sllv e srlv
				  else if (funct == 6'b000100 || funct == 6'b000110) begin
				  
						RegWrite    = 1;
						RegDst      = 2'b01;
						ALUSrcShamt = 0;   
						JumpReg     = 0;
						Branch      = 2'b00;
						MemRead     = 0;
						MemWrite    = 0;
						ALUSrc      = 0;
						MemtoReg    = 2'b00;
						ALUOp       = 3'b010; 
						Shift    = 1'b1;
				  end
				  
				  //srav
				  else if (funct == 6'b000111) begin
				
						RegWrite    = 1;
						RegDst      = 2'b01;
						ALUSrcShamt = 0;   
						JumpReg     = 0;
						Branch      = 2'b00;
						MemRead     = 0;
						MemWrite    = 0;
						ALUSrc      = 0;
						MemtoReg    = 2'b00;
						ALUOp       = 3'b010;
						Shift       = 1'b1;
				  end
				  
				  //slt
				else if (funct == 6'b101010) begin
						RegWrite    = 1;
						RegDst      = 2'b01;
						ALUSrcShamt = 0;    
						JumpReg     = 0;
						Branch      = 2'b00;
						MemRead     = 0;
						MemWrite    = 0;
						ALUSrc      = 0;
						MemtoReg    = 2'b00;
						ALUOp       = 3'b010; 
				  end
				  
				  // Caso Padrão: Todas as outras R-types (add, sub, and, or, etc)
				  else begin
						RegWrite    = 1;
						RegDst      = 2'b01;
						ALUSrcShamt = 0;    
						JumpReg     = 0;
						Branch      = 2'b00;
						MemRead     = 0;
						MemWrite    = 0;
						ALUSrc      = 0;
						MemtoReg    = 2'b00;
						ALUOp       = 3'b010; 
				  end
			 end
			 
		  
		  6'b001000: begin // addi
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1;
        MemtoReg = 2'b00; // Seleciona o resultado da ULA
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 0;     // Usa extensão de SINAL
        ALUOp    = 3'b000; // ULA deve fazer soma
		  end
		  
		  6'b001100: begin // andi
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1;
        MemtoReg = 2'b00; // Seleciona o resultado da ULA
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 1;     
        ALUOp    = 3'b011;
		  end
		  
		  6'b001101: begin // ori
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1;
        MemtoReg = 2'b00;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 1;     
        ALUOp    = 3'b100;
		  end
		  
		  6'b001110: begin // xori
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1;
        MemtoReg = 2'b00;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 1;     
        ALUOp    = 3'b101;
		  end
		  
		         
		  6'b000100: begin // beq
        RegWrite = 0;
        RegDst   = 2'bxx;
        ALUSrc   = 0;
        MemtoReg = 2'bxx;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b01;
        ExtSign  = 1'bx;
        ALUOp    = 3'b001; // Comando para sbtração
		  end
		  
		  6'b000101: begin // bne
        RegWrite = 0;
        RegDst   = 2'bxx;
        ALUSrc   = 0;
        MemtoReg = 2'bxx;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b10;
        ExtSign  = 1'bx;
        ALUOp    = 3'b001; 
		  end
		  
		  6'b001010: begin // slti
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1;
        MemtoReg = 2'b00;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 0;
        ALUOp    = 3'b110; 
		  end
		  
		  6'b001001: begin // sltiu
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1;
        MemtoReg = 2'b00;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 1;
        ALUOp    = 3'b111; 
		  end
		  
		  
		  6'b001111: begin // lui
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1'bx;
        MemtoReg = 2'b10;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 1'bx;
        ALUOp    = 3'bxxx; 
		  end
		  
		  6'b100011: begin // lw
        RegWrite = 1;
        RegDst   = 2'b00;
        ALUSrc   = 1;
        MemtoReg = 2'b01;
        MemRead  = 1;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 0;
        ALUOp    = 3'b000; 
		  end
		  
		  6'b101011: begin // sw
        RegWrite = 0;
        RegDst   = 2'bxx;
        ALUSrc   = 1;
        MemtoReg = 2'bxx;
        MemRead  = 0;
        MemWrite = 1;
        Branch   = 2'b00;
        ExtSign  = 0;
        ALUOp    = 3'b000; 
		  end
		  
		  6'b000010: begin // j
        RegWrite = 0;
        RegDst   = 2'bxx;
        ALUSrc   = 1'bx;
        MemtoReg = 2'bxx;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 1'bx;
        ALUOp    = 3'bxxx;
		  Jump 	  = 1;
		  end
		  
		  6'b000011: begin // jal
        RegWrite = 1;
        RegDst   = 2'b10;
        ALUSrc   = 1'bx;
        MemtoReg = 2'b11;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 2'b00;
        ExtSign  = 1'bx;
        ALUOp    = 3'bxxx;
		  Jump 	  = 1;
		  end
  
        
        default: begin
            // Valores padrão 
            RegDst = 2'b00; ALUSrc = 0; MemtoReg = 2'b00; RegWrite = 0; MemRead = 0;
            MemWrite = 0; Branch = 2'b00; ALUOp = 3'bxxx; Shift = 1'b0;
        end

    endcase //fim do bloco case
end //fim do bloco always

endmodule 
      