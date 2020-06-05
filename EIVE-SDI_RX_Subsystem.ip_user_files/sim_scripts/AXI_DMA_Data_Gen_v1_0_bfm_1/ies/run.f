-makelib ies_lib/xil_defaultlib -sv \
  "D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/1b5a/hdl/AXI_DMA_Data_Gen_v1_0_S00_AXI.vhd" \
  "../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/1b5a/hdl/AXI_DMA_Data_Gen_v1_0.vhd" \
  "../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_AXI_DMA_Data_Gen_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_AXI_DMA_Data_Gen_0_0.vhd" \
-endlib
-makelib ies_lib/axi_infrastructure_v1_1_0 \
  "../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies_lib/smartconnect_v1_0 -sv \
  "../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/sc_util_v1_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/axi_protocol_checker_v2_0_1 -sv \
  "../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/3b24/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \
-endlib
-makelib ies_lib/xil_defaultlib -sv \
  "../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0_pkg.sv" \
-endlib
-makelib ies_lib/axi_vip_v1_1_1 -sv \
  "../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/a16a/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib ies_lib/xil_defaultlib -sv \
  "../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0.sv" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/sim/AXI_DMA_Data_Gen_v1_0_bfm_1.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

