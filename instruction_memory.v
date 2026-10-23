`define INST_WIDTH 32

module instruction_memory #(
	parameter MEM_SIZE = 1024,
	parameter ADDR_WIDTH = $clog2(MEM_SIZE)
)(
	input wire clk,
	input wire [ADDR_WIDTH-1:0] addr,
	
	output reg [`INST_WIDTH-1:0] inst
	
);	
	
	
	reg [`INST_WIDTH-1:0] mem [0:MEM_SIZE-1];
	
	
	initial begin
		$readmemh("program.hex", mem);
	end
	
	always @(*) begin
		inst = mem[addr];
	end


endmodule