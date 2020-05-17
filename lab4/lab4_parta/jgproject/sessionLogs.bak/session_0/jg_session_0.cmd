#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2015.09
# platform  : Linux 2.6.32-754.9.1.el6.x86_64
# version   : 2015.09 FCS 64 bits
# build date: 2015.09.29 22:07:32 PDT
#----------------------------------------
# started Fri Apr 12 19:13:04 CDT 2019
# hostname  : wario
# pid       : 878
# arguments : '-label' 'session_0' '-console' 'wario:40926' '-style' 'windows' '-proj' '/home/ecelrc/students/xliu4/verif_labs/lab4/lab4_parta/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/ecelrc/students/xliu4/verif_labs/lab4/lab4_parta/jgproject/.tmp/.initCmds.tcl' 'lab4.tcl'
#Tcl script which can be used with JasperGold
#Use "source lab4.tcl" in the console to source this script
clear -all
#Reading the files (.v and .sv) 
analyze -v2k arbiter_top.v
analyze -v2k arbiter.v
analyze -v2k apb_slave.v
analyze -v2k PNSeqGen.v
analyze -v2k apb_parameters.v
analyze -sv bind_wrapper.sv
#Elaborating the design, specify the top module
elaborate -top arbiter_top
#You may  need to add commands below
#Set the clock
clock PCLK
#Set Reset
reset  -expression {!(PRESETn)}
#Prove all
prove -bg -all
