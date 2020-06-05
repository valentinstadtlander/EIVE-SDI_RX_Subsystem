onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib SDI_RX_Subsystem_v1_0_bfm_1_opt

do {wave.do}

view wave
view structure
view signals

do {SDI_RX_Subsystem_v1_0_bfm_1.udo}

run -all

quit -force
