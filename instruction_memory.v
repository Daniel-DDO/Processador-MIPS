//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias


module InstructionMemory (
	input [31:0] address,			//endereço de 32 bits
	output [31:0] instruction		//saída da instrução

);
reg [31:0] memory [0:255];		//rom com 256 posições (32 bits cada)
	
initial begin
	$readmemb("instructions.list", memory);		//carrega as instruções na memoria
end

assign instruction = memory[address[9:2]];	//lê a instrução na possição referente

endmodule
