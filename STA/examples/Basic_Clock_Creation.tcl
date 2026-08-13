### Basic Clock Creation

### Syntax
create_clock -name <clock_name> -period <period> [get_ports <port_name>]

### Examples 
### Default Waveform
# 100 MHz clock (10ns period)
create_clock -name sys_clk -period 10.0 [get_ports clk]

### Custom Waveform (Non-50% Duty Cycle)
# 40% duty cycle: high for 4ns, low for 6ns
create_clock -name clk_40 -period 10.0 -waveform {0 4} [get_ports clk]

# 30% duty cycle: high for 3ns, low for 7ns
create_clock -name clk_30 -period 10.0 -waveform {0 3} [get_ports clk]

### Inverted Clock (Starts Low)
# Starts low, rises at 5ns, falls at 10ns (one period later)
create_clock -name clk_inv -period 10.0 -waveform {5 10} [get_ports clk_n]

### Multiple Independent Clocks

### Asynchronous Clocks
# Fast clock for processor
create_clock -name cpu_clk -period 2.0 [get_ports clk_cpu]

# Slow clock for peripherals
create_clock -name peri_clk -period 50.0 [get_ports clk_peri]

# Declare them asynchronous (no timing relationship)
set_clock_groups -asynchronous \
    -group {cpu_clk} \
    -group {peri_clk}

### Generated Clocks
### Clock Divider
# Primary clock
create_clock -name main_clk -period 10.0 [get_ports clk]

# Divided-by-2 clock
create_generated_clock -name div2_clk \
    -source [get_ports clk] \
    -divide_by 2 \
    [get_pins divider/Q]

### Clock Multiplier (PLL)
# Input reference clock
create_clock -name ref_clk -period 20.0 [get_ports ref_clk]

# PLL output (multiply by 4)
create_generated_clock -name pll_clk \
    -source [get_ports ref_clk] \
    -multiply_by 4 \
    [get_pins pll/clk_out]

### Clock Properties
### Clock Uncertainty
# Jitter and skew
set_clock_uncertainty -setup 0.2 [get_clocks sys_clk]
set_clock_uncertainty -hold 0.1 [get_clocks sys_clk]

### Clock Latency
# Source latency (before clock tree)
set_clock_latency -source 0.5 [get_clocks sys_clk]

# Network latency (clock tree delay)
set_clock_latency 1.0 [get_clocks sys_clk]

### Clock Transition
# Clock edge slew rate
set_clock_transition 0.1 [get_clocks sys_clk]

### Virtual Clocks
# Virtual clock for external system
create_clock -name ext_sys_clk -period 8.0

# Input timing relative to virtual clock
set_input_delay -clock ext_sys_clk -max 2.0 [get_ports data_in]

# Output timing relative to virtual clock
set_output_delay -clock ext_sys_clk -max 1.5 [get_ports data_out]