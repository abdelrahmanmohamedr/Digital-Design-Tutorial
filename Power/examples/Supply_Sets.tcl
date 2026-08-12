### UPF Supply Sets
### Basic Form
create_supply_set set_name -function {role net_name} [additional_functions]

### Parameters
### set_name - Unique identifier for the supply set (required)
### -function {role net_name} - Assign a supply net to a functional role (required, repeatable)

### Examples
### [1] Basic Supply Set (Power + Ground):
create_supply_set SS_TOP \
  -function {power VDD_TOP} \
  -function {ground VSS}

### [2] Supply Set with Well Biasing:
create_supply_set SS_CPU \
  -function {power VDD_CPU} \
  -function {ground VSS} \
  -function {nwell VDD_CPU} \
  -function {pwell VSS}

### [3] Retention Supply Set:
create_supply_set SS_RET \
  -function {power VDD_RET} \
  -function {ground VSS}

### associate_supply_set
### Basic Form
associate_supply_set set_name -handle domain_name

### Parameters
### set_name - Name of the supply set to associate
### -handle domain_name - Power domain receiving this supply set

### Example
# Create supply set
create_supply_set SS_CPU \
  -function {power VDD_CPU} \
  -function {ground VSS}

# Associate with domain
associate_supply_set SS_CPU -handle PD_CPU


### Multi-Domain Supply Sets
# ===================================================================
# Multi-Domain Supply Sets Example
# ===================================================================

# Top-level domain (1.2V, always-on)
create_power_domain PD_TOP -include_scope
create_supply_net VDD_TOP -domain PD_TOP
create_supply_net VSS -domain PD_TOP

create_supply_set SS_TOP \
  -function {power VDD_TOP} \
  -function {ground VSS}

associate_supply_set SS_TOP -handle PD_TOP

# CPU domain (1.0V, switchable)
create_power_domain PD_CPU -elements {cpu_inst}
create_supply_net VDD_CPU -domain PD_CPU
create_supply_net VSS -domain PD_CPU

create_supply_set SS_CPU \
  -function {power VDD_CPU} \
  -function {ground VSS}

associate_supply_set SS_CPU -handle PD_CPU

# GPU domain (0.9V, switchable)
create_power_domain PD_GPU -elements {gpu_inst}
create_supply_net VDD_GPU -domain PD_GPU
create_supply_net VSS -domain PD_GPU

create_supply_set SS_GPU \
  -function {power VDD_GPU} \
  -function {ground VSS}

associate_supply_set SS_GPU -handle PD_GPU

# ===================================================================
# Result: Each domain has its own supply set
#   - PD_TOP uses SS_TOP (1.2V)
#   - PD_CPU uses SS_CPU (1.0V)
#   - PD_GPU uses SS_GPU (0.9V)
# ===================================================================


### Active vs Retention Example
# ===================================================================
# Power-Gated Domain with Retention
# ===================================================================

create_power_domain PD_GPU -elements {gpu_inst}

# Supply nets
create_supply_net VDD_GPU -domain PD_GPU      # Main power (switchable)
create_supply_net VDD_RET -domain PD_GPU      # Retention power (always-on)
create_supply_net VSS -domain PD_GPU

# Active supply set: Used during normal operation
create_supply_set SS_GPU_ACTIVE \
  -function {power VDD_GPU} \
  -function {ground VSS}

# Retention supply set: Used during power-down to preserve state
create_supply_set SS_GPU_RET \
  -function {power VDD_RET} \
  -function {ground VSS}

# Primary association: Active mode
associate_supply_set SS_GPU_ACTIVE -handle PD_GPU

# ===================================================================
# Note: Retention strategy (later module) will specify using
# SS_GPU_RET for retention cells during power-down
# ===================================================================