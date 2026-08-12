#######################################################################################
### create_power_domain
### create_power_domain command is the primary UPF command for defining power domains
#######################################################################################

### basic form
create_power_domain domain_name [options]

### Common Parameters
### domain_name - Unique identifier for the power domain (required)
### -elements {list} - Design instances belonging to this domain
### -include_scope - Include all hierarchy under current scope
### -scope instance_name - Set scope to specific instance before creating domain
### -supply {supply_set} - Associate supply set with domain

### examples

### [1]
### Just creates an empty power domain named PD_CPU — no elements or supplies attached yet. Not very useful alone, but valid.
create_power_domain PD_CPU 

### [2]
### This ties the domain to specific hierarchical instances. 
### Any cell inside u_core, u_core/u_alu, and u_core/u_regfile is now logically part of PD_CORE for power intent purposes (isolation, retention, shutoff rules will apply to these).
create_power_domain PD_CORE \
    -elements {u_core u_core/u_alu u_core/u_regfile}

### [3]
### Instead of listing elements manually, -include_scope tells the tool "everything under the current hierarchical scope (subsystem_inst here) belongs to this domain".
### Useful when a whole sub-block maps cleanly to one power domain.
set_scope subsystem_inst
create_power_domain PD_SUB -include_scope
set_scope .

### [4]
### This is a shorthand that moves the current scope to subsystem_inst and creates the domain rooted there.
create_power_domain PD_SUB -scope subsystem_inst -include_scope

### Primary Power Domain
### Create primary power domain at top level
create_power_domain PD_TOP -include_scope

### to create additional domains after the Primary Power Domain
### CPU block operates at different voltage, can be power-gated
create_power_domain PD_CPU -elements {cpu_subsystem}

### GPU block can be shut off independently
create_power_domain PD_GPU -elements {gpu_subsystem}

### This removes cpu_subsystem and gpu_subsystem from PD_TOP and places them in their own domains.

### Group multiple instances into one domain if they share power characteristics:# All peripheral blocks share 1.8V supply, can be gated together
create_power_domain PD_PERIPH -elements {
  uart_inst
  spi_inst
  i2c_inst
  gpio_inst
}

### Use wildcards to include multiple instances matching a pattern:
### All CPU cores (cpu_core_0, cpu_core_1, cpu_core_2, cpu_core_3)
create_power_domain PD_CORES -elements {cpu_core_*}

### All memory banks
create_power_domain PD_MEM -elements {mem_bank[*]}

### Scope Management
### Method 1: Use set_scope to navigate
set_scope top/subsystem_a
create_power_domain PD_SUBA -include_scope
set_scope ..

### Method 2: Use -scope option
create_power_domain PD_SUBB -scope top/subsystem_b -include_scope

### Method 3: Fully qualified element paths
create_power_domain PD_SUBC -elements {top/subsystem_c}

### Element Membership Rules
### Rule 1: Exclusive Membership
### CORRECT: cpu_inst is in PD_CPU
create_power_domain PD_CPU -elements {cpu_inst}

### ERROR: Can't assign cpu_inst to two domains
create_power_domain PD_ANOTHER -elements {cpu_inst}  # Will fail or override

### Rule 2: Hierarchical Override
### PD_TOP includes everything
create_power_domain PD_TOP -include_scope

### PD_CPU removes cpu_subsystem from PD_TOP
create_power_domain PD_CPU -elements {cpu_subsystem}

### Within cpu_subsystem, PD_CORE0 removes core_0 from PD_CPU
set_scope cpu_subsystem
create_power_domain PD_CORE0 -elements {core_0}
set_scope .

### Result:
### - core_0 is in PD_CORE0 (most specific)
### - Other parts of cpu_subsystem are in PD_CPU
### - Everything else is in PD_TOP

### Rule 3: Include Scope vs Elements
### Creates PD_CPU covering cpu_subsystem and all its sub-instances
### (domain membership propagates down the hierarchy unless a sub-instance
### is later carved out into its own create_power_domain)
create_power_domain PD_CPU -elements {cpu_subsystem}

### Creates PD_FLAT covering the entire current scope 
### equivalent to -elements {.}. Still propagates down
### through all sub-instances of that scope
create_power_domain PD_FLAT -include_scope