# ASIC-style HCF (GCD) Finder — Verilog (Data Path + FSM Controller)

This project implements a **hardware HCF / GCD finder** in **Verilog HDL** using an ASIC-style separation of **Data Path** and **Control Path (FSM)**.  
It uses the subtraction form of Euclid’s algorithm and demonstrates resource sharing (single subtractor steered by MUXes) and a small FSM that sequences register loads, compares and subtractions.

---

## Project Overview
The design repeatedly subtracts the smaller operand from the larger until both operands are equal. That equal value is the HCF.

1. **Load Inputs**  
   - Two 16-bit operands `A` and `B` are loaded into PIPO registers (`load_a`, `load_b`, `data_in`).  

2. **Compare**  
   - A 16-bit comparator asserts `lt`, `gt`, or `eq` (`A < B`, `A > B`, `A == B`).  

3. **Subtract & Update**  
   - If `A < B`: compute `B = B - A` (via the shared subtractor) and reload `B`.  
   - If `A > B`: compute `A = A - B` and reload `A`.  
   - If `A == B`: done — `A` (or `B`) is the HCF.

4. **Repeat**  
   - The FSM loops compare → subtract → load until equality is reached.

**Example:** Input `A = 143`, `B = 78` → HCF = `13`.

---

## Key Features
- ✅ Clean Data Path / Control Path separation  
- ✅ 16-bit datapath (parameterizable)  
- ✅ Two PIPO registers (A, B) for operand storage  
- ✅ One 16-bit comparator (`lt`, `gt`, `eq`)  
- ✅ One 16-bit subtractor shared by steering MUXes  
- ✅ Three 16-bit 2:1 MUXes for input steering / resource sharing  
- ✅ Small FSM controller (states: `S0` load A, `S1` load B, `S2` compare, `S3` B=B−A, `S4` A=A−B, `S5` done)  
- ✅ Testbench & EDA Playground–ready examples

---

## Module Summaries
- **`pipo.v`**  
  Clocked parallel-in parallel-out register used as storage for A and B. Inputs: `clk`, `rst`, `load`, `data_in`. Output: stored value.

- **`comparator.v`**  
  Combinational 16-bit comparator producing `lt`, `gt`, `eq` signals.

- **`subtractor.v`** (`sub.v`)  
  16-bit subtractor that computes `X - Y`. No special flags required; used with mux steering to compute either `A-B` or `B-A`.

- **`mux.v`**  
  2:1 16-bit MUX module used to select the subtractor operands and select inputs onto the internal bus.

- **`datapath.v`**  
  Instantiates registers (A, B), comparator, subtractor, and MUXes. Accepts control signals from controller:
  - `load_a`, `load_b`, `sel1`, `sel2`, `sel_in`, `data_in`, `clk`, `rst`.  
  Outputs comparator flags: `lt`, `gt`, `eq` and optionally `subOut` or `result_out`.

- **`controller.v`**  
  FSM sequencing the datapath with states:
  - `S0` — Load A  
  - `S1` — Load B  
  - `S2` — Compare A and B  
  - `S3` — B = B − A (if A < B)  
  - `S4` — A = A − B (if A > B)  
  - `S5` — Done (A == B, result ready)

- **`top.v`**  
  Top-level wrapper to connect datapath and controller; exposes simple ports for testbench or integration. Adjust port names as required by your implementation.

---

## How it works (step-by-step)
1. Apply `reset` then assert `data_in` and `load_a`/`load_b` during `S0`/`S1` (or use top-level load interface).  
2. Controller goes to `S2` to sample comparator outputs (`lt`, `gt`, `eq`).  
3. If `eq` → go to `S5` done and assert `ready/result_valid`.  
4. If `lt` → controller asserts `sel` signals to feed subtractor `B - A`, asserts `load_b` to store subtractor output into `B`, then loop to `S2`.  
5. If `gt` → similarly compute `A - B`, load into `A`, then loop to `S2`.  
6. Repeat until equality — the equal register value is HCF.

---

## Simulation (EDA Playground / Icarus-Verilog)
**EDA Playground**
- Create a new project, add the `src/*.v` files and `tb/tb_top.v`.  
- Select a simulator (Icarus or ModelSim).  
- Run and view waveform or console prints.

**Local (Icarus)**
```bash
iverilog -o sim.vvp src/*.v tb/tb_top.v
vvp sim.vvp
# If testbench generates dump.vcd:
gtkwave dump.vcd
