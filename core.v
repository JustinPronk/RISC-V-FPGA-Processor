`define INST_WIDTH 32
`define OPCODE 7

`define DATA_WIDTH 32
`define NUM_REGISTER 32

module core#(
	parameter MEM_SIZE = 1024
)(
	input wire clk,
	input wire rst
);
	localparam ADDR_WIDTH = $clog2(MEM_SIZE);
	
	reg [`DATA_WIDTH-1:0] pc;
	wire [`DATA_WIDTH-1:0] pc_plus4 = pc + 32'd4;
	wire [`DATA_WIDTH-1:0] pc_next;
	
	always @(posedge clk) begin
		if (rst) pc <= 32'd0;
		else pc <= pc_next;
	end
	
	
	wire [`INST_WIDTH-1:0] instr;
	
	instruction_memory #(.MEM_SIZE(MEM_SIZE)) u_imem (
		.clk (clk),
		.addr (pc[ADDR_WIDTH+1:2]),
		.inst (instr)
	);
	
	wire [`OPCODE-1:0] opcode;
	wire branch, mem_write, alu_src_a, alu_src_b, reg_write;
	wire [1:0] result_mux;
	wire [2:0] branch_op;
	wire [3:0] alu_op;
	wire [4:0] rs1_addr, rs2_addr, rd_addr;
	
	decoder u_decoder (
		.i_inst	(instr),
		.o_opcode	(opcode),
		.o_branch	(branch),
		.o_result_mux	(result_mux),
		.o_branch_op	(branch_op),
		.o_mem_write	(mem_write),
		.o_alu_src_a	(alu_src_a),
		.o_alu_src_b	(alu_src_b),
		.o_reg_write	(reg_write),
		.o_alu_op	(alu_op),
		.o_rs1_addr	(rs1_addr),
		.o_rs2_addr	(rs2_addr),
		.o_rd_addr	(rd_addr)
	);
	
	wire [`DATA_WIDTH-1:0] rs1_data, rs2_data, wb_data;
	register_file u_regfile (
		.i_clk	(clk),
		.i_rst	(rst),
		.i_we	(reg_write),
		.i_write_data	(wb_data),
		.i_rd_addr	(rd_addr),
		.i_rs1_addr	(rs1_addr),
		.i_rs2_addr	(rs2_addr),
		.o_rs1	(rs1_data),
		.o_rs2	(rs2_data)
	);
	
	wire [`DATA_WIDTH-1:0] imm;
	sign_extension u_sign_ext (
		.i_inst	(instr),
		.i_opcode	(opcode),
		.o_immediate_extended	(imm)
	);
	
	wire [`DATA_WIDTH-1:0] alu_a = alu_src_a ? pc	: rs1_data;
	wire [`DATA_WIDTH-1:0] alu_b = alu_src_b ? imm	: rs2_data;
	wire [`DATA_WIDTH-1:0] alu_result;
	
	alu u_alu (
		.i_alu_op (alu_op),
		.i_a (alu_a),
		.i_b (alu_b),
		.o_c (alu_result)
	);
	
	wire take;
	branch_unit u_branch (
		.i_branch (branch),
		.i_branch_op (branch_op),
		.i_a (rs1_data),
		.i_b (rs2_data),
		.o_take (take)
	);
	
	
	wire [`DATA_WIDTH-1:0] branch_target = pc + imm;
	wire is_jalr = (opcode == `OP_JALR);
	
	assign pc_next = !take	? pc_plus4 :
							is_jalr	? (alu_result & 32'hFFFF_FFFE) :
											branch_target;
	
	
	
	
	wire [`DATA_WIDTH-1:0] mem_rdata;
	data_memory #(.MEM_SIZE(MEM_SIZE)) u_dmem (
		.i_clk	(clk),
		.i_we	(mem_write),
		.i_data	(rs2_data),
		.i_addr	(alu_result[ADDR_WIDTH+1:2]),
		.o_data	(mem_rdata)
	);
	
	assign wb_data = (result_mux == 2'd0) ? alu_result :
							(result_mux == 2'd1) ? mem_rdata	:
							(result_mux == 2'd2) ? pc_plus4	:
															imm;

endmodule															
	
	