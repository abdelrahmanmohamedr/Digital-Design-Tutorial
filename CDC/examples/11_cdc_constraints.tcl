#############################################################################
## CDC timing constraints (PrimeTime style) - see "Timing Constraints".
#############################################################################

## 1) NEVER blanket false-path the CDC paths - the tool relaxes them and
##    the MUX / gray structures break (enable overtakes data, bits drift):
# set_false_path -from [get_clocks clk1] -to [get_clocks clk2]   ;# WRONG

## 2) Best practice: max_delay on ALL paths between the two domains.
##    Use the smaller (worst-case) of the two periods as the value:
set_max_delay 4.0 -from [get_clocks clk1] -to [get_clocks clk2]
set_max_delay 4.0 -from [get_clocks clk2] -to [get_clocks clk1]
## Tool note: some tools need the setup check false-pathed FIRST so that
## max_delay governs - check your user guide.

## 3) MUX-synchronizer data path: data must be stable BEFORE the enable
##    arrives at the mux. A max_delay small enough enforces exactly that.

## 4) Gray-coded pointer buses: keep the bits arriving together.
##    Modern alternative to per-group skew constraints:
set_max_skew -exclude_pin [get_ports clk] 0.500 [get_nets {gray_ptr[*]}]
## (or hand-written per-group skew constraints - painful for many groups)

## 5) Declare the clocks asynchronous so normal setup/hold is skipped:
set_clock_groups -asynchronous -group {clk1} -group {clk2}
## NOTE: this already cuts CDC timing in most tools. It works together
## with (2) because explicit max_delay constraints override the cut in
## PrimeTime - VERIFY this in your own tool before trusting it.
