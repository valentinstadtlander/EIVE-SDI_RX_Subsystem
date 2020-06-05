onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+SDI_RX_Subsystem_v1_0_bfm_1 -L xil_defaultlib -L xpm -L gtwizard_ultrascale_v1_7_2 -L v_smpte_uhdsdi_v1_0_5 -L axi_infrastructure_v1_1_0 -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.SDI_RX_Subsystem_v1_0_bfm_1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {SDI_RX_Subsystem_v1_0_bfm_1.udo}

run -all

endsim

quit -force
