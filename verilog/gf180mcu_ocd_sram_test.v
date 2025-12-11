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

/*
 *-------------------------------------------------------------------------
 * gf180mcu_ocd_sram_test ---
 *
 * RTL verilog definition of the SRAM test chip submitted to
 * wafer.space for a 1/2 height slot.  This file is for LVS
 * verification.
 *
 * Written by Tim Edwards
 * December 2025
 *-------------------------------------------------------------------------
 */

// `default_nettype none

module gf180mcu_ocd_sram_test (
	inout wire		DVDD,
	inout wire		DVSS,
	inout wire		VDD,
	inout wire		VSS,
	
	inout wire [45:0]	bidir_PAD,
	inout wire [3:0]	analog_PAD,
	input wire [3:0]	input_PAD,
	input wire		clk_PAD,
	input wire		rst_n_PAD
);
	/* Padframe loopback wiring */

	wire [51:0]	loopback_one;
	wire [51:0]	loopback_zero;

	/* Main SRAM wiring */

	wire [8:0]	shared_addr;
	wire [7:0]	shared_din;
	wire [7:0]	sram_512_1_qout;
	wire [7:0]	sram_512_2_qout;
	wire [7:0]	sram_256_1_qout;
	wire [7:0]	sram_256_2_qout;
	wire		shared_gwen;
	wire [7:0]	shared_wen;
	wire		shared_clk;
	wire		sram_512_1_cen;
	wire		sram_512_2_cen;
	wire		sram_256_1_cen;
	wire		sram_256_2_cen;

	/* Multiplexed SRAM outputs */

	wire [7:0]	shared_512_qout;
	wire [7:0]	shared_256_qout;

	/* Multiplexer control */
	wire		sram_output_select_512;
	wire		sram_output_select_256;

	/* POR test output */
	wire		por_h;		/* output in 5V domain */
	wire		por_l;		/* output in 3.3V domain */

	/* No-connects */
	wire [18:0]	ncin;		/* unused pad input pins */
	wire [28:0]	ncout;		/* unused pad output pins */

	/* Implement the padframe.  All pad behavior is fixed by
	 * local loopback connections to digital one and zero.
	 */
	chip_half_frame  chip_half_frame_0 (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS),

		.bidir_PAD(bidir_PAD),
		.analog_PAD(analog_PAD),
		.input_PAD(input_PAD),
		.clk_PAD(clk_PAD),
		.rst_n_PAD(rst_n_PAD),

		/* All bidirectional pads are connected either as simple
		 * input or simple output.  Counterclockwise, there are:
		 * 1 input (gwen)
		 * 1 output (por)
		 * 28 inputs (various)
		 * 16 outputs (SRAM output)
		 *
		 * Simple inputs and outputs only differ in IE and OE,
		 * A vs. Y connection (A is grounded on inputs), and
		 * drive (outputs are set to high drive).
		 *
 		 * Set loopback vector to align with the lower bidir pads.
		 * The 4 values above that are for the input pins, followed 
		 * by the clock pad, and finally the reset pad. 
		 *
		 * The "bidir" pads are counted counter-clockwise from the
		 * bottom lower left, so when ordering vectors in verilog
		 * high-to-low order, they start at the leftmost pad on the
		 * top pad row and count clockwise.
		 */

		.bidir_CS(loopback_zero[45:0]),
		.bidir_PU(loopback_zero[45:0]),
		.bidir_PD(loopback_zero[45:0]),
		.bidir_PDRV0({loopback_one[45:30],
			      loopback_zero[29:2],
			      loopback_one[1],
			      loopback_zero[0]}),
		.bidir_PDRV1({loopback_one[45:30],
			      loopback_zero[29:2],
			      loopback_one[1],
			      loopback_zero[0]}),
		.bidir_ANA(),
		.bidir_IE({loopback_zero[45:30],
			   loopback_one[29:2],
			   loopback_zero[1],
			   loopback_one[0]}),
		.bidir_SL(loopback_zero[45:0]),
		.bidir_OE({loopback_one[45:30],
			   loopback_zero[29:2],
			   loopback_one[1],
			   loopback_zero[0]}),
		.bidir_A({shared_512_qout[0],
			  shared_512_qout[1],
			  shared_512_qout[2],
			  shared_512_qout[3],
			  shared_512_qout[4],
			  shared_512_qout[5],
			  shared_512_qout[6],
			  shared_512_qout[7],
			  shared_256_qout[0],
			  shared_256_qout[1],
			  shared_256_qout[2],
			  shared_256_qout[3],
			  shared_256_qout[4],
			  shared_256_qout[5],
			  shared_256_qout[6],
			  shared_256_qout[7],
			  loopback_zero[29:2],
			  por_l,
			  loopback_zero[0]}),
		.bidir_Y({ncin[15:0], 
			  shared_wen[7],
			  shared_wen[6],
			  shared_wen[5],
			  shared_wen[4],
			  shared_wen[3],
			  shared_wen[2],
			  shared_wen[1],
			  shared_wen[0],
			  sram_256_2_cen,
		  	  sram_256_1_cen,
		  	  sram_512_2_cen,
		  	  sram_512_1_cen,
			  shared_din[0],
			  shared_din[1],
			  shared_din[2],
			  shared_din[3],
			  shared_din[4],
			  shared_din[5],
			  shared_din[6],
			  shared_din[7],
			  shared_addr[0],
			  shared_addr[1],
			  shared_addr[2],
			  shared_addr[3],
			  shared_addr[4],
			  shared_addr[5],
			  shared_addr[6],
			  shared_addr[7],
			  ncin[16],
			  shared_gwen}),

		.loopback_one(loopback_one),
		.loopback_zero(loopback_zero),

		.input_PU(loopback_zero[49:46]),
		// input_PAD[1] has a test pulldown
		.input_PD({loopback_zero[49:48],loopback_one[47],loopback_zero[46]}),
		.input_Y({shared_addr[8],
			  sram_output_select_256,
			  ncin[17],
			  sram_output_select_512}),

		.clk_PU(loopback_zero[50]),
		.clk_PD(loopback_zero[50]),
		.clk_Y(shared_clk),

		.rst_n_PU(loopback_one[51]),		/* standard pull-up reset */
		.rst_n_PD(loopback_zero[51]),
		.rst_n_Y(ncin[18])			/* unused */
	);

	/* Implement the two 512 byte SRAMs */

	gf180mcu_ocd_ip_sram__sram512x8m8wm1  sram512_0 (
        `ifdef USE_POWER_PINS
            .VDD(VDD),
            .VSS(VSS),
        `endif
            .CLK(shared_clk),
            .CEN(sram_512_1_cen),
            .GWEN(shared_gwen),
            .WEN(shared_wen),
            .A(shared_addr),
            .D(shared_din),
            .Q(sram_512_1_qout)
	);

	gf180mcu_ocd_ip_sram__sram512x8m8wm1  sram512_1 (
        `ifdef USE_POWER_PINS
            .VDD(VDD),
            .VSS(VSS),
        `endif
            .CLK(shared_clk),
            .CEN(sram_512_2_cen),
            .GWEN(shared_gwen),
            .WEN(shared_wen),
            .A(shared_addr),
            .D(shared_din),
            .Q(sram_512_2_qout)
	);

	/* Implement the two 256 byte SRAMs */

	gf180mcu_ocd_ip_sram__sram256x8m8wm1  sram256_0 (
	`ifdef USE_POWER_PINS
            .VDD(VDD),
            .VSS(VSS),
	`endif
            .CLK(shared_clk),
            .CEN(sram_256_1_cen),
            .GWEN(shared_gwen),
            .WEN(shared_wen),
            .A(shared_addr[7:0]),
            .D(shared_din),
            .Q(sram_256_1_qout)
	);

	gf180mcu_ocd_ip_sram__sram256x8m8wm1  sram256_1 (
	`ifdef USE_POWER_PINS
            .VDD(VDD),
            .VSS(VSS),
	`endif
            .CLK(shared_clk),
            .CEN(sram_256_2_cen),
            .GWEN(shared_gwen),
            .WEN(shared_wen),
            .A(shared_addr[7:0]),
            .D(shared_din),
            .Q(sram_256_2_qout)
	);

	/* Implement the POR (5V) */

	simple_por por (
	`ifdef USE_POWER_PINS
		.VDD(DVDD),
		.VSS(DVSS),
	`endif
		.por(por_h),
		.porb()		/* not connected */
	);

	/* Implement the POR's level shifter (5V to 3.3V) */

	lvlshift_down level_shifter (
	`ifdef USE_POWER_PINS
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
	`endif
		.AH(por_h),
		.YL(por_l)
	);

	/* Implement the multiplexer for the 512 byte SRAM outputs */

	ocd_mux_array mux_512 (
	`ifdef USE_POWER_PINS
		.vdd(VDD),
		.vss(VSS),
	`endif
		.S(sram_output_select_512),
		// The muxes are all numbered backwards from the SRAM outputs
		.A({sram_512_1_qout[0],sram_512_1_qout[1],
			sram_512_1_qout[2],sram_512_1_qout[3],
			sram_512_1_qout[4],sram_512_1_qout[5],
			sram_512_1_qout[6],sram_512_1_qout[7]}),
		.B({sram_512_2_qout[0],sram_512_2_qout[1],
			sram_512_2_qout[2],sram_512_2_qout[3],
			sram_512_2_qout[4],sram_512_2_qout[5],
			sram_512_2_qout[6],sram_512_2_qout[7]}),
		.Y({shared_512_qout[0],shared_512_qout[1],
			shared_512_qout[2],shared_512_qout[3],
			shared_512_qout[4],shared_512_qout[5],
			shared_512_qout[6],shared_512_qout[7]})
	);

	/* Implement the multiplexer for the 256 byte SRAM outputs */

	ocd_mux_array mux_256 (
	`ifdef USE_POWER_PINS
		.vdd(VDD),
		.vss(VSS),
	`endif
		.S(sram_output_select_256),
		// The muxes are all numbered backwards from the SRAM outputs
		.A({sram_256_1_qout[0],sram_256_1_qout[1],
			sram_256_1_qout[2],sram_256_1_qout[3],
			sram_256_1_qout[4],sram_256_1_qout[5],
			sram_256_1_qout[6],sram_256_1_qout[7]}),
		.B({sram_256_2_qout[0],sram_256_2_qout[1],
			sram_256_2_qout[2],sram_256_2_qout[3],
			sram_256_2_qout[4],sram_256_2_qout[5],
			sram_256_2_qout[6],sram_256_2_qout[7]}),
		.Y({shared_256_qout[0],shared_256_qout[1],
			shared_256_qout[2],shared_256_qout[3],
			shared_256_qout[4],shared_256_qout[5],
			shared_256_qout[6],shared_256_qout[7]})
	);

endmodule

// `default_nettype wire
