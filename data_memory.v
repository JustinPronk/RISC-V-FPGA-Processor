`define DATA_WIDTH 32

module data_memory #(
	parameter MEM_SIZE = 1024,
	parameter ADDR_WIDTH = $clog2(MEM_SIZE)
)(
	input wire i_clk,
	input wire i_we,
	input wire [`DATA_WIDTH-1:0] i_data,
	input wire [ADDR_WIDTH-1:0] i_addr,
	
	
	output wire [`DATA_WIDTH-1:0] o_data
);

	reg [`DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];
	
	assign o_data = mem[i_addr];
	
	always @(posedge i_clk) begin
		if (i_we)
			mem[i_addr] <= i_data;
	end


endmodule