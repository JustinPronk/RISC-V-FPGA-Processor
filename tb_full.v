module tb_full;
  reg clk = 0, rst = 1;
  core dut(.clk(clk), .rst(rst));
  always #5 clk = ~clk;
  integer errors = 0;
  task check; input integer idx; input [31:0] expected; input [8*20-1:0] name;
    begin if (dut.u_dmem.mem[idx] !== expected) begin
      $display("FAIL %0s: mem[%0d] = %h, expected %h", name, idx, dut.u_dmem.mem[idx], expected); errors = errors + 1; end end
  endtask
  initial begin
    #12 rst = 0;
    wait (dut.pc == 32'd432);
    #30;
    check(0, 32'hfffffffe, "add");
    check(1, 32'hfffffff8, "sub");
    check(2, 32'hffffffd8, "sll");
    check(3, 32'h00000001, "slt");
    check(4, 32'h00000000, "sltu");
    check(5, 32'hfffffff8, "xor");
    check(6, 32'h1fffffff, "srl");
    check(7, 32'hffffffff, "sra");
    check(8, 32'hfffffffb, "or");
    check(9, 32'h00000003, "and");
    check(10, 32'h00000005, "addi");
    check(11, 32'h00000001, "slti");
    check(12, 32'h00000001, "sltiu");
    check(13, 32'hffffff04, "xori");
    check(14, 32'h00000033, "ori");
    check(15, 32'h0000000b, "andi");
    check(16, 32'h00000030, "slli");
    check(17, 32'h0fffffff, "srli");
    check(18, 32'hffffffff, "srai");
    check(19, 32'h12345000, "lui");
    check(20, 32'h000010a8, "auipc");
    check(21, 32'h00000000, "x0_zero");
    check(22, 32'hfffffffb, "lw_roundtrip");
    check(23, 32'h00000001, "beq_NT_x1x2");
    check(24, 32'h00000000, "beq_T_x1x1");
    check(25, 32'h00000000, "bne_T_x1x2");
    check(26, 32'h00000001, "bne_NT_x1x1");
    check(27, 32'h00000000, "blt_T_x1x2");
    check(28, 32'h00000001, "blt_NT_x2x1");
    check(29, 32'h00000000, "bge_T_x2x1");
    check(30, 32'h00000001, "bge_NT_x1x2");
    check(31, 32'h00000000, "bltu_T_x2x1");
    check(32, 32'h00000001, "bltu_NT_x1x2");
    check(33, 32'h00000000, "bgeu_T_x1x2");
    check(34, 32'h00000001, "bgeu_NT_x2x1");
    check(35, 32'h0000018c, "jal_link");
    check(36, 32'h00000000, "jal_skip");
    check(37, 32'h000001a4, "jalr_link");
    check(38, 32'h00000000, "jalr_skip");
    if (errors == 0) $display("PASS: all 39 checks");
    else $display("FAILED: %0d of 39 checks",errors);
    $finish;
  end
  initial begin #200000; $display("TIMEOUT: halt loop never reached"); $finish; end
endmodule
