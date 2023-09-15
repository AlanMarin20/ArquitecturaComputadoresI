module datapath #(parameter N=4)
						(input logic clk,
						input logic [15:0] ctrl_word,//palabra de control 
						input logic [N-1:0] DATA_in,//data de entrada 
						output logic [3:0] statebits,//banderas
						output logic [N-1:0] DATA_out)//data de salida

	logic we3;
	logic [N-1:0] busA, busB, regA, regB, aluData;
	logic [2:0] A,B,D;
	logic [3:0] flags;
	assign we3=ctrl_word[9:7]? 1:0;//Si ctrl_word[9:7] es distinto de 0, we3 tiene 1(habilitado)
											 //por el contrario, si es igual a 0, we3 tiene 0(deshabilitado)
	
	assign A = ctrl_word[15:13];//Seleccionan busA
	assign B = ctrl_word[12:10];//Seleccionan busB
	assign D = ctrl_word[9:7];//Seleccionan destino
	
	assign busA = ((A!=0) ? regA : DATA_in;
	assign busB = ((A!=0) ? regB : DATA_in;
	
//RAM3PORT
	ram3port register_file(clk,we3,//we3 enable
								A,B,D,
								DATA_out,
								regA, regB);//Salidas del busA y busB
//ALU
	alu ALU(busA,busB,ctrl_word[6,3],aluData,flags);
//UnidadCorrimiento
	shifter UnidadCorrimiento(aluData,ctrl_word[2:0],DATA_out);
	
		always_ff @(posedge clk)
			statebits <= flags;
endmodule 
								