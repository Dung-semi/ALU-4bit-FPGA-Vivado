# ALU_4bit_SE190745 — Resource-Shared 4-Bit Arithmetic Logic Unit

A resource-shared 4-bit Arithmetic Logic Unit (ALU) designed using Verilog HDL and implemented with AMD Xilinx Vivado 2026.1 for the Artix-7 FPGA platform.

The project covers modular RTL design, self-checking simulation, waveform analysis, FPGA synthesis, implementation, and hardware resource evaluation.

## Project Information

| Item | Description |
|---|---|
| Project Name | ALU_4bit_SE190745 |
| Author | Lê Kỳ Dũng |
| Student ID | SE190745 |
| University | FPT University HCMC |
| Department | Microelectronics and IC Design |
| Design Tool | AMD Xilinx Vivado 2026.1 |
| HDL | Verilog |
| Target FPGA | Artix-7 |
| Target Device | `xc7a100tcsg324-1` |

## 1. Project Overview

The objective of this project is to design and verify a 4-bit Arithmetic Logic Unit supporting ten operations selected by a 4-bit opcode.

The ALU combines combinational arithmetic and logic operations with sequential multiplication and division. To reduce hardware resource usage, it shares a single 4-bit ripple-carry adder/subtractor between normal arithmetic operations and the sequential multiply/divide engine.

The project includes:

- Modular and hierarchical Verilog RTL design.
- A shared adder/subtractor datapath.
- Arithmetic, bitwise logic, and shift operations.
- Four-cycle sequential multiplication and restoring division.
- Zero, Carry, Overflow, and Negative status flags.
- Self-checking testbench verification.
- Behavioral waveform and step-table analysis.
- Vivado elaboration, synthesis, implementation, and resource analysis.

## 2. Architecture Specifications

| Component | Specification |
|---|---|
| ALU input A | 4 bits |
| ALU input B | 4 bits |
| Opcode | 4 bits |
| Main arithmetic datapath | 4-bit ripple-carry adder/subtractor |
| Result output | 8 bits |
| Number of supported operations | 10 |
| Combinational operations | 8 |
| Sequential operations | Multiplication and division |
| Sequential operation latency | 4 clock cycles |
| Status flags | Carry (C), Zero (Z), Overflow (V), Negative (N) |
| Design language | Verilog HDL |
| FPGA family | Artix-7 |

## 3. Instruction / Opcode Table

The ALU supports ten operations, selected using `opcode[3:0]`.

| Opcode | Binary | Operation | Description |
|---|---|---|---|
| `0` | `0000` | ADD | Add A and B |
| `1` | `0001` | SUB | Subtract B from A |
| `2` | `0010` | AND | Bitwise AND |
| `3` | `0011` | OR | Bitwise OR |
| `4` | `0100` | XOR | Bitwise exclusive OR |
| `5` | `0101` | NOT | Bitwise complement of A |
| `6` | `0110` | SHL | Logical left shift of A by one bit |
| `7` | `0111` | SHR | Logical right shift of A by one bit |
| `8` | `1000` | MUL | Sequential multiplication of A and B |
| `9` | `1001` | DIV | Sequential division of A by B |

Opcodes `0–7` execute combinationally. Multiplication and division use the sequential `muldiv_unit` and complete in four clock cycles, according to the project report.

### Shift Operations

**Logical left shift (SHL):**

```text
out_shl = {A[2:0], 1'b0}
```

**Logical right shift (SHR):**

```text
out_shr = {1'b0, A[3:1]}
```

The shifted-out bit contributes to the Carry flag as described in the report.

## 4. Modular RTL Architecture

The design uses a hierarchical structure with `alu_4bit.v` as the top-level module and specialized functional submodules underneath it.

### Main Functional Blocks

| Module | Responsibility |
|---|---|
| `alu_4bit.v` | Top-level ALU integration |
| `control_unit.v` | Decodes the opcode and generates operation-control signals |
| `adder_subtractor_4bit.v` | Performs addition and two's-complement subtraction |
| `full_adder.v` | Implements a 1-bit full-adder stage |
| `logic_unit_4bit.v` | Performs AND, OR, XOR, and NOT operations |
| `shifter_4bit.v` | Implements logical left and right shifts |
| `muldiv_unit.v` | Performs sequential multiplication and restoring division |
| `flag_unit.v` | Generates status flags |

The top-level design also uses multiplexers to select the adder operands and subtraction control signal.

### Shared Adder/Subtractor Datapath

The arithmetic unit uses four cascaded full adders to implement a ripple-carry adder/subtractor.

For subtraction, the B operand is conditionally inverted and the initial carry is set according to the `sub` control signal.

```text
Addition:     A + B
Subtraction:  A + (~B) + 1
```

This allows arithmetic operations and the sequential multiply/divide engine to reuse the same adder/subtractor instead of requiring a separate dedicated adder in the multiply/divide unit.

The `busy` signal controls multiplexers that select either the external ALU operands or the internal operands used by the sequential engine.

## 5. Status Flags

The ALU reports four status flags.

| Flag | Meaning |
|---|---|
| `C` — Carry | Indicates carry-related or operation-specific shifted-bit status |
| `Z` — Zero | Indicates that the relevant result is zero |
| `V` — Overflow | Indicates signed arithmetic overflow |
| `N` — Negative | Represents the sign bit of the relevant result |

For subtraction, the report uses the convention that `C = 1` indicates no borrow, while `C = 0` indicates a borrow.

The Zero flag considers the 8-bit result for multiplication and division, and the 4-bit result for the other operations.

For logical shifts, the Carry flag reflects the bit shifted out of the operand.

## 6. Sequential Multiplication and Division

### Multiplication (MUL)

Multiplication is implemented using a four-cycle shift-and-add algorithm.

- Opcode: `1000`
- Inputs: 4-bit operands A and B.
- Result: 8-bit product.
- Handshake signals: `start`, `busy`, and `done`.

**Example:**

```text
A = 7
B = 6
A × B = 42
Result = 8'h2A
```

The testbench reports completion after four clock cycles.

### Division (DIV)

Division uses a four-cycle restoring division algorithm.

The result is organized into two 4-bit portions:

- `result[7:4]`: remainder.
- `result[3:0]`: quotient.

**Example:**

```text
A = 13
B = 3

Quotient  = 4
Remainder = 1

Result = 8'h14
```

### Divide-by-Zero Handling

When the divisor is zero, the unit asserts `div_by_zero` and `done` without entering the calculation loop. The reported testbench also verifies that the previous result is preserved.

## 7. Simulation and Verification

The project uses `alu_4bit_tb.v`, a self-checking testbench that applies input stimuli, checks expected results, and maintains a 32-bit error counter:

```text
error_count[31:0]
```

The reported simulations cover the eight combinational opcodes, sequential multiplication and division, and the divide-by-zero exception.

### Verification Examples

| Operation | Input A | Input B | Expected Result |
|---|---:|---:|---:|
| ADD | 5 | 3 | `8'h08` |
| SUB | 9 | 4 | `8'h05` |
| AND | 12 | 10 | `8'h08` |
| OR | 12 | 3 | `8'h0F` |
| XOR | 12 | 10 | `8'h06` |
| NOT | 10 | — | `8'h05` |
| SHL | 3 | — | `8'h06` |
| SHR | 12 | — | `8'h06` |
| MUL | 7 | 6 | `8'h2A` |
| DIV | 13 | 3 | `8'h14` |

The simulation report records the following outcomes:

- All ten operations were exercised.
- Arithmetic overflow and carry behavior were checked.
- Multiplication and division completed using the sequential engine.
- Divide-by-zero handling was verified.
- `error_count` remained `00000000` throughout the reported test cases.

**Reported functional result: zero errors across the documented verification scenarios.**

## 8. Vivado Design Flow

The project follows the documented F1–F6 workflow.

| Stage | Description |
|---|---|
| F1 — Project Creation | Configure the Vivado project and integrate the RTL hierarchy |
| F2 — Elaboration | Generate the RTL schematic and inspect design connectivity |
| F3 — Combinational Simulation | Verify opcodes 0–7 and analyze waveforms |
| F4 — Sequential Simulation | Verify multiplication, division, and divide-by-zero behavior |
| F5 — Synthesis and Reports | Review implementation resources and estimated power |
| F6 — Device View | Inspect physical placement and routing on the FPGA device |

The elaborated design report records:

| Metric | Reported Value |
|---|---:|
| Top-level cells | 10 |
| I/O ports | 30 |
| Nets | 92 |

The report also documents a static linter notification concerning unused input bits in the flag logic. The Carry logic uses the relevant shifted-out operand bits for the shift operations.

## 9. FPGA Implementation Results

The reported post-implementation resource utilization on the Artix-7 `xc7a100tcsg324-1` device is summarized below.

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| Slice LUTs | 60 | 63,400 | 0.09% |
| Slice Flip-Flops | 26 | 126,800 | 0.02% |
| Bonded I/O Pins | 30 | 210 | 14.29% |
| BUFG | 1 | 32 | 3.13% |

The report also documents the physical placement of the design in clock region `X0Y1`, around tile `CLBLM_R_X3Y63`, including slices `SLICE_X2Y63` and `SLICE_X3Y63`.

### Power and Timing Limitations

The report records an unconstrained power estimate of:

| Metric | Reported Value |
|---|---:|
| Total on-chip power | 3.962 W |
| Junction temperature | 43.1 °C |
| Thermal margin | 41.9 °C |

These are Vivado estimates, not measurements from physical hardware.

The project did not include an external XDC clock constraint file. As a result, timing was reported as unavailable (`NA`), and the power estimate had low confidence.

For a more complete implementation analysis, the next step is to add appropriate clock and I/O timing constraints, rerun the reports, and review the updated timing and power results.

## 10. Project Structure

The following is a logical overview based on the technical report. Confirm the exact file names and locations in the repository before relying on this tree.

```text
ALU_4bit_SE190745/
├── README.md
├── ALU_4bit_SE190745.pdf
│
├── alu_4bit.v
├── control_unit.v
├── adder_subtractor_4bit.v
├── full_adder.v
├── logic_unit_4bit.v
├── shifter_4bit.v
├── muldiv_unit.v
├── flag_unit.v
│
└── alu_4bit_tb.v
```

Vivado project files, simulation configuration, waveform files, and implementation reports may also be present.

## 11. Future Improvements

Potential next steps include:

- Add an XDC constraint file with clock and I/O delay constraints.
- Rerun static timing analysis to obtain meaningful timing metrics.
- Verify the implementation reports under fully constrained conditions.
- Extend the testbench with additional boundary cases and randomized testing.
- Further evaluate the area and timing trade-offs of the shared adder/subtractor architecture.
- Explore alternative implementations of the sequential multiplication and division units.

## 12. Conclusion

The `ALU_4bit_SE190745` project demonstrates a modular 4-bit ALU design that combines arithmetic, bitwise logic, shifting, sequential multiplication, and restoring division.

By sharing the ripple-carry adder/subtractor between arithmetic instructions and the sequential multiply/divide engine, the design aims to reduce hardware duplication while supporting ten operations and four status flags.

The project completed its documented self-checking simulation scenarios with zero reported errors and achieved the resource utilization reported for the Artix-7 target in Vivado 2026.1.

## Author

**Lê Kỳ Dũng**  
Student ID: SE190745  
Microelectronics and IC Design  
FPT University HCMC

**Project:** ALU_4bit_SE190745  
**Tool:** AMD Xilinx Vivado 2026.1  
**Target:** Artix-7 FPGA (`xc7a100tcsg324-1`)
