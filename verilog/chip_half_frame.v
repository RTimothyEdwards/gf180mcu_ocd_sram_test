// SPDX-FileCopyrightText: 2025 Open Circuit Design, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------------------------------------------------
// Original copyright from upstream project caravel-gf180mcu, from which
// this work was derived: SPDX-FileCopyrightText: 2020 Efabless Corporation
// Upstream repository from which this work was derived:
// https://github.com/efabless/caravel-gf180mcu/
//-------------------------------------------------------------------------

module chip_half_frame (
`ifdef USE_POWER_PINS
	// Power buses (chip pins and core side not separated)
	inout  DVDD,	// Padfreame/ESD 5.0V supply
	inout  DVSS,	// Padfreame/ESD 5.0V ground
	inout  VDD,	// Padframe/core 3.3V supply
	inout  VSS,	// Padframe/core 3.3V ground
`endif
	// Pad signals
	inout  [45:0] bidir_PAD,
	inout  [3:0]  analog_PAD,
	input  [3:0]  input_PAD,
	input	      clk_PAD,
	input	      rst_n_PAD,

	// Core signals
	// Bidirectional Signal pins
	input  [45:0] bidir_CS,
	input  [45:0] bidir_PU,
	input  [45:0] bidir_PDRV0,
	input  [45:0] bidir_PDRV1,
	inout  [45:0] bidir_ANA,
	input  [45:0] bidir_PD,
	input  [45:0] bidir_IE,
	input  [45:0] bidir_SL,
	input  [45:0] bidir_A,
	input  [45:0] bidir_OE,
	output [45:0] bidir_Y,

	// Loopback digital values
	// (one for each bidir and input pad)
	output [51:0] loopback_one,
	output [51:0] loopback_zero,

	// Input pads
	input	[3:0] input_PU,
	input	[3:0] input_PD,
	output	[3:0] input_Y,

	// Clock pad
	input	clk_PU,
	input	clk_PD,
	output	clk_Y,

	// Reset pad
	input	rst_n_PU,
	input	rst_n_PD,
	output	rst_n_Y
);
	// Instantiate power and ground pads for the two voltage
	// domains DVDD/DVSS (5V) and VDD/VSS (3.3V).

    	gf180mcu_ocd_io__dvdd DVDD_pad [3:0] (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
    	);

    	gf180mcu_ocd_io__dvss DVSS_pad [3:0] (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
    	);

    	gf180mcu_ocd_io__vdd VDD_pad [3:0] (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
    	);

    	gf180mcu_ocd_io__vss VSS_pad [3:0] (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
    	);

	gf180mcu_ocd_io__in_s rst_n_pad (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS),
		.PU(rst_n_PU),
		.PD(rst_n_PD),
		.PAD(rst_n_PAD),
		.Y(rst_n_Y)
	);

	gf180mcu_ocd_io__in_c clk_pad (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS),
		.PU(clk_PU),
		.PD(clk_PD),
		.PAD(clk_PAD),
		.Y(clk_Y)
	);

	// Corner cells

	gf180mcu_ocd_io__cor padframe_corner [3:0] (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
	);

	// Bidirectional general-purpose I/O

	gf180mcu_ocd_io__bi_a bidir_pad [45:0] (
		`ifdef USE_POWER_PINS
			.DVDD(DVDD),
			.DVSS(DVSS),
			.VDD(VDD),
			.VSS(VSS),
		`endif
		.PAD(bidir_PAD),
		.CS(bidir_CS),
		.SL(bidir_SL),
		.IE(bidir_IE),
		.OE(bidir_OE),
		.PU(bidir_PU),
		.PD(bidir_PD),
		.PDRV0(bidir_PDRV0),
		.PDRV1(bidir_PDRV1),
		.A(bidir_A),
		.ANA(bidir_ANA),
		.Y(bidir_Y)
	);

	// Four input pads

	gf180mcu_ocd_io__in_c input_pad [3:0] (
		`ifdef USE_POWER_PINS
			.DVDD(DVDD),
			.DVSS(DVSS),
			.VDD(VDD),
			.VSS(VSS),
		`endif
		.PAD(input_PAD),
		.PU(input_PU),
		.PD(input_PD),
		.Y(input_Y)
	);

	// Four analog pads

	gf180mcu_ocd_io__asig_5p0 analog_pad [3:0] (
	`ifdef USE_POWER_PINS
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS),
	`endif
		.ASIG5V(analog_PAD)
	);

	// Generate all fill cells with arrays (only fill5 and fill10 used)
	// These cells are filled with decap, so they are not empty and
	// are required to be present to pass LVS.

	gf180mcu_ocd_io__fillnc padframe_fillnc [19:0] (
	`ifdef USE_POWER_PINS
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
	`endif
	);

	gf180mcu_ocd_io__fill1 padframe_fill1 [225:0] (
	`ifdef USE_POWER_PINS
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
	`endif
	);

	gf180mcu_ocd_io__fill5 padframe_fill5 [21:0] (
	`ifdef USE_POWER_PINS
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
	`endif
	);

	gf180mcu_ocd_io__fill10 padframe_fill10 [361:0] (
	`ifdef USE_POWER_PINS
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS)
	`endif
	);

	// "fill10x" is a local variant of "fill10" with
	// two decap pairs removed and replaced with a
	// constant output generator cell.  There are 45
	// of these that provide constant 1 and 0 in the
	// 3.3V domain for all of the GPIOs plus the
	// resetb pin (see above).

	gf180mcu_ocd_io__fill10x padframe_fill10x_gpio [51:0] (
	`ifdef USE_POWER_PINS
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS),
	`endif
		.one(loopback_one),
		.zero(loopback_zero)
	);

endmodule
// `default_nettype wire
