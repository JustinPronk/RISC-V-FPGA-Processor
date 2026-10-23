`define INST_WIDTH 32
`define OPCODE 7
`define NUM_REGISTER 32

`define OP_LUI    7'b0110111
`define OP_AUIPC  7'b0010111
`define OP_JAL    7'b1101111
`define OP_JALR   7'b1100111
`define OP_BRANCH 7'b1100011
`define OP_LOAD   7'b0000011
`define OP_STORE  7'b0100011
`define OP_ALUI   7'b0010011
`define OP_ALU    7'b0110011

`define ALU_ADD	4'd0
`define ALU_SUB	4'd1
`define ALU_AND	4'd2
`define ALU_OR 	4'd3
`define ALU_XOR	4'd4
`define ALU_SLT	4'd5
`define ALU_SLTU	4'd6
`define ALU_SLL	4'd7
`define ALU_SRL	4'd8
`define ALU_SRA	4'd9


`define BRANCH_BEQ      3'b000
`define BRANCH_BNE      3'b001
`define BRANCH_BLT      3'b100
`define BRANCH_BGE      3'b101
`define BRANCH_BLTU     3'b110
`define BRANCH_BGEU     3'b111
`define BRANCH_JAL_JALR 3'b010

module decoder #(
	parameter REG_ADDR_WIDTH = $clog2(`NUM_REGISTER)
)(
	input wire [`INST_WIDTH-1:0] i_inst,
	
	output wire [`OPCODE-1:0] o_opcode,
	output reg o_branch,
	output reg [1:0] o_result_mux,
	output reg [2:0] o_branch_op,
	output reg o_mem_write,
	output reg o_alu_src_a,
	output reg o_alu_src_b,
	output reg o_reg_write,
	output reg [3:0] o_alu_op,
	output wire [REG_ADDR_WIDTH - 1: 0] o_rs1_addr,
	output wire [REG_ADDR_WIDTH - 1: 0] o_rs2_addr,
	output wire [REG_ADDR_WIDTH - 1: 0] o_rd_addr
	
);

	assign o_opcode	= i_inst[6:0];
	assign o_rs1_addr	= i_inst[19:15];
	assign o_rs2_addr	= i_inst[24:20];
	assign o_rd_addr	= i_inst[11:7];
	
	wire [2:0] funct3	= i_inst[14:12];
	wire	funct7_5	= i_inst[30];
	
	
	reg [3:0] arith_op;
	always @(*) begin
		case (funct3)
			3'b000: arith_op = (o_opcode == `OP_ALU && funct7_5) ? `ALU_SUB : `ALU_ADD;
			3'b001:  arith_op = `ALU_SLL;
         3'b010:  arith_op = `ALU_SLT;
         3'b011:  arith_op = `ALU_SLTU;
         3'b100:  arith_op = `ALU_XOR;
         3'b101:  arith_op = funct7_5 ? `ALU_SRA : `ALU_SRL;
         3'b110:  arith_op = `ALU_OR;
         3'b111:  arith_op = `ALU_AND;
         default: arith_op = `ALU_ADD;
		endcase
	end
	
	always @(*) begin
		o_branch     = 1'b0;
      o_result_mux = 2'd0;
      o_branch_op  = 3'd0;
      o_mem_write  = 1'b0;
      o_alu_src_a  = 1'b0;
      o_alu_src_b  = 1'b0;
      o_reg_write  = 1'b0;
      o_alu_op     = `ALU_ADD;
		
		case (o_opcode)
			`OP_ALU: begin
				o_reg_write = 1'b1;
				o_alu_op	= arith_op;
			end
			`OP_ALUI: begin
				o_reg_write = 1'b1;
            o_alu_src_b = 1'b1;
            o_alu_op    = arith_op;
         end
         `OP_LOAD: begin                 
            o_reg_write  = 1'b1;
            o_alu_src_b  = 1'b1;
            o_result_mux = 2'd1;          
         end
         `OP_STORE: begin                  
            o_alu_src_b = 1'b1;
            o_mem_write = 1'b1;
         end
         `OP_BRANCH: begin
            o_branch    = 1'b1;
            o_branch_op = funct3;         
         end
         `OP_JAL: begin
            o_reg_write  = 1'b1;
            o_result_mux = 2'd2;          
            o_branch     = 1'b1;
            o_branch_op  = `BRANCH_JAL_JALR;
         end
			`OP_JALR: begin
            o_reg_write  = 1'b1;
            o_alu_src_b  = 1'b1;
            o_result_mux = 2'd2;
            o_branch     = 1'b1;
            o_branch_op  = `BRANCH_JAL_JALR;
         end
         `OP_LUI: begin
            o_reg_write  = 1'b1;
            o_result_mux = 2'd3;          
         end
         `OP_AUIPC: begin
            o_reg_write = 1'b1;
            o_alu_src_a = 1'b1;           
            o_alu_src_b = 1'b1;
         end
			default: ;
		endcase
	end
		

endmodule