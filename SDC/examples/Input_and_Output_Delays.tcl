### Input Delays
### Syntax
set_input_delay -clock <clock_name> [-max|-min] <delay> [get_ports <port_pattern>]

### Examples 
# External device launches data with 3ns delay
set_input_delay -clock sys_clk -max 3.0 [get_ports data_in]

# Minimum delay (for hold check)
set_input_delay -clock sys_clk -min 1.0 [get_ports data_in]

### Applying to Multiple Ports
# All input data ports
set_input_delay -clock sys_clk -max 2.5 [get_ports data_in*]

# Specific list of ports
set_input_delay -clock sys_clk -max 2.0 [get_ports {addr[0] addr[1] addr[2]}]

# All inputs except clock
set_input_delay -clock sys_clk -max 2.0 [all_inputs]

### Different Delays for Rising and Falling
# Rising edge
set_input_delay -clock sys_clk -clock_fall -max 2.0 [get_ports data]

# Falling edge
set_input_delay -clock sys_clk -clock_fall -max 2.5 [get_ports data]

### Output Delays
### Syntax
set_output_delay -clock <clock_name> [-max|-min] <delay> [get_ports <port_pattern>]

### Examples 
# External device needs data 1.5ns before its clock edge
set_output_delay -clock sys_clk -max 1.5 [get_ports data_out]

# Minimum output delay (for hold)
set_output_delay -clock sys_clk -min 0.3 [get_ports data_out]

### Add vs. Set: Cumulative Delays
### Set (Default): Replaces previous value
set_input_delay -clock clk -max 2.0 [get_ports data]
set_input_delay -clock clk -max 3.0 [get_ports data]  # Overrides to 3.0

### Add: Accumulates
set_input_delay -clock clk -max 2.0 [get_ports data]
set_input_delay -clock clk -max -add 1.0 [get_ports data]  # Total = 3.0

