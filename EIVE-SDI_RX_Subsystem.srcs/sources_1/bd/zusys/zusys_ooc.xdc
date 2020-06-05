################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name gth_cpll_refclk_p_in -period 6.734 [get_ports gth_cpll_refclk_p_in]
create_clock -name gth_cpll_refclk_n_in -period 6.734 [get_ports gth_cpll_refclk_n_in]

################################################################################