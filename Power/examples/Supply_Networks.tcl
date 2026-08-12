### Creating Supply Ports and Nets

### Creating Supply Ports and Nets
### [1] Top-Level Supply Ports
### These act as the main power pins coming from the outside world into your top domain.
create_supply_port VDD -direction in -domain PD_TOP
create_supply_port VSS -direction in -domain PD_TOP

### [2] Internal Supply Nets
### These are the internal power rails that distribute power within PD_TOP.
create_supply_net VDD_net -domain PD_TOP
create_supply_net VSS_net -domain PD_TOP

### [3] Sub-Domain Supply Nets
### If you have a switchable CPU core, it needs its own internal gated net.
create_supply_net VDD_CPU_net -domain PD_CPU

### [4] Multi-Voltage Supply Network Example
### Primary domain: 1.2V
create_power_domain PD_TOP -include_scope
create_supply_net VDD_TOP -domain PD_TOP      # 1.2V
create_supply_net VSS -domain PD_TOP          # 0V (ground)

### CPU domain: 1.0V
create_power_domain PD_CPU -elements {cpu_inst}
create_supply_net VDD_CPU -domain PD_CPU      # 1.0V
create_supply_net VSS -domain PD_CPU          # 0V (shared ground)

### I/O domain: 1.8V
create_power_domain PD_IO -elements {io_subsystem}
create_supply_net VDDIO -domain PD_IO         # 1.8V
create_supply_net VSS -domain PD_IO           # 0V (shared ground)

### Common naming patterns for supply nets:
### VDD / VSS: Primary power and ground
### VDD_domain / VSS_domain: Domain-specific supplies (VDD_CPU, VSS_CPU)
### VDDIO: I/O supply voltage
### VDD_RET: Retention supply (stays on during power-down)
### VDD_SW: Switched supply (output of power switch)
### VDDN / VDDP: N-well and P-well supplies (advanced designs)

### Connecting the Network

### [1] Connecting top-level ports to top-level nets
### This routes the external VDD port directly to the internal VDD_net.
connect_supply_net VDD_net -ports {VDD}
connect_supply_net VSS_net -ports {VSS}

### [2] Hard Macro Connections
### If we have a hard macro with power ports already in the RTL code we dont need to make port for them
### We connect their ports to the top level nets 
### This creates the physical connection across the domain boundary.
connect_supply_net VDD_net -ports {cpu_inst/VDD_in}

### Assigning Primary Supplies to Domains

### [1] Setting the default supply for the top level
set_domain_supply_net PD_TOP \
    -primary_power_net VDD_net \
    -primary_ground_net VSS_net

### [2] Setting the gated supply for a sub-domain
### Note: PD_CPU uses the gated net (VDD_CPU_net) for power, 
### but shares the common ground (VSS_net) with the top level.
set_domain_supply_net PD_CPU \
    -primary_power_net VDD_CPU_net \
    -primary_ground_net VSS_net