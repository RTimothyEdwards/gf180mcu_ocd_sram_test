/* Verilog testbench for SRAM test chip */

/* PDK libraries */
`include "/usr/share/pdk/gf180mcuD/libs.ref/gf180mcu_ocd_ip_sram/verilog/gf180mcu_ocd_ip_sram__sram512x8m8wm1.v"
`include "/usr/share/pdk/gf180mcuD/libs.ref/gf180mcu_ocd_ip_sram/verilog/gf180mcu_ocd_ip_sram__sram256x8m8wm1.v"
`include "/usr/share/pdk/gf180mcuD/libs.ref/gf180mcu_ocd_io/verilog/gf180mcu_ocd_io.v"
`include "/usr/share/pdk/gf180mcuD/libs.ref/gf180mcu_as_sc_mcu7t3v3/verilog/gf180mcu_as_sc_mcu7t3v3.v"
`include "/usr/share/pdk/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog/primitives.v"
`include "/usr/share/pdk/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/verilog/gf180mcu_fd_sc_mcu7t5v0.v"

/* Local modules */
`include "chip_half_frame.v"
`include "constant_block.v"
`include "copyright_block.v"
`include "gf180mcu_ocd_io__fill10x.v"
`include "gf180mcu_ocd_sram_test.v"
`include "lvlshift_down.v"
`include "ocd_mux_array.v"
`include "../ip/simple_por/verilog/simple_por.v"

module gf180mcu_ocd_sram_test_tb();

	/* Instantiate the chip */

	reg  [8:0] sram_addr;
	reg  [7:0] sram_data_in;
	wire [7:0] sram_512_data_out;
	wire [7:0] sram_256_data_out;
	reg 	   sram_512_1_cen;
	reg 	   sram_512_2_cen;
	reg 	   sram_256_1_cen;
	reg 	   sram_256_2_cen;
	reg	   sram_512_sel;
	reg	   sram_256_sel;
	reg  [7:0] wenb;
	reg 	   gwenb;
	reg 	   clk;
	reg 	   rst_n;	/* not used */
	wire	   por_out;
	reg	   ncin;	/* ground the no-connect input */
	reg  [3:0] ncana;	/* ground the analog inputs  */

	/* NOTE:  All bidirectional ports must be accessed as wires
	 * (to be completed)
	 */

	initial begin
		ncana <= 4'd0;
		ncin <= 1'b0;
		rst_n <= 1'b0;
		clk <= 1'b0;
	end

	always #15 clk <= (clk === 1'b0);

	initial begin
		$dumpfile("gf180mcu_ocd_sram_test_tb.vcd");
		$dumpvars(0, gf180mcu_ocd_sram_test_tb);

		/* Drive the SRAM signals */

		wenb <= 8'hff;
		gwenb <= 1'b1;
		sram_addr <= 9'h000;
		sram_data_in <= 8'h00;
		sram_512_1_cen <= 1'b1;
		sram_512_2_cen <= 1'b1;
		sram_256_1_cen <= 1'b1;
		sram_256_2_cen <= 1'b1;
		sram_512_sel <= 1'b0;
		sram_256_sel <= 1'b0;

		/* Quick test:  Enable one SRAM, write a value,
		 * read it back
		 */

		#100;
		sram_512_1_cen <= 1'b0;	  /* active low */
		#100;
		$display("   SRAM in  = 8'h%2h", sram_data_in);
		$display("   SRAM out = 8'h%2h", sram_512_data_out);
		sram_data_in <= 8'h55;
		#100;
		$display("   SRAM in  = 8'h%2h", sram_data_in);
		$display("   SRAM out = 8'h%2h", sram_512_data_out);
		wenb <= 8'h00;
		#100;
		$display("   SRAM in  = 8'h%2h", sram_data_in);
		$display("   SRAM out = 8'h%2h", sram_512_data_out);
		gwenb <= 1'b0;		/* force write */
		#100;
		$display("   SRAM in  = 8'h%2h", sram_data_in);
		$display("   SRAM out = 8'h%2h", sram_512_data_out);
		sram_data_in <= 8'haa;	/* change data */
		#100;
		$display("   SRAM in  = 8'h%2h", sram_data_in);
		$display("   SRAM out = 8'h%2h", sram_512_data_out);
		sram_512_1_cen <= 1'b1;	  /* disable (data retained) */
		#100;
		$display("   SRAM in  = 8'h%2h", sram_data_in);
		$display("   SRAM out = 8'h%2h", sram_512_data_out);

		$finish;
		
	end

	gf180mcu_ocd_sram_test dut (
		.DVDD(DVDD),
		.DVSS(DVSS),
		.VDD(VDD),
		.VSS(VSS),
		.bidir_PAD({gwenb,sram_addr[7:0],por_out,sram_data_in,sram_512_1_cen,
			sram_512_2_cen, sram_256_1_cen,sram_256_2_cen,wenb,
			sram_512_data_out, sram_256_data_out}),
		.analog_PAD(ncana),
		.input_PAD({sram_512_sel,sram_256_sel,sram_addr[8],ncin}),
		.clk_PAD(clk),
		.rst_n_PAD(rst_n)
	);

endmodule
