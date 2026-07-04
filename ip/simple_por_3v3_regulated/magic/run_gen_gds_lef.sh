#!/bin/bash
#
# Run GDS and LEF generation on the 3.3V PoR
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null
project=por_3v3_selfbiased

echo "Running GDS and LEF generation on ${project}"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF
load ${project}
select top cell
expand
select top cell
gds compress 9
gds write por_3v3_selfbiased
select top cell
lef write -hide
quit -noprompt
EOF
rm -rf extfiles
mv por_3v3_selfbiased.gds.gz ../gds/
mv por_3v3_selfbiased.lef ../lef/
echo "Done"
