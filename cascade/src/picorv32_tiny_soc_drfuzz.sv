// Copyright 2022 Flavien Solt, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

module picorv32_tiny_soc #(
    // The two below must be equal.
    parameter int unsigned InstrMemDepth = 1 << 20, // 32-bit words
    parameter int unsigned DataMemDepth  = 1 << 20, // 32-bit words

    localparam type data_t = logic [31:0],
    localparam type strb_t = logic [ 3:0], // The strobe is bytewise.
    localparam type addr_t = logic [31:0]
) (
  input logic clk_i,
  input logic rst_ni,

  ///////////
  // RFUZZ //
  ///////////

  input logic meta_rst_ni,
  input logic [132:0] fuzz_in,
  output logic [171:0] auto_cover_out
);

  picorv32_mem_top i_picorv32_mem_top (
    .clk(clk_i),
    .resetn(rst_ni),
    .trap(),

    .instr_mem_req(),
    .instr_mem_addr(),
    .instr_mem_wdata(),
    .instr_mem_strb(),
    .instr_mem_we(),
    .data_mem_req(),
    .data_mem_addr(),
    .data_mem_wdata(),
    .data_mem_strb(),
    .data_mem_we(),

    // Look-Ahead Interface
    .mem_la_read(),
    .mem_la_write(),
    .mem_la_addr(),
    .mem_la_wdata(),
    .mem_la_wstrb(),

    // Pico Co-Processor Interface (PCPI)
    .pcpi_valid(),
    .pcpi_insn(),
    .pcpi_rs1(),
    .pcpi_rs2(),

    // IRQ Interface
    .eoi(),

    // Trace Interface
    .trace_valid(),
    .trace_data(),

    // RFUZZ output
    .fuzz_in(fuzz_in),
    .metaReset(~meta_rst_ni),
    .auto_cover_out(auto_cover_out)
  );

endmodule
