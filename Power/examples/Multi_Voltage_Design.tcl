### UPF Multi Voltage Design
### set_level_shifter Basic form
set_level_shifter strategy_name -domain domain_name \
  -applies_to {inputs|outputs|both} \
  [options]

### Parameters
### strategy_name - Unique identifier for the level shifter strategy (required)
### -domain domain_name - Domain where shifters are applied (required)
### -applies_to {inputs|outputs|both} - Which signals get shifters (required)
### -location {self|parent|fanout|automatic} - Where shifters are placed
### -threshold voltage - Voltage difference threshold for shifter insertion
### -rule {low_to_high|high_to_low|both} - Which voltage transitions need shifters

### Usage Variations
### [1] Basic Level Shifter (All Outputs):
set_level_shifter LS_CPU -domain PD_CPU \
  -applies_to outputs \
  -location self

### [2] Bidirectional Level Shifters:
set_level_shifter LS_IO -domain PD_IO \
  -applies_to both \
  -location automatic

### [3] Threshold-Based (Only Insert if ΔV >= threshold):
set_level_shifter LS_CONDITIONAL -domain PD_GPU \
  -applies_to outputs \
  -threshold 0.2 \    # Only if voltage difference >= 0.2V
  -location self


### Mapping Level Shifters to Library Cells
# Map CPU output level shifters to library cell
map_level_shifter_cell LS_CPU_OUT -domain PD_CPU \
  -lib_cells {LS_LH_1V0_1V2}    # Low-to-High: 1.0V → 1.2V

# Map CPU input level shifters to library cell
map_level_shifter_cell LS_CPU_IN -domain PD_CPU \
  -lib_cells {LS_HL_1V2_1V0}    # High-to-Low: 1.2V → 1.0V

### Example
# ===================================================================
# Complete Multi-Voltage Design with Level Shifters
# ===================================================================

# TOP DOMAIN: 1.2V (always-on control)
create_power_domain PD_TOP -include_scope
create_supply_net VDD_1V2 -domain PD_TOP
create_supply_net VSS -domain PD_TOP

create_supply_set SS_1V2 \
  -function {power VDD_1V2} \
  -function {ground VSS}
associate_supply_set SS_1V2 -handle PD_TOP

add_power_state VDD_1V2 -state {ON 1.2}

# CPU DOMAIN: 1.0V (power-optimized)
create_power_domain PD_CPU -elements {cpu_inst}
create_supply_net VDD_1V0 -domain PD_CPU
create_supply_net VSS -domain PD_CPU

create_supply_set SS_1V0 \
  -function {power VDD_1V0} \
  -function {ground VSS}
associate_supply_set SS_1V0 -handle PD_CPU

add_power_state VDD_1V0 -state {ACTIVE 1.0}

# GPU DOMAIN: 0.9V (maximum power savings)
create_power_domain PD_GPU -elements {gpu_inst}
create_supply_net VDD_0V9 -domain PD_GPU
create_supply_net VSS -domain PD_GPU

create_supply_set SS_0V9 \
  -function {power VDD_0V9} \
  -function {ground VSS}
associate_supply_set SS_0V9 -handle PD_GPU

add_power_state VDD_0V9 -state {ACTIVE 0.9}

# I/O DOMAIN: 1.8V (external interface)
create_power_domain PD_IO -elements {io_pads}
create_supply_net VDD_1V8 -domain PD_IO
create_supply_net VSS -domain PD_IO

create_supply_set SS_1V8 \
  -function {power VDD_1V8} \
  -function {ground VSS}
associate_supply_set SS_1V8 -handle PD_IO

add_power_state VDD_1V8 -state {ON 1.8}

# ===================================================================
# LEVEL SHIFTER STRATEGIES
# ===================================================================

# CPU ↔ TOP (1.0V ↔ 1.2V)
set_level_shifter LS_CPU_OUT -domain PD_CPU \
  -applies_to outputs \
  -location self

set_level_shifter LS_CPU_IN -domain PD_CPU \
  -applies_to inputs \
  -location parent

# GPU ↔ TOP (0.9V ↔ 1.2V)
set_level_shifter LS_GPU_OUT -domain PD_GPU \
  -applies_to outputs \
  -location self

set_level_shifter LS_GPU_IN -domain PD_GPU \
  -applies_to inputs \
  -location parent

# I/O ↔ TOP (1.8V ↔ 1.2V)
set_level_shifter LS_IO_OUT -domain PD_IO \
  -applies_to outputs \
  -location self

set_level_shifter LS_IO_IN -domain PD_IO \
  -applies_to inputs \
  -location parent

# ===================================================================
# MAP TO LIBRARY CELLS (technology-specific)
# ===================================================================

# CPU level shifters
map_level_shifter_cell LS_CPU_OUT -domain PD_CPU \
  -lib_cells {LS_LH_1V0_1V2_X1 LS_LH_1V0_1V2_X2}

map_level_shifter_cell LS_CPU_IN -domain PD_CPU \
  -lib_cells {LS_HL_1V2_1V0_X1 LS_HL_1V2_1V0_X2}

# GPU level shifters
map_level_shifter_cell LS_GPU_OUT -domain PD_GPU \
  -lib_cells {LS_LH_0V9_1V2_X1 LS_LH_0V9_1V2_X2}

map_level_shifter_cell LS_GPU_IN -domain PD_GPU \
  -lib_cells {LS_HL_1V2_0V9_X1 LS_HL_1V2_0V9_X2}

# I/O level shifters
map_level_shifter_cell LS_IO_OUT -domain PD_IO \
  -lib_cells {LS_HL_1V8_1V2_X1 LS_HL_1V8_1V2_X2}

map_level_shifter_cell LS_IO_IN -domain PD_IO \
  -lib_cells {LS_LH_1V2_1V8_X1 LS_LH_1V2_1V8_X2}

# ===================================================================
# Power Savings Analysis:
# - CPU at 1.0V vs 1.2V: 31% power reduction (dynamic)
# - GPU at 0.9V vs 1.2V: 44% power reduction (dynamic)
# - Overall chip power reduction: ~30-40% (depends on mix)
# ===================================================================