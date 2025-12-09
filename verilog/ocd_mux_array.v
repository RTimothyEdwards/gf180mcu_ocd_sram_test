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

// Module ocd_mux_array is a simple 2-1 multiplexer for the 8 bits
// of SRAM output, generated manually with standard cells from the
// gf180mcu_as_sc_mcu7t3v3 library.

module ocd_mux_array (
`ifdef USE_POWER_PINS
	inout vdd,
	inout vss,
`endif
	input		S,
	input  [7:0]	A,
	input  [7:0]	B,
	output [7:0]	Y
);

gf180mcu_as_sc_mcu7t3v3__mux2_4 multiplexer [7:0] (
`ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VNW(vdd),
	.VPW(vss),
`endif
	.S(S),
	.A(A)
	.B(B)
	.Y(Y)
);

// For LVS purposes, enumerate the decap cells

`ifdef LVS
gf180mcu_as_sc_mcu7t3v3__fillcap_4 decap [1:0] (
`ifdef USE_POWER_PINS
	.VDD(vdd),
	.VSS(vss),
	.VNW(vdd),
	.VPW(vss)
`endif
);

`endif // LVS

endmodule
