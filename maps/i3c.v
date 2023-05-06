module SB_IO_I3C (
	inout  PACKAGE_PIN,
	input  LATCH_INPUT_VALUE,
	input  CLOCK_ENABLE,
	input  INPUT_CLK,
	input  OUTPUT_CLK,
	input  OUTPUT_ENABLE,
	input  D_OUT_0,
	input  D_OUT_1,
	output D_IN_0,
	output D_IN_1,
	input  PU_ENB,
	input  WEAK_PU_ENB
);
	parameter [5:0] PIN_TYPE = 6'b000000;
	parameter [0:0] PULLUP = 1'b0;
	parameter [0:0] WEAK_PULLUP = 1'b0;
	parameter [0:0] NEG_TRIGGER = 1'b0;
	parameter IO_STANDARD = "SB_LVCMOS";

    IO_I3C #(
        .PIN_TYPE(PIN_TYPE),
        .PULLUP(PULLUP),
        .WEAK_PULLUP(WEAK_PULLUP),
        .NEG_TRIGGER(NEG_TRIGGER),
        .IO_STANDARD(IO_STANDARD)
    ) _TECHMAP_REPLACE_ (
        .PACKAGE_PIN(PACKAGE_PIN),
        .LATCH_INPUT_VALUE(LATCH_INPUT_VALUE),
        .CLOCK_ENABLE(CLOCK_ENABLE),
        .INPUT_CLK(INPUT_CLK),
        .OUTPUT_CLK(OUTPUT_CLK),
        .OUTPUT_ENABLE(OUTPUT_ENABLE),
        .D_OUT_0(D_OUT_0),
        .D_OUT_1(D_OUT_1),
        .D_IN_0(D_IN_0),
        .D_IN_1(D_IN_1),
        .PU_ENB(PU_ENB),
        .WEAK_PU_ENB(WEAK_PU_ENB)
    );
endmodule