`define DATA_WIDTH 32

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


module alu (
	input wire [3:0] i_alu_op,
	input wire [`DATA_WIDTH-1:0] i_a,
	input wire [`DATA_WIDTH-1:0] i_b,
	
	output reg [`DATA_WIDTH-1:0] o_c
);

	always @(*) begin
		case (i_alu_op)
			`ALU_ADD: o_c = i_a + i_b;
			`ALU_SUB: o_c = i_a - i_b;
			`ALU_SLL: o_c = i_a << i_b[4:0];
			`ALU_SLT: o_c = ($signed(i_a) < $signed(i_b)) ? 32'd1 : 32'd0;
			`ALU_SLTU: o_c = (i_a < i_b) ? 32'd1 : 32'd0;
			`ALU_XOR: o_c = i_a ^ i_b;
			`ALU_SRL: o_c = i_a >> i_b[4:0];
			`ALU_SRA: o_c = $signed(i_a) >>> i_b[4:0];
			`ALU_OR: o_c = i_a | i_b;
			`ALU_AND: o_c = i_a & i_b;
			default: o_c = 32'd0;
		endcase
	end
	


endmodule