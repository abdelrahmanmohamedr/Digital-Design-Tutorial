### UPF Power States
### add_power_state Basic Form
add_power_state supply_net_name -state {state_name voltage_or_status} [options]

### Parameters
### supply_net_name - The supply net being characterized (required)
### -state {name value} - Define one power state (repeatable for multiple states)
### name - Descriptive state identifier (e.g., ON, OFF, HIGH, LOW)
### value - Voltage level (numeric) or keyword (on, off)

### Examples
### [1] Always-On Supply (Single State):
add_power_state VDD_TOP -state {ON 1.2}

### [2] Switchable Supply (On/Off):
add_power_state VDD_CPU \
  -state {ACTIVE 1.0} \
  -state {OFF off}

### [3] Multi-Voltage Supply (DVFS):
add_power_state VDD_GPU \
  -state {HIGH_PERF 1.1} \
  -state {NORMAL 0.9} \
  -state {LOW_POWER 0.7} \
  -state {OFF off}

### [4] Retention Supply (Always-On at Low Voltage):
add_power_state VDD_RET -state {RETENTION 0.6}

### Example
# TOP DOMAIN: Always-on at 1.2V
add_power_state VDD_TOP -state {ON 1.2}
add_power_state VSS -state {ON 0.0}

# CPU DOMAIN: Switchable with retention
add_power_state VDD_CPU \
  -state {ACTIVE 1.0} \
  -state {OFF off}

add_power_state VDD_CPU_RET \
  -state {RETENTION 0.6}

# GPU DOMAIN: Multi-voltage (DVFS) with power gating
add_power_state VDD_GPU \
  -state {HIGH_PERF 1.1} \
  -state {NORMAL 0.9} \
  -state {LOW_POWER 0.7} \
  -state {OFF off}

# I/O DOMAIN: Always-on at 1.8V (I/O voltage)
add_power_state VDDIO -state {ON 1.8}

# ===================================================================
# System Power Modes (example combinations):
#
# FULL_ACTIVE:
#   VDD_TOP=ON, VDD_CPU=ACTIVE, VDD_GPU=HIGH_PERF, VDDIO=ON
#
# BALANCED:
#   VDD_TOP=ON, VDD_CPU=ACTIVE, VDD_GPU=NORMAL, VDDIO=ON
#
# ECO_MODE:
#   VDD_TOP=ON, VDD_CPU=ACTIVE, VDD_GPU=LOW_POWER, VDDIO=ON
#
# DISPLAY_OFF:
#   VDD_TOP=ON, VDD_CPU=ACTIVE, VDD_GPU=OFF, VDDIO=ON
#
# DEEP_SLEEP:
#   VDD_TOP=ON, VDD_CPU=OFF, VDD_GPU=OFF, VDDIO=ON
#   (VDD_CPU_RET=RETENTION preserves CPU state)
# ===================================================================

### State Dependencies
###  Hierarchical Dependencies
# LEGAL: Parent ON, child ACTIVE
VDD_TOP = ON (1.2V)
VDD_CPU = ACTIVE (1.0V)

# ILLEGAL: Parent OFF, child ACTIVE
VDD_TOP = OFF
VDD_CPU = ACTIVE (1.0V)  # Can't be active if parent is off

### Functional Dependencies
# LEGAL: Both active or both off
VDD_CPU = ACTIVE, VDD_GPU = ACTIVE
VDD_CPU = OFF, VDD_GPU = OFF

# ILLEGAL: GPU active without CPU (design-specific constraint)
VDD_CPU = OFF, VDD_GPU = ACTIVE