#!/bin/bash
#
# Run the klayout fill generation on the top level chip to produce
# the final design to submit to Wafer.Space.
#
# This script is assumed to be run in the magic/ directory, as it
# cds up one directory level and then down to gds/.  It could be
# made smarter about this.

echo "Generating fill for gf180mcu_ocd_sram_test"

# NOTE:  Hash sums cannot be run on the compressed layout, so
# generate an uncompressed layout, run the hash sums, then
# compress the layout.

echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null

cd ../gds

# Some designs have a requirement for flag "Metal2_ignore_active", or
# else the GF fill rules will not allow density to be met.  This is
# not necessary for this test chip because much of the core area is
# unused and is pure fill.

klayout -zz -r \
    ${PDK_ROOT}/gf180mcuD/libs.tech/klayout/tech/drc/filler_generation/fill_all.rb \
    -rd input=gf180mcu_ocd_sram_top.gds.gz \
    -rd output=gf180mcu_ocd_sram_filled.gds

echo "md5sum:"
md5sum gf180mcu_ocd_sram_filled.gds

echo "sha1sum:"
sha1sum gf180mcu_ocd_sram_filled.gds

echo "sha256sum:"
sha256sum gf180mcu_ocd_sram_filled.gds

gzip -n --best gf180mcu_ocd_sram_filled.gds

echo "Done!"
exit 0
