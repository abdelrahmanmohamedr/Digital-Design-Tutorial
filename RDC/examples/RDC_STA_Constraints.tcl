#############################################################################
## RDC-related STA constraints (PrimeTime style)
## Companion file for the RDC deck - see the "STA & RDC" section.
#############################################################################

## 1) Async reset ASSERTION is asynchronous by design -> do not time it.
##    (Only when the reset reaches the flops directly from a port.)
set_false_path -from [get_ports arst_n]

## 2) Reset RELEASE *is* timed: recovery/removal window checks run on
##    every async reset pin of the synchronized reset trees.
report_constraint -all_violators -recovery -removal

## 3) Same-clock soft-reset crossings (RDC "CAUTION" paths):
##    the path TxRstReg/Q -> Tx reset pin -> Tx/Q -> Rx/D must be timed
##    as a NORMAL setup path.
##    NEVER false-path these - that would hide the soft-reset check:
# set_false_path -from [get_pins u_soft_rst_reg/Q]   ;# WRONG - do not do

## 4) Protect the reset network from synthesis optimization
set_dont_touch_network [get_ports arst_n]
## pre-CTS alternative while the reset tree is still ideal:
# set_ideal_network [get_nets rst_n]

## 5) Reset-tree loads are as numerous as clock loads - constrain
##    transition and fanout on reset nets like a clock net:
set_max_transition 0.800 [get_nets rst_n]
set_max_fanout 32 [get_ports arst_n]
