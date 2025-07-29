//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias


module mips_core(

    input clock,			//sinal de clock
    input reset,			//sinal de reset síncrono
    
    output [31:0] pc_out,		//saída do valor atual do PC (contador de programa)
    output [31:0] alu_out,		//saída do resultado da ULA
    output [31:0] d_mem_out	//saída dos dados lidos da memória de dados
);

 
//Wires que conectarão as unidades

//Fios para o caminho de busca da instrução (Fetch)
wire [31:0] pc_current, pc_plus_4;
reg [31:0] pc_next;
wire [31:0] instruction;

//Fios para os sinais de controle (saídas do módulo control)
wire [1:0] RegDst, MemtoReg;
wire RegWrite, MemRead, MemWrite, ALUSrc, JumpReg, ALUSrcShamt, ExtSign, Jump;
wire [1:0] Branch;
wire [2:0] ALUOp;

//Fios para o Banco de Registradores (regfile)
wire [31:0] reg_read_data_1, reg_read_data_2;
reg [4:0] write_reg_addr;
reg [31:0] write_reg_data;


//Fios para a ULA
reg [31:0] alu_input_1;
reg [31:0] alu_input_2;
wire [3:0] ula_op_final;
wire zero_flag;

//Fio para a memória de dados
wire [31:0] d_mem_read_data;

//Fios para cálculo
wire [31:0] sign_extended_imm, zero_extended_imm, extended_imm;
wire [31:0] branch_target_addr, jump_target_addr;
wire [31:0] shamt_extended;


// FETCH 

// Instanciando o Contador de Programa (PC)
pc PC_unit (
    .clk(clock),
    .reset(reset),
    .next_pc(pc_next),
    .pc_out(pc_current)
);

// Somador para PC+4
assign pc_plus_4 = pc_current + 4;

// Instanciando a Memória de Instrução
InstructionMemory IMem_unit (
    .address(pc_current),
    .instruction(instruction)
);


// DECODIFICAÇÃO E CONTROLE 

//Instanciando a Unidade de Controle Principal
control Control_unit (
    .opcode(instruction[31:26]),
    .funct(instruction[5:0]),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUOp(ALUOp),
    .JumpReg(JumpReg),
    .ALUSrcShamt(ALUSrcShamt),
    .ExtSign(ExtSign),
    .Jump(Jump),
	 .Shift(Shift)
);

//Instanciando a Unidade de Controle da ULA
ula_control ALU_Control_unit (
    .ALUOp(ALUOp),
    .funct(instruction[5:0]),
    .alu_operate(ula_op_final)
);

//Instanciando o banco de registradores
regfile RegFile_unit (
    .clk(clock),
    .reset(reset),
    .ReadAddr1(instruction[25:21]), // rs
    .ReadAddr2(instruction[20:16]), // rt
    .WriteAddr(write_reg_addr),      // O endereço de escrita é controlado
    .WriteData(write_reg_data),      // O dado de escrita é controlado
    .RegWrite(RegWrite),
    .ReadData1(reg_read_data_1),
    .ReadData2(reg_read_data_2)
);


//ETAPA DE EXECUÇÃO (ULA)

//Lógica de Extensão de Sinal e Extensão com Zero
assign sign_extended_imm = {{16{instruction[15]}}, instruction[15:0]};
assign zero_extended_imm = {16'b0, instruction[15:0]};

//Mux para escolher entre extensão de sinal ou zero (controlado por ExtSign)
assign extended_imm = (ExtSign == 1) ? zero_extended_imm : sign_extended_imm;

//shamt
assign shamt_extended = {27'b0, instruction[10:6]};


//Cadeia de MUXs para determinar as entradas da ULA
always @(*) begin

    if (Shift == 1'b1) begin					//instrução de shift? (sll,srl,sra, sllv, srlv, srav)
        alu_input_1 = reg_read_data_2;    // alu_input_1 = $rt
		  
		  if(ALUSrcShamt == 1'b1) begin		//instrução com shamt?
		  
				alu_input_2 = shamt_extended; //alu_input_2 = shamt
		  
		  end
		  
		  else begin							
				alu_input_2 = reg_read_data_1; //alu_input_2 = $rs
		  
		  end
    end
			  
			  
	 else begin									//Outras instruções
        alu_input_1 = reg_read_data_1; //alu_input_1 = $rs
		  
		  if(ALUSrc == 1'b1) begin			//Usa imediato?
		  
		  alu_input_2 = extended_imm; //alu_input_2 = imediato 
		  end
		  
		  else begin 						
		  
		  alu_input_2 = reg_read_data_2;//alu_input_2 = $rt
		  
		  end
		  
    end
end


// Instanciando a ULA

ula ULA_unit (
    .In1(alu_input_1),            
    .In2(alu_input_2),            
    .OP(ula_op_final),
    .result(alu_out),		//saída da ULA
    .zero_flag(zero_flag)	//flag de zero para beq/bne
);


//MEMÓRIA

// Instanciando a Memória de Dados
DataMemory DMem_unit (
    .clk(clock),
    .mem_write(MemWrite),
    .mem_read(MemRead),
    .address(alu_out), // O endereço da memória vem do resultado da ULA
    .write_data(reg_read_data_2), //valor a ser escrito vem do registrador rt
    .read_data(d_mem_read_data) //O dado lido da memória vai para o fio d_mem_read_data
);


//ETAPA DE WRITE-BACK

// MUX para escolher o registrador de destino (RegDst)
// 00=rt, 01=rd, 10=$ra(31)	  
always @(*) begin
    case (RegDst)
        2'b00:  write_reg_addr = instruction[20:16]; //$rt
        2'b01:  write_reg_addr = instruction[15:11]; //$rd
        2'b10:  write_reg_addr = 5'd31; //$ra
		  default: write_reg_addr = 5'bxxxxx;
    endcase
end



// MUX para escolher o dado a ser escrito no registrador (MemtoReg)
// 00=ULA, 01=Memória, 10=lui, 11=jal
always @(*) begin
    case (MemtoReg)
        2'b00:  write_reg_data = alu_out;//ula
        2'b01:  write_reg_data = d_mem_read_data;//memória
        2'b10:  write_reg_data = {instruction[15:0], 16'b0}; // Para lui
        2'b11:  write_reg_data = pc_plus_4; // Para jal
        default: write_reg_data = 32'b0;
    endcase
end


//CÁLCULO DO PRÓXIMO PC 

// Cálculo dos endereços de desvio e salto
assign branch_target_addr = pc_plus_4 + (sign_extended_imm << 2);			//beq/bne
assign jump_target_addr = {pc_plus_4[31:28], instruction[25:0], 2'b00};	//jump

// Mux final que escolhe o próximo PC
always @(*) begin
    if (Jump == 1) begin
        pc_next = jump_target_addr;
           end
		  else if (JumpReg == 1) begin
        pc_next = reg_read_data_1; // Endereço vem do registrador $rs
           end
		  else if ( (Branch == 2'b01 && zero_flag == 1'b1) || (Branch == 2'b10 && zero_flag == 1'b0) ) begin // Condição para beq e bne
        pc_next = branch_target_addr;
			  end
		  else begin
        pc_next = pc_plus_4; //instrução sequencial
		     end
end


// SAÍDAS FINAIS DO MÓDULO 
assign pc_out = pc_current;			//PC atual como saída externa
assign d_mem_out = d_mem_read_data; //valor lido da memória como saída

endmodule
