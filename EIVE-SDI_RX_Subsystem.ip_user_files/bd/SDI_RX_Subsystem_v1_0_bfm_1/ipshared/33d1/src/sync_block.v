`timescale 1ps / 1ps

module sync_block #(
  	parameter INITIALIZE = 3'b000
)
(
  input        clk,              // clock to be sync'ed to
  input        din,          	// Data to be 'synced'
  output       dout          	// synced data
);

// Internal Signals
wire data_sync1;
wire data_sync2;
wire data_sync3;


(* shreg_extract = "no", ASYNC_REG = "TRUE" *)
FD #(
	.INIT (INITIALIZE[0]))
data_sync (
	.C  (clk),
	.D  (din),
	.Q  (data_sync1)
);

(* shreg_extract = "no", ASYNC_REG = "TRUE" *)
FD #(
	.INIT (INITIALIZE[1]))
data_sync_reg (
	.C  (clk),
	.D  (data_sync1),
	.Q  (data_sync2)
);

(* shreg_extract = "no", ASYNC_REG = "TRUE" *)
FD #(
	.INIT (INITIALIZE[2]))
data_sync_reg_2 (
	.C  (clk),
	.D  (data_sync2),
	.Q  (data_sync3)
);
assign dout = data_sync3;

endmodule
