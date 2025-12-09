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

// Module lvlshift_down is a level-shift buffer which is placed within
// a 10um padframe spacer and used (within the GF caravel openframe
// project) to put the power-on-reset output into the 3.3V digital
// core voltage domain.

module lvlshift_down (
`ifdef USE_POWER_PINS
	inout DVDD,	// 5.0V domain power supply
	inout DVSS,	// 5.0V domain ground return
	inout VDD,	// 3.3V domain power supply
`endif
	input  AH,	// 5.0V domain input
	output YL	// 3.3V domain output
);

wire ABH;

// NOTE:  This cell crosses voltage domains, but the
// low and high voltage ground returns are not really
// separated in the I/O library anyway, except by
// virtual ground cuts.

gf180mcu_fd_sc_mcu7t5v0__inv_12 inv_out (
`ifdef USE_POWER_PINS
	.VDD(VDD),
	.VSS(DVSS),
	.VNW(VDD),
	.VPW(DVSS),
`endif
	.I(ABH),
	.ZN(YL)
);

gf180mcu_fd_sc_mcu7t5v0__inv_8 inv_in (
`ifdef USE_POWER_PINS
	.VDD(DVDD),
	.VSS(DVSS),
	.VNW(DVDD),
	.VPW(DVSS),
`endif
	.I(AH),
	.ZN(ABH)
);

// For LVS purposes, enumerate the decap cell and antenna cell
`ifdef LVS
gf180mcu_fd_sc_mcu7t5v0__fillcap_8 decap (
`ifdef USE_POWER_PINS
	.VDD(DVDD),
	.VSS(DVSS),
	.VNW(DVDD),
	.VPW(DVSS)
`endif
);

gf180mcu_fd_sc_mcu7t5v0__antenna tiedown (
`ifdef USE_POWER_PINS
	.VDD(DVDD),
	.VSS(DVSS),
	.VNW(DVDD),
	.VPW(DVSS),
`endif
	.I(AH)
);
`endif // LVS

endmodule
