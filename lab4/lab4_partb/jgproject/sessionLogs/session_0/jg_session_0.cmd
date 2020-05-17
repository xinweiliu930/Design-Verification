#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2015.09
# platform  : Linux 2.6.32-754.9.1.el6.x86_64
# version   : 2015.09 FCS 64 bits
# build date: 2015.09.29 22:07:32 PDT
#----------------------------------------
# started Fri Apr 12 19:41:12 CDT 2019
# hostname  : wario
# pid       : 17604
# arguments : '-label' 'session_0' '-console' 'wario:43084' '-style' 'windows' '-proj' '/home/ecelrc/students/xliu4/verif_labs/lab4/lab4_partb/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/ecelrc/students/xliu4/verif_labs/lab4/lab4_partb/jgproject/.tmp/.initCmds.tcl' 'lab4_pb.tcl'
#Tcl script which can be used with JasperGold
#Use "source lab4_pb.tcl" in the console to source this script
clear -all
#Reading the files 

analyze -v2k decoder.v 
analyze -v2k rv32_opcodes.v 
analyze -v2k constants.v
analyze -v2k alu_ops.v
analyze -v2k pipeline.v
analyze -sv v_decoder.sv

#Elaborating the design
elaborate -bbox {1} -top pipeline 

#Set the clock
clock clk
#Set Reset
reset reset
#Prove all
prove -bg -all



