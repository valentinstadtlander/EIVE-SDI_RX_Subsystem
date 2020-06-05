vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/smartconnect_v1_0
vlib activehdl/axi_protocol_checker_v2_0_1
vlib activehdl/axi_vip_v1_1_1

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap smartconnect_v1_0 activehdl/smartconnect_v1_0
vmap axi_protocol_checker_v2_0_1 activehdl/axi_protocol_checker_v2_0_1
vmap axi_vip_v1_1_1 activehdl/axi_vip_v1_1_1

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/1b5a/hdl/AXI_DMA_Data_Gen_v1_0_S00_AXI.vhd" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/1b5a/hdl/AXI_DMA_Data_Gen_v1_0.vhd" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_AXI_DMA_Data_Gen_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_AXI_DMA_Data_Gen_0_0.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/sc_util_v1_0_vl_rfs.sv" \

vlog -work axi_protocol_checker_v2_0_1  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/3b24/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0_pkg.sv" \

vlog -work axi_vip_v1_1_1  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/a16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0.sv" \

vcom -work xil_defaultlib -93 \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/sim/AXI_DMA_Data_Gen_v1_0_bfm_1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

