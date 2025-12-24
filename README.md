# SystemVerilog and UVM Mini Projects

## Overview

This repository contains a comprehensive collection of **SystemVerilog and UVM-based verification mini projects**. Each project demonstrates practical application of verification methodologies, UVM frameworks, and hardware design patterns for digital circuits.

---

## 📁 Projects Included

### 1. Data Flipflop Verification (UVM)
**Directory:** `Data_flipflop_verification_UVM/`

**Description:** Complete UVM verification environment for D-flipflop with asynchronous reset

**Features:**
- Clock and reset handling
- Asynchronous reset verification
- UVM testbench with constrained random stimulus
- Functional coverage and assertions
- Coverage-driven verification

**Key Components:**
- `TB_top`: Top-level testbench
- `FULL_DUT_and_TB.sv`: Complete DUT and testbench
- UVM driver with reset sequencing
- Comprehensive assertion suite

---

### 2. Combinational Adder (4-bit)
**Directory:** `combinational_adder/`

**Description:** SystemVerilog testbench for 4-bit combinational adder

**Features:**
- Parallel data addition
- Carry generation and propagation
- Exhaustive test coverage
- Transaction-based verification
- Input stimulus randomization

**Key Testbench Elements:**
- Stimulus generation with random carry-in
- Output verification and comparison
- Self-checking testbench

---

### 3. Combinational Multiplier Verification (UVM)
**Directory:** `combinational_multiplier_verification_UVM/`

**Description:** UVM environment for combinational multiplier verification

**Features:**
- 4-bit x 4-bit multiplier verification
- UVM driver, monitor, and scoreboard
- Parameterized testbench
- Functional coverage metrics
- Randomized test generation

**Key UVM Components:**
- `uvm_agent` for stimulus generation
- `uvm_driver` for applying transactions
- `uvm_monitor` for observing outputs
- `uvm_scoreboard` for result verification
- Coverage collection for quality metrics

---

### 4. 4-to-1 Multiplexer Verification (UVM)
**Directory:** `mux_4_to_1_verification_UVM/`

**Description:** Complete UVM testbench for 4-to-1 multiplexer

**Features:**
- Selector logic verification
- Output path verification
- Cross coverage collection
- Assertion-based verification
- Full functional coverage

**Verification Scenarios:**
- All selector combinations
- All input transitions
- Timing parameter checks

---

### 5. Sequential Adder
**Directory:** `sequential_adder/`

**Description:** SystemVerilog testbench for sequential adder with state machine

**Features:**
- Serial data addition
- State machine verification
- Timing analysis
- Protocol verification
- Edge case testing

**State Machine Verification:**
- Reset state validation
- State transitions
- Data accumulation verification

---

### 6. Simple ALU Verification
**Directory:** `simple_ALU_verification/`

**Description:** Verification of basic Arithmetic Logic Unit

**Features:**
- Multiple operation support
- Flag generation and verification
- Data path testing
- Operation encoding validation

---

### 7. SV Projects (Additional SystemVerilog Examples)
**Directory:** `SV_projects/`

**Description:** Miscellaneous SystemVerilog design and verification examples

**Features:**
- 4-bit adder testbench
- Various verification patterns
- Reusable components
- Design examples

---

## 📊 Directory Structure

```
.
├── Data_flipflop_verification_UVM/
│   ├── FULL_DUT_and_TB.sv
│   ├── TB_top.sv
│   └── ...
├── SV_projects/
│   ├── adder_tb.sv
│   └── ...
├── combinational_adder/
│   ├── adder_design.sv
│   ├── adder_tb.sv
│   └── ...
├── combinational_multiplier_verification_UVM/
│   ├── FULL_DUT_and_TB.sv
│   ├── multiplier_agent.sv
│   └── ...
├── mux_4_to_1_verification_UVM/
│   ├── FULL_DUT_and_TB.sv
│   ├── mux_env.sv
│   └── ...
├── sequential_adder/
│   ├── seq_adder_design.sv
│   ├── seq_adder_tb.sv
│   └── ...
├── simple_ALU_verification/
│   ├── FULL_DUT_and_TB.sv
│   └── ...
├── FULL_DUT_and_TB.sv
└── README.md
```

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|----------|
| **SystemVerilog** | HDL design and testbench development |
| **UVM** | Universal Verification Methodology framework |
| **Assertions** | Immediate and concurrent assertions for property checking |
| **Coverage** | Functional and code coverage metrics |
| **Randomization** | Constrained random verification (CRV) |
| **Simulation Tools** | ModelSim, Questa, VCS, or Vivado |

---

## 📋 Verification Methodology

All UVM projects follow the standard verification flow:

1. **Test Planning**
   - Define test scenarios and coverage goals
   - Identify critical functionality to verify
   - Plan coverage metrics

2. **Environment Setup**
   - Create UVM components (driver, monitor, sequencer, etc.)
   - Configure testbench hierarchy
   - Set up scoreboards and coverage collection

3. **Stimulus Generation**
   - Constrained random transaction generation
   - Sequence-based stimulus
   - Edge case and corner case testing

4. **Prediction & Scoring**
   - Scoreboard for result verification
   - Expected vs. actual comparison
   - Error detection and reporting

5. **Coverage Collection**
   - Functional coverage tracking
   - Code coverage metrics
   - Cross coverage analysis

6. **Analysis & Reporting**
   - Test results and coverage reports
   - Failure analysis
   - Coverage closure verification

---

## 🔧 Key UVM Components Used

- **UVM Agent:** Contains driver, monitor, and sequencer
- **UVM Driver:** Applies stimulus transactions to DUT
- **UVM Monitor:** Observes and records DUT outputs
- **UVM Sequencer:** Controls stimulus generation
- **UVM Scoreboard:** Compares expected vs actual results
- **UVM Sequence:** Generates stimulus transactions
- **UVM Configuration:** Parameterized test configurations
- **Coverage:** Functional coverage collection and analysis

---

## ⚡ Simulation Setup

### Prerequisites

- Simulation tool: ModelSim, Questa, VCS, or Vivado
- SystemVerilog support with UVM libraries
- Basic knowledge of HDL and verification concepts

### Running Simulations

#### For SystemVerilog Testbenches:

```bash
# Navigate to project directory
cd combinational_adder/

# Compile
vlog *.sv

# Simulate
vsim work.tb_adder
```

#### For UVM Projects:

```bash
# Navigate to UVM project directory
cd Data_flipflop_verification_UVM/

# Compile with UVM library
vlog -sv *.sv

# Run simulation with UVM
vsim -sv_lib $QUESTA_HOME/uvm-1.2 work.tb_top

# Or for VCS:
vcs -full64 -sverilog -ntb_opts uvm *.sv
./simv
```

### Viewing Results

```bash
# Waveform analysis
# Open Wave window in ModelSim/Questa and examine signal behavior

# Coverage reports
# Review .ucdb files for functional coverage
# Check code coverage reports
```

---

## 📚 Learning Outcomes

By exploring these projects, you will learn:

✅ **SystemVerilog Concepts:**
- Testbench architecture and best practices
- Constrained random verification (CRV)
- Assertion-based verification
- Coverage-driven verification

✅ **UVM Framework:**
- UVM class hierarchy and base classes
- Component architecture (agent, driver, monitor, sequencer)
- Transaction-based verification
- Stimulus generation and response checking

✅ **Verification Techniques:**
- Self-checking testbenches
- Scoreboard design and verification
- Driver and monitor implementation
- Functional coverage and coverage metrics

✅ **Design Verification:**
- Digital circuit verification
- State machine verification
- Arithmetic circuit testing
- Logic verification patterns

---

## 📈 File Statistics

- **Primary Language:** SystemVerilog (99.3%)
- **Secondary Language:** Verilog (0.7%)
- **Total Commits:** 95+
- **Number of Projects:** 7
- **Total Files:** 50+

---

## 🔗 References

- [UVM User's Guide](https://www.accellera.org/activities/systemverilog-uvm)
- [SystemVerilog IEEE Standard 1800-2017](https://standards.ieee.org/ieee/1800/6701/)
- [UVM Class Reference Manual](https://www.accellera.org/downloads/standards/uvm)
- [Accellera SystemVerilog Resources](https://www.accellera.org/activities/systemverilog)

---

## 🚀 Getting Started

1. **Clone this repository**
   ```bash
   git clone https://github.com/Gagandeep-25/SV_and_UVM_mini_project.git
   cd SV_and_UVM_mini_project
   ```

2. **Navigate to a specific project directory**
   ```bash
   cd Data_flipflop_verification_UVM
   ```

3. **Review the SystemVerilog/UVM source files**
   - Start with the top-level testbench file
   - Study the DUT (Design Under Test)
   - Examine verification components

4. **Run the simulation** using your preferred EDA tool
   - Compile all SystemVerilog files
   - Run the simulation
   - Generate coverage and waveform reports

5. **Analyze coverage reports and simulation results**
   - Check functional coverage metrics
   - Review waveforms for behavior validation
   - Verify all assertions pass

---

## 💡 Tips for Exploration

- **Start with Simpler Projects:** Begin with basic testbenches (Adders) to understand testbench structure
- **Progress to UVM:** Move to UVM projects after understanding basic testbench patterns
- **Study Key Components:** Focus on scoreboard and coverage implementations
- **Review Assertions:** Understand how assertions catch design bugs
- **Compare Approaches:** Study different verification strategies across projects
- **Experiment:** Modify test cases and observe behavior changes
- **Coverage Analysis:** Ensure coverage metrics are met for each project

---

## 📝 Code Quality Standards

- Follow SystemVerilog naming conventions
- Use meaningful variable and signal names
- Include comments for complex logic
- Implement comprehensive assertions
- Maintain consistent indentation and formatting
- Follow UVM best practices for hierarchical design

---

## 📄 License

MIT License - Feel free to use, modify, and distribute these projects for educational purposes.

---

## 👤 Author

**Gagandeep-25**

---

## 📌 Additional Notes

**Important Considerations:**
- These are educational mini projects designed to demonstrate verification concepts
- Best practices in digital hardware design are implemented throughout
- Projects are suitable for students and professionals learning verification
- Each project is self-contained and can be run independently
- Modification and experimentation are encouraged for better understanding

---

**Last Updated:** December 2025

**Note:** These are educational mini projects designed to demonstrate verification concepts and best practices in digital hardware design. They serve as excellent reference materials for learning SystemVerilog and UVM frameworks.
