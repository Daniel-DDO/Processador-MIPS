//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias

module regfile (
	// Entradas
	input clk, RegWrite, reset,
	input [4:0] ReadAddr1, ReadAddr2, WriteAddr,
	input [31:0] WriteData,
	// Saídas
	output [31:0] ReadData1, ReadData2 
);

		reg [31:0] registradores [0:31];			// 32 registradores de 32 bits
		integer i;										// Iterador para caso de reset
		
	// Inicialização
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			registradores[i] = 32'b0;
		end
	end
	
	//Operações de escrita (síncronas com o Clock)
		always @(posedge clk) begin
		if (reset) begin			//Se reset = 1, limpa todos os registradores
			for (i = 0; i < 32; i = i + 1) begin
			registradores[i] = 32'b0;
			end
		end
		if (RegWrite && (WriteAddr != 5'b00000)) begin	//Se RegWrite = 1 e WriteAddr não é o $0, escreve
			registradores[WriteAddr] <= WriteData;
			end
		end

	//Operação de leitura
	//Caso $0 retorna sempre 0
	assign ReadData1 = (ReadAddr1 == 5'b00000) ? 32'b0 : registradores[ReadAddr1];
	assign ReadData2 = (ReadAddr2 == 5'b00000) ? 32'b0 : registradores[ReadAddr2];
	//Em outros casos realiza a leitura nos registradores no endereço ReadAddr e salva dados em ReadData



endmodule

