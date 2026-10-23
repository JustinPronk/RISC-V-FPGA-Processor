`define DATA_WIDTH 32
`define NUM_REGISTER 32

module register_file #(
	parameter REG_ADDR_WIDTH = $clog2(`NUM_REGISTER)
)(
	input wire i_clk,
	input wire i_rst,
	input wire i_we,
	input wire [`DATA_WIDTH-1:0] i_write_data,
	input wire [REG_ADDR_WIDTH-1:0] i_rd_addr,
	input wire [REG_ADDR_WIDTH-1:0] i_rs1_addr,
	input wire [REG_ADDR_WIDTH-1:0] i_rs2_addr,
	
	output wire [`DATA_WIDTH-1:0] o_rs1,
	output wire [`DATA_WIDTH-1:0] o_rs2
);

	reg [`DATA_WIDTH-1:0] regs [0:`NUM_REGISTER-1];
	integer i;
	
	assign o_rs1 = (i_rs1_addr == 0) ? 0 : regs[i_rs1_addr];
	assign o_rs2 = (i_rs2_addr == 0) ? 0 : regs[i_rs2_addr];
	
	always @(posedge i_clk) begin
		if (i_rst) begin
			for (i = 0; i < `NUM_REGISTER; i = i + 1)
				regs[i] <= 0;
		end else if (i_we && i_rd_addr != 0) begin
			regs[i_rd_addr] <= i_write_data;
		end
	end


endmodule