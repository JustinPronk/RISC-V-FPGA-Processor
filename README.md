# RV32I RISC-V Core

A single-cycle RV32I RISC-V core written in Verilog, built and verified from the ground up as an FPGA project. Current target: Intel/Altera via Quartus, with simulation in Icarus Verilog (and/or Questa).

## Project Phases

### Phase 1 — Core correctness (in progress)
- [x] Fetch / decode / execute / memory / writeback datapath wired and working
- [x] `addi`, `add`, `sw`, `lw` verified against expected register and memory values
- [ ] Remaining ALU operations verified: `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
- [ ] All 6 branch conditions verified, both taken and not-taken: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
- [ ] `jal` / `jalr` verified (including return-address writeback and jalr's bit-0 clear)
- [ ] `lui` / `auipc` verified
- [ ] x0 hardwired-zero behaviour verified (reads as zero, writes discarded)
- [ ] Passes the official **riscv-arch-test** compliance suite

### Phase 2 — Real software
- [ ] RISC-V GNU toolchain (`riscv32-unknown-elf-gcc`) set up
- [ ] Minimal linker script + startup file (crt0) written for this core's memory map
- [ ] Trivial C program running (`int main() { return 0; }`)
- [ ] A real computational C program running end-to-end (e.g. Fibonacci, bubble sort) with output visible via memory-mapped I/O

### Phase 3 — FPGA deployment
- [ ] Board/device target selected
- [ ] Debug output exposed (register contents on LEDs, minimum)
- [ ] Pin assignments complete
- [ ] Full compile and programmed onto real hardware
- [ ] Resource usage recorded (LUTs / registers used)
- [ ] Max clock frequency recorded (from TimeQuest/Fitter reports)

### Phase 4 — Pipeline
- [ ] Converted to 5-stage pipeline (IF/ID/EX/MEM/WB)
- [ ] Data hazard forwarding implemented
- [ ] Load-use hazard stall implemented
- [ ] Branch/control hazard flush implemented
- [ ] Re-verified against the same test suite as Phase 1
- [ ] CPI and max clock frequency recorded and compared against the single-cycle version

### Phase 5 — Verification rigor
- [ ] Self-checking testbench comparing every instruction's result against a reference model (Python ISS or Spike)
- [ ] Basic functional coverage tracked (which instructions/conditions have actually been exercised)

### Phase 6 — Stretch: physical design
- [ ] Core (or a sub-block) run through the open-source OpenLane / SKY130 flow
- [ ] Real synthesis/timing/area numbers recorded

## Current Status

Single-cycle datapath implemented across 7 modules (`alu`, `branch_unit`, `control`/`decoder`, `data_memory`, `instruction_memory`, `register_file`, `sign_extension`), wired together in `core.v`. Verified in simulation (Icarus Verilog) against a short hand-assembled test program covering `addi`, `add`, `sw`, `lw` — all register and memory values matched expected results.

## Target CV Line (once Phases 1–3 complete)

> Designed and verified a single-cycle RV32I RISC-V core in Verilog; passed the official riscv-arch-test compliance suite; compiled and ran C programs via the RISC-V GNU toolchain; deployed to a [board] FPGA achieving [X] MHz using [Y] logic elements.

With Phase 4:

> Extended the design to a 5-stage pipelined implementation with hazard detection and operand forwarding, improving clock frequency from [A] MHz to [B] MHz while maintaining full ISA compliance.
