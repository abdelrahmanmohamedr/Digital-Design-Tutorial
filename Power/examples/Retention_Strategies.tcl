### Retention_Strategies
### set_retention Basic form
set_retention strategy_name -domain domain_name \
  -retention_supply_set supply_set_name \
  [options]

### parameters
### strategy_name - Unique identifier for retention strategy (required)
### -domain domain_name - Domain where retention is applied (required)
### -retention_supply_set set_name - Supply set for retention power (required)
### -retention_condition {expr} - Boolean expression controlling retention
### -save_signal {signal sense} - Signal to save state
### -restore_signal {signal sense} - Signal to restore state
### -elements {instance_list} - Specific instances to retain (optional, default = all FFs)

### Retention Control Signals
### Using -retention_condition
set_retention RET_GPU -domain PD_GPU \
  -retention_supply_set SS_GPU_RET \
  -retention_condition {gpu_retention_enable}

### Using -save_signal and -restore_signal
set_retention RET_CPU -domain PD_CPU \
  -retention_supply_set SS_CPU_RET \
  -save_signal {cpu_save high} \
  -restore_signal {cpu_restore high}

### Usage Variations
### [1] Basic Retention (All FFs in Domain):
set_retention RET_CPU -domain PD_CPU \
  -retention_supply_set SS_CPU_RET \
  -retention_condition {cpu_retention_enable}

### [2] Retention with Explicit Save/Restore:
set_retention RET_GPU -domain PD_GPU \
  -retention_supply_set SS_GPU_RET \
  -save_signal {gpu_save_state high} \
  -restore_signal {gpu_restore_state high}

### [3] Selective Retention (Specific Instances):
set_retention RET_CRITICAL -domain PD_CPU \
  -retention_supply_set SS_CPU_RET \
  -retention_condition {retention_en} \
  -elements {cpu_inst/control_regs cpu_inst/status_regs}

### map_retention_cell
# Map retention strategy to library retention flip-flops
map_retention_cell RET_CPU -domain PD_CPU \
  -lib_cells {
    DFFR_X1     # Standard drive strength
    DFFR_X2     # 2× drive strength
    DFFR_X4     # 4× drive strength
  }

### Example
# ===================================================================
# Complete Retention Implementation for CPU Domain
# ===================================================================

# TOP DOMAIN: Always-on
create_power_domain PD_TOP -include_scope
create_supply_net VDD_TOP -domain PD_TOP
create_supply_net VSS -domain PD_TOP

create_supply_set SS_TOP \
  -function {power VDD_TOP} \
  -function {ground VSS}
associate_supply_set SS_TOP -handle PD_TOP

add_power_state VDD_TOP -state {ON 1.2}

# CPU DOMAIN: Power-gated with retention
create_power_domain PD_CPU -elements {cpu_subsystem}

# Supply nets: Primary (switchable) + Retention (always-on)
create_supply_net VDD_CPU -domain PD_CPU
create_supply_net VDD_CPU_RET -domain PD_CPU
create_supply_net VSS -domain PD_CPU

# Active mode supply set
create_supply_set SS_CPU_ACTIVE \
  -function {power VDD_CPU} \
  -function {ground VSS}

# Retention mode supply set
create_supply_set SS_CPU_RET \
  -function {power VDD_CPU_RET} \
  -function {ground VSS}

associate_supply_set SS_CPU_ACTIVE -handle PD_CPU

# Power states
add_power_state VDD_CPU \
  -state {ACTIVE 1.0} \
  -state {OFF off}

add_power_state VDD_CPU_RET \
  -state {RETENTION 0.6}

# Power switch
create_power_switch PSW_CPU -domain PD_CPU \
  -input_supply_port {vin VDD_TOP} \
  -output_supply_port {vout VDD_CPU} \
  -control_port {ctrl cpu_power_enable} \
  -on_state {on vin {ctrl}}

# Retention strategy
set_retention RET_CPU -domain PD_CPU \
  -retention_supply_set SS_CPU_RET \
  -retention_condition {cpu_retention_enable}

# ===================================================================
# Power-Down Sequence:
# 1. Software prepares for sleep
# 2. Assert cpu_retention_enable (FFs switch to VDD_CPU_RET)
# 3. De-assert cpu_power_enable (VDD_CPU turns off)
# 4. CPU domain off, state preserved in retention cells
#
# Power-Up Sequence:
# 1. Assert cpu_power_enable (VDD_CPU restores to 1.0V)
# 2. Wait for VDD_CPU stable
# 3. De-assert cpu_retention_enable (FFs switch back to VDD_CPU)
# 4. Release reset, CPU resumes with preserved state
# ===================================================================