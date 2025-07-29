//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias


module DataMemory (
	input clk,							//sinal de clock
	input mem_write,					//ativa a escrita
	input mem_read,					//ativa a leitura
	input [31:0] address,			//endereço na memória
	input [31:0] write_data,		//dado a ser escrito na memória
	output reg [31:0] read_data	//dado lido
);

reg [31:0] memory [0:255];			//RAM com 256 pos de 32 bits cada

always @(posedge clk) begin		//executa na subida do clk
	if(mem_write)						//se for escrita
		memory[address[9:2]] <= write_data;		//escreve na posição referente
end

always @(*) begin
	if(mem_read)						//se for leitura
		read_data = memory[address[9:2]];	//le na posição referente
	else
		read_data = 32'b0;				//se não for leitura, retorna zerado
end

endmodule
