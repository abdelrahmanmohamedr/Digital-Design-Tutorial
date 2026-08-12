### UPF Isolation Strategies
### set_isolation Basic Form
set_isolation strategy_name -domain domain_name \
  -isolation_supply_set supply_set_name \
  -clamp_value {0|1} \
  [options]

### parameters
### strategy_name - Unique identifier for isolation strategy (required)
### -domain domain_name - Domain being isolated (required)
### -isolation_supply_set set_name - Supply set for isolation cells (required, must be always-on)
### -clamp_value {0|1} - Value to clamp when isolated (required)
### -isolation_signal signal_name - Control signal (required)
### -isolation_sense {high|low} - Signal polarity (active-high or active-low)
### -location {self|parent|fanout} - Where to place isolation cells
### -applies_to {from|to|both} - Signal direction (outputs, inputs, or both)

### Isolation Control Signals
### Active-High Isolation (isolation_sense high)
set_isolation ISO_GPU -domain PD_GPU \
  -isolation_supply_set SS_TOP \
  -clamp_value 0 \
  -isolation_signal iso_gpu_enable \
  -isolation_sense high
### iso_gpu_enable = 0: Isolation disabled (signals pass through)
### iso_gpu_enable = 1: Isolation active (outputs clamped to 0)

### Active-Low Isolation (isolation_sense low)
set_isolation ISO_CPU -domain PD_CPU \
  -isolation_supply_set SS_TOP \
  -clamp_value 0 \
  -isolation_signal iso_cpu_n \
  -isolation_sense low
### iso_cpu_n = 1: Isolation disabled (signals pass through)
### iso_cpu_n = 0: Isolation active (outputs clamped to 0)

### Usage Variations
### [1] Basic Isolation (Clamp to 0):
set_isolation ISO_GPU -domain PD_GPU \
  -isolation_supply_set SS_TOP \
  -clamp_value 0 \
  -isolation_signal iso_gpu_enable \
  -isolation_sense high

### [2] Isolation with Location:
set_isolation ISO_CPU -domain PD_CPU \
  -isolation_supply_set SS_TOP \
  -clamp_value 0 \
  -isolation_signal iso_cpu \
  -isolation_sense high \
  -location parent

### [3]  Isolation on Inputs (Rare):
set_isolation ISO_INPUT -domain PD_DSP \
  -isolation_supply_set SS_TOP \
  -clamp_value 1 \
  -isolation_signal iso_dsp \
  -isolation_sense high \
  -applies_to to

### Example 
# ===================================================================
# Power Gating with Retention AND Isolation
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

create_power_domain PD_CPU -elements {cpu_inst}

# Supplies
create_supply_net VDD_CPU -domain PD_CPU
create_supply_net VDD_CPU_RET -domain PD_CPU
create_supply_net VSS -domain PD_CPU

# Supply sets
create_supply_set SS_CPU_ACTIVE \
  -function {power VDD_CPU} \
  -function {ground VSS}

create_supply_set SS_CPU_RET \
  -function {power VDD_CPU_RET} \
  -function {ground VSS}

associate_supply_set SS_CPU_ACTIVE -handle PD_CPU

# Power states
add_power_state VDD_CPU -state {ACTIVE 1.0} -state {OFF off}
add_power_state VDD_CPU_RET -state {RETENTION 0.6}

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

# Isolation strategy
set_isolation ISO_CPU -domain PD_CPU \
  -isolation_supply_set SS_TOP \
  -clamp_value 0 \
  -isolation_signal cpu_iso_enable \
  -isolation_sense high \
  -location parent

# ===================================================================
# Power-Down Sequence (with retention):
# 1. Assert cpu_retention_enable (save state to VDD_CPU_RET)
# 2. Assert cpu_iso_enable (activate isolation)
# 3. De-assert cpu_power_enable (turn off VDD_CPU)
# 4. CPU off, state retained, outputs isolated
#
# Power-Up Sequence:
# 1. Assert cpu_power_enable (restore VDD_CPU)
# 2. De-assert cpu_retention_enable (switch FFs back to VDD_CPU)
# 3. De-assert cpu_iso_enable (disable isolation)
# 4. CPU operational with retained state
# ===================================================================