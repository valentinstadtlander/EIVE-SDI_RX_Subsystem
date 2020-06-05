

set RXEDHcells [get_cells -hier -regexp -filter {IS_PRIMITIVE && IS_SEQUENTIAL} .*INCLUDE_EDH.*]
  set_multicycle_path -setup -from $RXEDHcells 5
  set_multicycle_path -hold -from $RXEDHcells 4


set TXEDHcells_1 [get_cells -hier -regexp -filter {IS_PRIMITIVE && IS_SEQUENTIAL} .*TXEDH.*]
  set_multicycle_path -setup -from $TXEDHcells_1 5
  set_multicycle_path -hold -from $TXEDHcells_1 4

set TXEDHcells_2 [get_cells -hier -regexp -filter {IS_PRIMITIVE && IS_SEQUENTIAL} .*TX.*EDH_TX.*]
  set_multicycle_path -setup -from $TXEDHcells_2 5
  set_multicycle_path -hold -from $TXEDHcells_2 4

set TXEDHcells_3 [get_cells -hier -regexp -filter {IS_PRIMITIVE && IS_SEQUENTIAL} .*TX.*EDH_CRC.*]
  set_multicycle_path -setup -from $TXEDHcells_3 5
  set_multicycle_path -hold -from $TXEDHcells_3 4
