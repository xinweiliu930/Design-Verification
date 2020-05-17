#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2015.09
# platform  : Linux 2.6.32-754.9.1.el6.x86_64
# version   : 2015.09 FCS 64 bits
# build date: 2015.09.29 22:07:32 PDT
#----------------------------------------
# started Tue Apr 09 22:43:59 CDT 2019
# hostname  : wario
# pid       : 17991
# arguments : '-label' 'session_0' '-console' 'wario:34395' '-style' 'windows' '-proj' '/home/ecelrc/students/xliu4/verif_labs/lab4/tutorial/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/ecelrc/students/xliu4/verif_labs/lab4/tutorial/jgproject/.tmp/.initCmds.tcl' 'jg_cmd_syncfifo.tcl'
clear -all
analyze -v2k sync_fifo.v
analyze -sv wrapper_sync_fifo.sv
elaborate -top sync_fifo
clock clock
reset reset
prove -bg -all
visualize -violation -property <embedded>::sync_fifo.fifo_verif_inst.ck_empty_correctness -new_window
