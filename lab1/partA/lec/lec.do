// The dofile must be in 'tclmode'
tclmode

// Load the library
read_library -Both -Replace  -sensitive  -Statetable  -Liberty /home/ecelrc/students/xliu4/verif_labs/lab1/partA/lib/gscl45nm.lib -nooptimize   
// Load the golden design: RTL
read_design /home/ecelrc/students/xliu4/verif_labs/lab1/partA/rtl/a25_write_back.v -Verilog -Golden   -sensitive         -continuousassignment Bidirectional   -nokeep_unreach   -nosupply 
// Load the revised design: Netlist
read_design /home/ecelrc/students/xliu4/verif_labs/lab1/partA/gate/a25_write_back_netlist.v -Verilog -Revised   -sensitive         -continuousassignment Bidirectional   -nokeep_unreach   -nosupply
// Change the mode to LEC
set_system_mode lec
// Add compare points and compare
add_compared_points -all
compare

