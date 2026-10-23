0000: ffb00093  addi x1, x0, -5
0004: 00300113  addi x2, x0, 3
0008: 002081b3  add  x3, x1, x2
000c: 00302023  sw   x3, 0(x0)   # mem[0] = add
0010: 402081b3  sub  x3, x1, x2
0014: 00302223  sw   x3, 4(x0)   # mem[1] = sub
0018: 002091b3  sll  x3, x1, x2
001c: 00302423  sw   x3, 8(x0)   # mem[2] = sll
0020: 0020a1b3  slt  x3, x1, x2
0024: 00302623  sw   x3, 12(x0)   # mem[3] = slt
0028: 0020b1b3  sltu x3, x1, x2
002c: 00302823  sw   x3, 16(x0)   # mem[4] = sltu
0030: 0020c1b3  xor  x3, x1, x2
0034: 00302a23  sw   x3, 20(x0)   # mem[5] = xor
0038: 0020d1b3  srl  x3, x1, x2
003c: 00302c23  sw   x3, 24(x0)   # mem[6] = srl
0040: 4020d1b3  sra  x3, x1, x2
0044: 00302e23  sw   x3, 28(x0)   # mem[7] = sra
0048: 0020e1b3  or   x3, x1, x2
004c: 02302023  sw   x3, 32(x0)   # mem[8] = or
0050: 0020f1b3  and  x3, x1, x2
0054: 02302223  sw   x3, 36(x0)   # mem[9] = and
0058: 00a08193  addi x3, x1, 10
005c: 02302423  sw   x3, 40(x0)   # mem[10] = addi
0060: 0000a193  slti x3, x1, 0
0064: 02302623  sw   x3, 44(x0)   # mem[11] = slti
0068: fff0b193  sltiu x3, x1, -1
006c: 02302823  sw   x3, 48(x0)   # mem[12] = sltiu
0070: 0ff0c193  xori x3, x1, 0xFF
0074: 02302a23  sw   x3, 52(x0)   # mem[13] = xori
0078: 03016193  ori  x3, x2, 0x30
007c: 02302c23  sw   x3, 56(x0)   # mem[14] = ori
0080: 00f0f193  andi x3, x1, 0xF
0084: 02302e23  sw   x3, 60(x0)   # mem[15] = andi
0088: 00411193  slli x3, x2, 4
008c: 04302023  sw   x3, 64(x0)   # mem[16] = slli
0090: 0040d193  srli x3, x1, 4
0094: 04302223  sw   x3, 68(x0)   # mem[17] = srli
0098: 4040d193  srai x3, x1, 4
009c: 04302423  sw   x3, 72(x0)   # mem[18] = srai
00a0: 123451b7  lui  x3, 0x12345
00a4: 04302623  sw   x3, 76(x0)   # mem[19] = lui
00a8: 00001197  auipc x3, 1
00ac: 04302823  sw   x3, 80(x0)   # mem[20] = auipc
00b0: 00500013  addi x0, x0, 5
00b4: 04002a23  sw   x0, 84(x0)   # mem[21] = x0_zero
00b8: 20102023  sw   x1, 512(x0)
00bc: 20002183  lw   x3, 512(x0)
00c0: 04302c23  sw   x3, 88(x0)   # mem[22] = lw_roundtrip
00c4: 00000193  addi x3, x0, 0
00c8: 00208463  beq  x1, x2, +8
00cc: 00100193  addi x3, x0, 1   # skipped if branch taken
00d0: 04302e23  sw   x3, 92(x0)   # mem[23] = beq_NT_x1x2
00d4: 00000193  addi x3, x0, 0
00d8: 00108463  beq  x1, x1, +8
00dc: 00100193  addi x3, x0, 1   # skipped if branch taken
00e0: 06302023  sw   x3, 96(x0)   # mem[24] = beq_T_x1x1
00e4: 00000193  addi x3, x0, 0
00e8: 00209463  bne  x1, x2, +8
00ec: 00100193  addi x3, x0, 1   # skipped if branch taken
00f0: 06302223  sw   x3, 100(x0)   # mem[25] = bne_T_x1x2
00f4: 00000193  addi x3, x0, 0
00f8: 00109463  bne  x1, x1, +8
00fc: 00100193  addi x3, x0, 1   # skipped if branch taken
0100: 06302423  sw   x3, 104(x0)   # mem[26] = bne_NT_x1x1
0104: 00000193  addi x3, x0, 0
0108: 0020c463  blt  x1, x2, +8
010c: 00100193  addi x3, x0, 1   # skipped if branch taken
0110: 06302623  sw   x3, 108(x0)   # mem[27] = blt_T_x1x2
0114: 00000193  addi x3, x0, 0
0118: 00114463  blt  x2, x1, +8
011c: 00100193  addi x3, x0, 1   # skipped if branch taken
0120: 06302823  sw   x3, 112(x0)   # mem[28] = blt_NT_x2x1
0124: 00000193  addi x3, x0, 0
0128: 00115463  bge  x2, x1, +8
012c: 00100193  addi x3, x0, 1   # skipped if branch taken
0130: 06302a23  sw   x3, 116(x0)   # mem[29] = bge_T_x2x1
0134: 00000193  addi x3, x0, 0
0138: 0020d463  bge  x1, x2, +8
013c: 00100193  addi x3, x0, 1   # skipped if branch taken
0140: 06302c23  sw   x3, 120(x0)   # mem[30] = bge_NT_x1x2
0144: 00000193  addi x3, x0, 0
0148: 00116463  bltu x2, x1, +8
014c: 00100193  addi x3, x0, 1   # skipped if branch taken
0150: 06302e23  sw   x3, 124(x0)   # mem[31] = bltu_T_x2x1
0154: 00000193  addi x3, x0, 0
0158: 0020e463  bltu x1, x2, +8
015c: 00100193  addi x3, x0, 1   # skipped if branch taken
0160: 08302023  sw   x3, 128(x0)   # mem[32] = bltu_NT_x1x2
0164: 00000193  addi x3, x0, 0
0168: 0020f463  bgeu x1, x2, +8
016c: 00100193  addi x3, x0, 1   # skipped if branch taken
0170: 08302223  sw   x3, 132(x0)   # mem[33] = bgeu_T_x1x2
0174: 00000193  addi x3, x0, 0
0178: 00117463  bgeu x2, x1, +8
017c: 00100193  addi x3, x0, 1   # skipped if branch taken
0180: 08302423  sw   x3, 136(x0)   # mem[34] = bgeu_NT_x2x1
0184: 00000213  addi x4, x0, 0
0188: 008001ef  jal  x3, +8
018c: 06300213  addi x4, x0, 99   # must be skipped
0190: 08302623  sw   x3, 140(x0)   # mem[35] = jal_link
0194: 08402823  sw   x4, 144(x0)   # mem[36] = jal_skip
0198: 00000213  addi x4, x0, 0
019c: 00000297  auipc x5, 0
01a0: 00d281e7  jalr x3, 13(x5)   # target P+13 -> P+12
01a4: 06300213  addi x4, x0, 99   # must be skipped
01a8: 08302a23  sw   x3, 148(x0)   # mem[37] = jalr_link
01ac: 08402c23  sw   x4, 152(x0)   # mem[38] = jalr_skip
01b0: 00000063  beq  x0, x0, 0   # halt
