//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias

module pc (
	input clk,						//Sinal de clock 
	input reset,					//sinal de reset
	input [31:0] next_pc,		//entrada do prox valor do pc
	output reg [31:0] pc_out	//saída atual (registrador)
);

always @(posedge clk or posedge reset) begin
	if (reset)
		pc_out <= 32'b0;		//se for reset, zera os 32 bits
	else
		pc_out <= next_pc;	//se nn for, então recebe o next_pc
end

endmodule
