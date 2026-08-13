### Max and Min Delay Constraints
### set_max_delay 
set_max_delay <delay> -from <from_list> -to <to_list>

### Use Cases:
### [1] Asynchronous Paths
# Async reset distribution: must arrive within 5ns
set_max_delay 5.0 -from [get_ports async_rst] -to [all_registers]

### [2] Combinational Paths (No Clocks)
# Pure combinational logic from input to output
set_max_delay 3.0 -from [get_ports combo_in] -to [get_ports combo_out]

### set_min_delay 
set_min_delay <delay> -from <from_list> -to <to_list>

### Use Cases:
### [1] Hold Margin on Critical Paths
# Ensure at least 0.5ns delay (prevent hold violations)
set_min_delay 0.5 -from [get_ports fast_input] -to [get_registers]

### Combining Max and Min Delays
# Constrain path to be between 1ns and 5ns
set_min_delay 1.0 -from [get_ports in] -to [get_ports out]
set_max_delay 5.0 -from [get_ports in] -to [get_ports out]

### Both constraints must be satisfied.

