
`timescale 1ns / 1ps
`include "AXI_DMA_Data_Gen_v1_0_tb_include.svh"

import axi_vip_pkg::*;
import AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0_pkg::*;

module AXI_DMA_Data_Gen_v1_0_tb();


xil_axi_uint                            error_cnt = 0;
xil_axi_uint                            comparison_cnt = 0;
axi_transaction                         wr_transaction;   
axi_transaction                         rd_transaction;   
axi_monitor_transaction                 mst_monitor_transaction;  
axi_monitor_transaction                 master_moniter_transaction_queue[$];  
xil_axi_uint                            master_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 mst_scb_transaction;  
axi_monitor_transaction                 passthrough_monitor_transaction;  
axi_monitor_transaction                 passthrough_master_moniter_transaction_queue[$];  
xil_axi_uint                            passthrough_master_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 passthrough_mst_scb_transaction;  
axi_monitor_transaction                 passthrough_slave_moniter_transaction_queue[$];  
xil_axi_uint                            passthrough_slave_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 passthrough_slv_scb_transaction;  
axi_monitor_transaction                 slv_monitor_transaction;  
axi_monitor_transaction                 slave_moniter_transaction_queue[$];  
xil_axi_uint                            slave_moniter_transaction_queue_size =0;  
axi_monitor_transaction                 slv_scb_transaction;  
xil_axi_uint                           mst_agent_verbosity = 0;  
xil_axi_uint                           slv_agent_verbosity = 0;  
xil_axi_uint                           passthrough_agent_verbosity = 0;  
bit                                     clock;
bit                                     reset;
integer result_slave;  
bit [31:0] S00_AXI_test_data[3:0]; 
 localparam LC_AXI_BURST_LENGTH = 8; 
 localparam LC_AXI_DATA_WIDTH = 32; 
integer                                 i; 
integer                                 j;  
xil_axi_uint                            trans_cnt_before_switch = 48;  
xil_axi_uint                            passthrough_cmd_switch_cnt = 0;  
event                                   passthrough_mastermode_start_event;  
event                                   passthrough_mastermode_end_event;  
event                                   passthrough_slavemode_end_event;  
xil_axi_uint                            mtestID;  
xil_axi_ulong                           mtestADDR;  
xil_axi_len_t                           mtestBurstLength;  
xil_axi_size_t                          mtestDataSize;   
xil_axi_burst_t                         mtestBurstType;   
xil_axi_lock_t                          mtestLOCK;  
xil_axi_cache_t                         mtestCacheType = 0;  
xil_axi_prot_t                          mtestProtectionType = 3'b000;  
xil_axi_region_t                        mtestRegion = 4'b000;  
xil_axi_qos_t                           mtestQOS = 4'b000;  
xil_axi_data_beat                       dbeat;  
xil_axi_data_beat [255:0]               mtestWUSER;   
xil_axi_data_beat                       mtestAWUSER = 'h0;  
xil_axi_data_beat                       mtestARUSER = 0;  
xil_axi_data_beat [255:0]               mtestRUSER;      
xil_axi_uint                            mtestBUSER = 0;  
xil_axi_resp_t                          mtestBresp;  
xil_axi_resp_t[255:0]                   mtestRresp;  
bit [63:0]                              mtestWDataL; 
bit [63:0]                              mtestRDataL; 
axi_transaction                         pss_wr_transaction;   
axi_transaction                         pss_rd_transaction;   
axi_transaction                         reactive_transaction;   
axi_transaction                         rd_payload_transaction;  
axi_transaction                         wr_rand;  
axi_transaction                         rd_rand;  
axi_transaction                         wr_reactive;  
axi_transaction                         rd_reactive;  
axi_transaction                         wr_reactive2;   
axi_transaction                         rd_reactive2;  
axi_ready_gen                           bready_gen;  
axi_ready_gen                           rready_gen;  
axi_ready_gen                           awready_gen;  
axi_ready_gen                           wready_gen;  
axi_ready_gen                           arready_gen;  
axi_ready_gen                           bready_gen2;  
axi_ready_gen                           rready_gen2;  
axi_ready_gen                           awready_gen2;  
axi_ready_gen                           wready_gen2;  
axi_ready_gen                           arready_gen2;  
xil_axi_payload_byte                    data_mem[xil_axi_ulong];  
AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0_mst_t          mst_agent_0;

  `BD_WRAPPER DUT(
      .ARESETN(reset), 
      .ACLK(clock) 
    ); 
  
initial begin
   mst_agent_0 = new("master vip agent",DUT.`BD_INST_NAME.master_0.inst.IF);//ms  
   mst_agent_0.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE); 
   mst_agent_0.set_agent_tag("Master VIP"); 
   mst_agent_0.set_verbosity(mst_agent_verbosity); 
   mst_agent_0.start_master(); 
     $timeformat (-12, 1, " ps", 1);
  end
  initial begin
    reset <= 1'b0;
    #200ns;
    reset <= 1'b1;
    repeat (5) @(negedge clock); 
  end
  always #5 clock <= ~clock;
  initial begin
      S_AXI_TEST ( );

      #1ns;
      $finish;
  end

task automatic S_AXI_TEST;  
begin   
#1; 
   $display("Start test case:"); 
   mtestID = 0; 
   mtestBurstLength = 0; 
   mtestDataSize = xil_axi_size_t'(xil_clog2(32/8)); 
   mtestBurstType = XIL_AXI_BURST_TYPE_INCR;  
   mtestLOCK = XIL_AXI_ALOCK_NOLOCK;  
   mtestCacheType = 0;  
   mtestProtectionType = 0;  
   mtestRegion = 0; 
   mtestQOS = 0; 
   result_slave = 1; 
   
  // set packet length to 0x10
  mtestADDR = 64'h00000004; 
  mtestWDataL[31:0] = 32'h00000010; 
  mst_agent_0.AXI4LITE_WRITE_BURST(mtestADDR, mtestProtectionType, mtestWDataL, mtestBresp);   
  
  
  // start data generation
  mtestADDR = 64'h00000000; 
  mtestWDataL[31:0] = 32'h00000001; 
  mst_agent_0.AXI4LITE_WRITE_BURST(mtestADDR, mtestProtectionType, mtestWDataL, mtestBresp); 

  #200ns;
  
  //  reset data generator
  mtestADDR = 64'h00000000; 
  mtestWDataL[31:0] = 32'h00000000; 
  mst_agent_0.AXI4LITE_WRITE_BURST(mtestADDR, mtestProtectionType, mtestWDataL, mtestBresp);   
  
   #200ns;
  
  // set packet length to 0x100
  mtestADDR = 64'h00000004; 
  mtestWDataL[31:0] = 32'h00000100; 
  mst_agent_0.AXI4LITE_WRITE_BURST(mtestADDR, mtestProtectionType, mtestWDataL, mtestBresp);   
  
  
  // start data generation
  mtestADDR = 64'h00000000; 
  mtestWDataL[31:0] = 32'h00000001; 
  mst_agent_0.AXI4LITE_WRITE_BURST(mtestADDR, mtestProtectionType, mtestWDataL, mtestBresp); 
  
  
//     $display("Sequential read transfers example similar to  AXI BFM READ_BURST method starts"); 
//     mtestID = 0; 
//     mtestBurstLength = 0; 
//     mtestDataSize = xil_axi_size_t'(xil_clog2(32/8)); 
//     mtestBurstType = XIL_AXI_BURST_TYPE_INCR;  
//     mtestLOCK = XIL_AXI_ALOCK_NOLOCK;  
//     mtestCacheType = 0;  
//     mtestProtectionType = 0;  
//     mtestRegion = 0; 
//     mtestQOS = 0; 

//   mtestADDR = 64'h00000000;
//   mst_agent_0.AXI4LITE_READ_BURST( 
//        mtestADDR, 
//        mtestProtectionType, 
//        mtestRDataL, 
//        mtestRresp 
//   );
 end
endtask  

endmodule
