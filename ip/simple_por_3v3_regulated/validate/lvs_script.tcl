# Tcl script for setting up LVS for the gf180mcu 3.3V PoR

if {[catch {set PDK_ROOT $::env(PDK_ROOT)}]} {set PDK_ROOT /usr/share/pdk} 
if {[catch {set PDK $::env(PDK)}]} {set PDK gf180mcuD}

set circuit2 [readnet spice ${PDK_ROOT}/${PDK}/libs.ref/gf180mcu_as_sc_mcu7t3v3/spice/gf180mcu_as_sc_mcu7t3v3.spice]
readnet spice ../netlist/schematic/por_3v3_selfbiased.spice $circuit2

set circuit1 [readnet spice ../netlist/layout/por_3v3_selfbiased.spice]

lvs "$circuit1 por_3v3_selfbiased" "$circuit2 por_3v3_selfbiased" \
${PDK_ROOT}/${PDK}/libs.tech/netgen/${PDK}_setup.tcl por_3v3_selfbiased_comp.out
