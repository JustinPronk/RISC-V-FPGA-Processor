`timescale 1ns/1ps

module tb_core;

    reg clk = 0;
    reg rst = 1;
    always #5 clk = ~clk;

    core dut (.clk(clk), .rst(rst));

    initial begin
        // Hold reset for a few cycles, then release it
        repeat (3) @(posedge clk);
        rst <= 0;

        // Program is only 6 instructions (single cycle each), then loops
        // forever on the final beq. 15 cycles is plenty of margin.
        repeat (15) @(posedge clk);

        $display("---------------------------------");
        $display("x1 = %0d (expect 5)",  dut.u_regfile.regs[1]);
        $display("x2 = %0d (expect 10)", dut.u_regfile.regs[2]);
        $display("x3 = %0d (expect 15)", dut.u_regfile.regs[3]);
        $display("x4 = %0d (expect 15)", dut.u_regfile.regs[4]);
        $display("mem[0] = %0d (expect 15)", dut.u_dmem.mem[0]);
        $display("---------------------------------");

        if (dut.u_regfile.regs[1] == 5  &&
            dut.u_regfile.regs[2] == 10 &&
            dut.u_regfile.regs[3] == 15 &&
            dut.u_regfile.regs[4] == 15)
            $display("PASS");
        else
            $display("FAIL");

        $finish;
    end

endmodule
