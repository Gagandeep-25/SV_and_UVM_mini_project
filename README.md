# SystemVerilog and UVM Mini Projects

## Overview

This repository contains a comprehensive collection of **SystemVerilog and UVM-based verification mini projects**. Each project demonstrates practical application of verification methodologies, UVM frameworks, and hardware design patterns for digital circuits.

## Projects Included

### 1. Data Flipflop Verification (UVM)
**Directory:** `Data_flipflop_verification_UVM/`

- **Description:** Complete UVM verification environment for D-flipflop with async reset
- **Features:**
  - Clock and reset handling
  - Asynchronous reset verification
  - UVM testbench with constrained random stimulus
  - Functional coverage and assertions
  - Coverage-driven verification

### 2. Combinational Adder (4-bit)
**Directory:** `combinational_adder/`

- **Description:** SystemVerilog testbench for 4-bit combinational adder
- **Features:**
  - Parallel data addition
  - Carry generation and propagation
  - Exhaustive test coverage
  - Transaction-based verification
  - Input stimulus randomization

### 3. Combinational Multiplier Verification (UVM)
**Directory:** `combinational_multiplier_verification_UVM/`

- **Description:** UVM environment for combinational multiplier verification
- **Features:**
  - 4-bit x 4-bit multiplier verification
  - UVM driver, monitor, and scoreboard
  - Parameterized testbench
  - Functional coverage metrics
  - Randomized test generation

### 4. 4-to-1 Multiplexer Verification (UVM)
**Directory:** `mux_4_to_1_verification_UVM/`

- **Description:** Complete UVM testbench for 4-to-1 multiplexer
- **Features:**
  - Selector logic verification
  - Output path verification
  - Cross coverage collection
  - Assertion-based verification
  - Full functional coverage

### 5. Sequential Adder
**Directory:** `sequential_adder/`

- **Description:** SystemVerilog testbench for sequential adder with state machine
- **Features:**
  - Serial data addition
  - State machine verification
  - Timing analysis
  - Protocol verification
  - Edge case testing

### 6. SV Projects (Additional SystemVerilog Examples)
**Directory:** `SV_projects/`

- **Description:** Miscellaneous SystemVerilog design and verification examples
- **Features:**
  - 4-bit adder testbench
  - Various verification patterns
  - Reusable components

## Directory Structure

```
.
├── Data_flipflop_verification_UVM/
├── SV_projects/
├── combinational_adder/
├── combinational_multiplier_verification_UVM/
├── mux_4_to_1_verification_UVM/
├── sequential_adder/
├── FULL_DUT_and_TB.sv
├── README.md
```

## Technologies Used

- **SystemVerilog:** HDL design and testbench development
- **UVM:** Universal Verification Methodology framework
- **Assertions:** Immediate and concurrent assertions
- **Coverage:** Functional and code coverage metrics
- **Randomization:** Constrained random verification (CRV)

## Verification Methodology

All UVM projects follow the standard verification flow:

1. **Test Planning:** Define test scenarios and coverage goals
2. **Environment Setup:** Create UVM components (driver, monitor, sequencer, etc.)
3. **Stimulus Generation:** Constrained random transaction generation
4. **Prediction & Scoring:** Scoreboard for result verification
5. **Coverage Collection:** Functional coverage tracking
6. **Analysis & Reporting:** Test results and coverage reports

## Key UVM Components Used

- **UVM Agent:** Contains driver, monitor, and sequencer
- **UVM Scoreboard:** Compares expected vs actual results
- **UVM Sequence:** Generates stimulus transactions
- **UVM Configuration:** Parameterized test configurations
- **Coverage:** Functional coverage collection

## Simulation Setup

### Prerequisites
- Simulation tool (ModelSim, Questa, VCS, Vivado, etc.)
- SystemVerilog support with UVM libraries

### Running Simulations

Navigate to the project directory and compile:

```bash
# Example for combinational adder
vlog combinational_adder/*.sv
vsim work.tb_adder

# Example for UVM project
vlog Data_flipflop_verification_UVM/*.sv
vsim -sv_lib \$MODEL_TECH/../uvm-1.2 work.tb_top
```

## Learning Outcomes

By exploring these projects, you will learn:

- SystemVerilog testbench architecture and best practices
- UVM framework and class hierarchy
- Constrained random verification techniques
- Functional coverage and code coverage
- Transaction-based verification
- Assertion-based verification
- Scoreboard design and verification
- Driver and monitor implementation

## File Statistics

- **Primary Language:** SystemVerilog (99.3%)
- **Secondary Language:** Verilog (0.7%)
- **Total Commits:** 83+

## References

- [UVM User's Guide](https://www.accellera.org/activities/systemverilog-uvm)
- [SystemVerilog IEEE Standard 1800-2017](https://standards.ieee.org/ieee/1800/6701/)
- [UVM Class Reference Manual](https://www.accellera.org/downloads/standards/uvm)

## Getting Started

1. Clone this repository
2. Navigate to a specific project directory
3. Review the SystemVerilog/UVM source files
4. Run the simulation using your preferred EDA tool
5. Analyze coverage reports and simulation results

## Tips for Exploration

- Start with simpler projects (Adders) to understand testbench structure
- Progress to UVM projects to learn UVM framework
- Study the scoreboard and coverage implementations
- Review assertions and how they catch design bugs
- Compare different verification approaches across projects

## License

MIT License

## Author

Gagandeep-25

---

**Note:** These are educational mini projects designed to demonstrate verification concepts and best practices in digital hardware design.
