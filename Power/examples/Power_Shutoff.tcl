### UPF Power Shutoff
### create_power_switch Basic Form
create_power_switch switch_name -domain domain_name \
  -input_supply_port {port_name supply_net} \
  -output_supply_port {port_name supply_net} \
  -control_port {port_name signal} \
  -on_state {state_name input_port {control_expr}} \
  [options]

### Parameters
### switch_name - Unique identifier for the power switch (required)
### -domain domain_name - Power domain controlled by this switch (required)
### -input_supply_port {name net} - Input connection (always-on supply) (required)
### -output_supply_port {name net} - Output connection (switched supply to domain) (required)
### -control_port {name signal} - Control signal(s) (required, repeatable)
### -on_state {name input {expr}} - Define when switch is ON (required, repeatable)
### -off_state {name {expr}} - Define when switch is OFF (optional)

### Usage Variations
### [1] Basic Power Switch (Single Control):
create_power_switch PSW_GPU -domain PD_GPU \
  -input_supply_port {in VDD} \
  -output_supply_port {out VDD_GPU} \
  -control_port {ctrl pwr_en_gpu} \
  -on_state {on in {ctrl}}
### The port names are local to the switch definition and don't need to match RTL signal names

### [2] asic Power Switch (Single Control):
create_power_switch PSW_CPU -domain PD_CPU \
  -input_supply_port {in VDD} \
  -output_supply_port {out VDD_CPU} \
  -control_port {ctrl pwr_en_cpu} \
  -on_state {on in {ctrl}} \
  -off_state {off {!ctrl}}

### [3] Multiple Control Signals (AND logic):
create_power_switch PSW_DSP -domain PD_DSP \
  -input_supply_port {in VDD} \
  -output_supply_port {out VDD_DSP} \
  -control_port {en pwr_enable} \
  -control_port {ack pwr_ack} \
  -on_state {on in {en && ack}}

### Example
# ===================================================================
# Power-Gated GPU Domain
# ===================================================================

# Create always-on top domain
create_power_domain PD_TOP -include_scope

# Create GPU domain (will be power-gated)
create_power_domain PD_GPU -elements {gpu_inst}

# Supply nets
create_supply_net VDD -domain PD_TOP          # Always-on supply
create_supply_net VSS -domain PD_TOP

create_supply_net VDD_GPU -domain PD_GPU      # Switched supply
create_supply_net VSS -domain PD_GPU

# Supply sets
create_supply_set SS_TOP \
  -function {power VDD} \
  -function {ground VSS}

create_supply_set SS_GPU \
  -function {power VDD_GPU} \
  -function {ground VSS}

associate_supply_set SS_TOP -handle PD_TOP
associate_supply_set SS_GPU -handle PD_GPU

# Power states
add_power_state VDD -state {ON 1.2}
add_power_state VDD_GPU \
  -state {ACTIVE 1.0} \
  -state {OFF off}

# Power switch: Controls VDD → VDD_GPU
create_power_switch PSW_GPU -domain PD_GPU \
  -input_supply_port {vin VDD} \
  -output_supply_port {vout VDD_GPU} \
  -control_port {ctrl gpu_power_enable} \
  -on_state {on vin {ctrl}}

# ===================================================================
# Result:
# - When gpu_power_enable = 1: Switch ON, VDD → VDD_GPU (GPU powered)
# - When gpu_power_enable = 0: Switch OFF, VDD_GPU disconnected (GPU off)
# ===================================================================


### Header vs Footer Switches
### Header Switch (High-Side)
create_power_switch PSW_HEADER -domain PD_CPU \
  -input_supply_port {in VDD} \
  -output_supply_port {out VDD_CPU} \
  -control_port {ctrl enable} \
  -on_state {on in {ctrl}}

### Footer Switch (Low-Side)
create_power_switch PSW_FOOTER -domain PD_GPU \
  -input_supply_port {in VSS} \
  -output_supply_port {out VSS_GPU} \
  -control_port {ctrl enable} \
  -on_state {on in {ctrl}}