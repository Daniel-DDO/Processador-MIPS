//Arquitetura e Organização de Computadores
//Semestre: 2025.1
//Alunos:
//Álvaro Ribeiro Bezerra da Silva
//Daniel Dionísio de Oliveira
//Gabriel Felipe Pontes da Silva Farias

module mips_core_tb;

    //Sinais pra conectar o processador
    //Usamos 'reg' para as entradas do processador
    reg clock;
    reg reset;

    //Usamos wire para os sinais das saídas do processador
    wire [31:0] pc_out;
    wire [31:0] alu_out;
    wire [31:0] d_mem_out;


    // O clock terá um período de 10 unidades de tempo (5 para nível alto, 5 para baixo)
    always #5 clock = ~clock;


    //Instanciação do Processador (Unidade Sob Teste - UUT)
    mips_core UUT (
        .clock(clock),
        .reset(reset),
        .pc_out(pc_out),
        .alu_out(alu_out),
        .d_mem_out(d_mem_out)
    );


    //Sequência de Teste
    initial begin
        //Inicialização dos sinais
        clock = 0;
        reset = 1; //o processador começa em estado de reset

        //Mensagem inicial
        $display("----------------------------------------------------------------------");
        $display("Tempo(ns)\t\t PC \t\t ALU Out \t\t Mem Out");
        $display("----------------------------------------------------------------------");

        
        #10;//Pulso de Reset
        reset = 0; //libera o processador do reset 
		  
        //$time mostra o tempo atual da simulação.
        $monitor("Tempo=%0t | PC=%h | ALU_OUT=%d | D_MEM_OUT=%h", $time, pc_out, alu_out, d_mem_out);

        //deixa a simulação rodar por 900 ns
        #900;

        $display("Simulação finalizada.");
        $finish;
    end

endmodule	