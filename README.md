# RV32I RISC-V Core

A single-cycle RV32I RISC-V core written in Verilog, built as an FPGA project. Target: Intel/Altera via Quartus. Simulation: Icarus Verilog (and/or Questa).

**Status: work in progress.** The datapath is wired up and runs a small hand-assembled program. Most of the ISA is implemented but not yet verified; see the roadmap below.

## Architecture

- Single-cycle, 32-bit, Harvard (separate instruction and data memories)
- Word-addressed memories, 1024 words each by default (`MEM_SIZE` parameter)
- Combinational instruction fetch and data read; synchronous data write and register write
- Program loaded into instruction memory from `program.hex` via `$readmemh`

| Module | File | Role |
|---|---|---|
| `core` | `core.v` | Top level: PC, datapath wiring, next-PC and writeback muxes |
| `decoder` | `decoder.v` | Instruction decode and control signals |
| `alu` | `alu.v` | Add, sub, shifts, compares, logic |
| `branch_unit` | `branch_unit.v` | Branch condition evaluation, unconditional jump flag |
| `register_file` | `register_file.v` | 32 x 32-bit registers, x0 hardwired to zero |
| `sign_extension` | `sign_extension.v` | I/S/B/U/J immediate generation |
| `instruction_memory` | `instruction_memory.v` | Read-only program memory |
| `data_memory` | `data_memory.v` | Word-wide data memory |

## ISA coverage

| Group | Instructions | Implemented | Verified |
|---|---|---|---|
| Immediate ALU | `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai` | Yes | `addi` only |
| Register ALU | `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and` | Yes | `add` only |
| Loads / stores | `lw`, `sw` | Yes | Yes |
| Sub-word loads / stores | `lb`, `lh`, `lbu`, `lhu`, `sb`, `sh` | No | No |
| Branches | `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu` | Yes | No |
| Jumps | `jal`, `jalr` | Yes | No |
| Upper immediates | `lui`, `auipc` | Yes | No |
| System | `fence`, `ecall`, `ebreak` | No | No |

## Simulation

`program.hex` is loaded by `instruction_memory.v` relative to the simulator's working directory, so run from the folder containing it.

```
iverilog -g2012 -o sim.out alu.v branch_unit.v decoder.v sign_extension.v register_file.v data_memory.v instruction_memory.v core.v tb_full.v
vvp sim.out
```

`program.hex` is a self-checking test program (assembly listing in `test_program.asm`). It stores a result for every test into data memory, and `tb_full.v` compares each one against its expected value, printing `PASS` or a named `FAIL` per check. It covers the register and immediate ALU ops, `lui`, `auipc`, x0 write-discard, a `sw`/`lw` round trip, all six branches taken and not taken, `jal` and `jalr`.

`program_basic.hex` is the original short program (`addi`, `add`, `sw`, `lw`). To run it with `tb_core.v`, copy it over `program.hex`.

## Known limitations

- Data memory is word-only: no byte or halfword access, no byte enables
- Harvard split means initialised C data (`.data`, `.rodata`) has no path into data memory yet
- Memory addresses wrap (only low address bits are used), no bounds checking, no memory-mapped I/O yet
- Memories use asynchronous reads, so they will not map to FPGA block RAM as written
- Register file has a synchronous reset on all 32 registers, which costs logic on FPGA

## Roadmap

### Phase 1: Core correctness (in progress)
- [x] Fetch / decode / execute / memory / writeback datapath wired and working
- [x] `addi`, `add`, `sw`, `lw` verified against expected register and memory values
- [ ] Remaining ALU operations verified: `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
- [ ] All 6 branch conditions verified, both taken and not-taken: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
- [ ] `jal` / `jalr` verified (including return-address writeback and jalr's bit-0 clear)
- [ ] `lui` / `auipc` verified
- [ ] x0 hardwired-zero behaviour verified (reads as zero, writes discarded)
- [ ] Sub-word loads and stores implemented and verified: `lb`, `lh`, `lbu`, `lhu`, `sb`, `sh`
- [ ] Passes the official **riscv-arch-test** compliance suite

### Phase 2: Real software
- [ ] RISC-V GNU toolchain (`riscv32-unknown-elf-gcc`) set up
- [ ] Minimal linker script + startup file (crt0) written for this core's memory map
- [ ] Initialised data path into data memory (preload or unified memory)
- [ ] Trivial C program running (`int main() { return 0; }`)
- [ ] A real computational C program running end-to-end (e.g. Fibonacci, bubble sort) with output visible via memory-mapped I/O

### Phase 3: FPGA deployment
- [ ] Board/device target selected
- [ ] Memories converted to synchronous read so they infer block RAM
- [ ] Debug output exposed (register contents on LEDs, minimum)
- [ ] Pin assignments complete
- [ ] Full compile and programmed onto real hardware
- [ ] Resource usage recorded (LUTs / registers used)
- [ ] Max clock frequency recorded (from TimeQuest/Fitter reports)

### Phase 4: Pipeline
- [ ] Converted to 5-stage pipeline (IF/ID/EX/MEM/WB)
- [ ] Data hazard forwarding implemented
- [ ] Load-use hazard stall implemented
- [ ] Branch/control hazard flush implemented
- [ ] Re-verified against the same test suite as Phase 1
- [ ] CPI and max clock frequency recorded and compared against the single-cycle version

### Phase 5: Verification rigor
- [ ] Self-checking testbench comparing every instruction's result against a reference model (Python ISS or Spike)
- [ ] Basic functional coverage tracked (which instructions/conditions have actually been exercised)

### Phase 6: Stretch, physical design
- [ ] Core (or a sub-block) run through the open-source OpenLane / SKY130 flow
- [ ] Real synthesis/timing/area numbers recorded
