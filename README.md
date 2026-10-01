# Resource-Shared 4-Bit ALU in Vivado 2026.1 (`ALU_4bit_SE190745`)

* **Student Name:** Le Ky Dung
* **Roll Number:** `SE190745`
* **Target Device:** Xilinx Artix-7 (`xc7a100tcsg324-1`) — AMD Vivado 2026.1

---

## 📂 Complete Submission Checklist (Following Marking Scheme)

* **A. Design (`./rtl/`):** 8 synthesizable Verilog modules with complete header comments (`SE190745`).
* **B. Testbench (`./tb/alu_4bit_tb.v`):** Self-checking testbench printing Name & Roll Number (`SE190745`), testing **Part 1** (Combinational) + **Part 2** (Sequential Mul/Div & Divide-by-Zero), tracking `error_count = 0`, and ending with a `PASS` line.
* **C. Truth / Step Table & E. Flow Explanation:** 📄 **[Click Here to View Full Technical Report & Answer Sheet (PDF)](./docs/ALU_4bit_Report_SE190745.pdf)**
* **D. Flow Screenshots (`F1`–`F6`):** All 6 full-window screenshots with project name (`ALU_4bit_SE190745`) visible (displayed below).
* **Complete ALU Zip File:** 📦 **[Download `ALU_4bit_SE190745.zip`](./ALU_4bit_SE190745.zip)**

---

## C. Truth / Step Table (From Behavioral Simulation `F3` & `F4`)

| Time (ns) | Opcode | Binary | Operation | `a` (Dec) | `b` (Dec) | `result[7:0]` (Hex) | C | Z | V | N | `error_count` | Notes |
| :---: | :---: | :---: | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `0 - 20` | `0` | `0000` | **RESET** (`rst=1`) | 0 | 0 | `00` | 0 | 1 | 0 | 0 | `00000000` | Clears sequential registers |
| `20 - 40` | `0` | `0000` | **ADD** (`5 + 3`) | 5 | 3 | `08` (8) | 0 | 0 | 1 | 1 | `00000000` | Signed 4-bit overflow (`+5+3=-8`) |
| `40 - 60` | `1` | `0001` | **SUB** (`9 - 4`) | 9 | 4 | `05` (5) | 1 | 0 | 1 | 0 | `00000000` | `C=1` (no borrow), signed underflow |
| `60 - 80` | `2` | `0010` | **AND** (`12 & 10`) | 12 | 10 | `08` (8) | 0 | 0 | 0 | 1 | `00000000` | `1100 & 1010 = 1000` |
| `80 - 100` | `3` | `0011` | **OR** (`12 \| 3`) | 12 | 3 | `0f` (15) | 0 | 0 | 0 | 1 | `00000000` | `1100 \| 0011 = 1111` |
| `100 - 120` | `4` | `0100` | **XOR** (`12 ^ 10`) | 12 | 10 | `06` (6) | 0 | 0 | 0 | 0 | `00000000` | `1100 ^ 1010 = 0110` |
| `120 - 140` | `5` | `0101` | **NOT** (`~10`) | 10 | 10 | `05` (5) | 0 | 0 | 0 | 0 | `00000000` | `~1010 = 0101` (ignores `b`) |
| `140 - 160` | `6` | `0110` | **SHL** (`3 << 1`) | 3 | 10 | `06` (6) | 0 | 0 | 0 | 0 | `00000000` | `carry = a[3] = 0` |
| `160 - 180` | `7` | `0111` | **SHR** (`12 >> 1`) | 12 | 10 | `06` (6) | 0 | 0 | 0 | 0 | `00000000` | `carry = a[0] = 0` |
| `180 - 235` | `8` | `1000` | **MUL** (`7 * 6`) | 7 | 6 | `2a` (42) | 0 | 0 | 0 | 0 | `00000000` | `busy=1` (`185-225ns`), `done=1` at `225ns` |
| `245 - 305` | `9` | `1001` | **DIV** (`13 / 3`) | 13 | 3 | `14` (Rem=1, Quot=4) | 0 | 0 | 0 | 0 | `00000000` | `busy=1` (`255-295ns`), `done=1` at `295ns` |
| `305 - 385` | `9` | `1001` | **DIV** (`8 / 0`) | 8 | 0 | Holds `14` | 0 | 0 | 0 | 0 | `00000000` | `div_by_zero=1`, `done=1` at `315ns` |

---

## Post-Implementation Resource Utilization (`xc7a100tcsg324-1`)

| Resource Type | Used | Available | Utilization (%) |
| :--- | :---: | :---: | :---: |
| **Slice LUTs** | 60 | 63,400 | 0.09% |
| **Slice Registers (Flip-Flops)** | 26 | 126,800 | 0.02% |
| **Bonded IOB** | 30 | 210 | 14.29% |
| **BUFGCTRL** | 1 | 32 | 3.13% |

---

## D. Flow Screenshots (`F1` – `F6`, Full Window with Project Name Visible)

### F1: RTL Hierarchy & Design Sources (`ALU_4bit_SE190745`)
![F1](./docs/F1.png)

### F2: Elaborated RTL Schematic & Linter (`ASSIGN-10#1`)
![F2](./docs/F2.png)

### F3: Behavioral Simulation Waveform (Part 1: Combinational & `error_count = 0`)
![F3](./docs/F3.png)

### F4: Behavioral Simulation Waveform (Part 2: Sequential Mul/Div & Divide-by-Zero)
![F4](./docs/F4.png)

### F5: Post-Implementation Utilization Table (60 LUTs, 26 FFs) & Power Summary
![F5](./docs/F5.png)

### F6: Physical FPGA Device Floorplan (Clock Region `X0Y1`, Tile `CLBLM_R_X3Y63`)
![F6](./docs/F6.png)
