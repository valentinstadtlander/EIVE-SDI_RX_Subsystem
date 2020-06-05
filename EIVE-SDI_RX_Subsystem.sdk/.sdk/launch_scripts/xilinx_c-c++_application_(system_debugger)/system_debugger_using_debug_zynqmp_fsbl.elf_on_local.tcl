connect -url tcp:127.0.0.1:3121
source C:/Xilinx/SDK/2017.4/scripts/sdk/util/zynqmp_utils.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "JTAG-ONB4 251633000A3BA"} -index 1
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "JTAG-ONB4 251633000A3BA" && level==0} -index 0
fpga -file C:/Users/st143005/Desktop/EIVE-SDI_RX_Subsystem/EIVE-SDI_RX_Subsystem.runs/impl_1/zusys_wrapper.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "JTAG-ONB4 251633000A3BA"} -index 1
loadhw -hw C:/Users/st143005/Desktop/EIVE-SDI_RX_Subsystem/EIVE-SDI_RX_Subsystem.sdk/zusys_wrapper_hw_platform_0/system.hdf -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "JTAG-ONB4 251633000A3BA"} -index 1
source C:/Users/st143005/Desktop/EIVE-SDI_RX_Subsystem/EIVE-SDI_RX_Subsystem.sdk/zusys_wrapper_hw_platform_0/psu_init.tcl
psu_init
after 1000
psu_ps_pl_isolation_removal
after 1000
psu_ps_pl_reset_config
catch {psu_protection}
configparams force-mem-access 0
bpadd -addr &main
