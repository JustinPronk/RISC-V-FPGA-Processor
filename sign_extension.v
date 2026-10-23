`define INST_WIDTH 32
`define OPCODE 7
`define OP_LUI 	7'b0110111
`define OP_AUIPC	7'b0010111
`define OP_JAL 	7'b1101111
`define OP_STORE 	7'b0100011
`define OP_ALU 	7'b0110011
`define OP_JALR	7'b1100111
`define OP_LOAD 	7'b0000011
`define OP_ALUI	7'b0010011
`define OP_BRANCH 7'b1100011


module sign_extension (
	input wire [`INST_WIDTH-1:0]	i_inst,
	input wire [`OPCODE-1:0]	i_opcode,
	output reg [`INST_WIDTH-1:0]	o_immediate_extended
	
);

always @(*) begin
	case (i_opcode)
		`OP_LOAD, `OP_ALUI, `OP_JALR:
			o_immediate_extended = {{20{i_inst[31]}}, i_inst[31:20]};
			
		`OP_STORE:
			o_immediate_extended = {{20{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
			
		`OP_BRANCH:
			o_immediate_extended = {{19{i_inst[31]}}, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
			
		`OP_LUI, `OP_AUIPC:
			o_immediate_extended = {i_inst[31:12], 12'b0};
			
		`OP_JAL:
			o_immediate_extended = {{11{i_inst[31]}}, i_inst[31], i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};
		
		default:
			o_immediate_extended = 32'b0;
	endcase
end

endmodule