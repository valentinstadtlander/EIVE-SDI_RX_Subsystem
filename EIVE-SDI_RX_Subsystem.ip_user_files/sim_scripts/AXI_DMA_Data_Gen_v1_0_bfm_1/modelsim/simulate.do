onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L axi_infrastructure_v1_1_0 -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.AXI_DMA_Data_Gen_v1_0_bfm_1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {AXI_DMA_Data_Gen_v1_0_bfm_1.udo}

run -all

quit -force
