/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	I fell T_T .......
--Version:VERA.1.0.0
--Data modified:
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created: 2015/6/10 14:13:04
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module DA_multiper #(
	parameter		ASIZE	= 8,
	parameter		BSIZE	= 8,		//BSIZE should be smaller than ASIZE
	parameter		PSIZE	= 3			// it will raise error ,if 2^PSIZE !>= BSIZE
)(
	input						clock,
	input						rst_n,
	input [ASIZE-1:0]			adata,
	input [BSIZE-1:0]			bdata,
	output[ASIZE+BSIZE-1:0] 	cdata
);
initial begin
	if(2**PSIZE < BSIZE || 2**(PSIZE-1) >=BSIZE)
		$display("PARAM is wrong");
end

localparam		WSIZE	= (ASIZE+BSIZE)*(2**(PSIZE+1)-1);		//It may be confusing 

wire [ASIZE+BSIZE-1:0]	aepan	[2**PSIZE-1:0];

genvar II;
genvar JJ;
generate
	for(II=0;II<2**PSIZE;II=II+1)
		if(II<BSIZE)
			assign	aepan[II] 	= bdata[II]? {{(BSIZE-II){1'b0}},(adata<<II)} : {(ASIZE+BSIZE){1'b0}};
		else
			assign	aepan[II]	= {(ASIZE+BSIZE){1'b0}};
endgenerate

wire [WSIZE-1:0]	wdata;
generate
	for(II=0;II<BSIZE;II=II+1)
		assign	wdata[II*(ASIZE+BSIZE)+:(ASIZE+BSIZE)]	= aepan[II];
endgenerate


wire [((ASIZE+BSIZE) *(2**PSIZE)) * PSIZE -1:0]	indata;
wire [(ASIZE+BSIZE+1)*(2**PSIZE) *  PSIZE -1:0] outdata;

wire[(ASIZE+BSIZE)	*(2**PSIZE)-1:0]	test_in  [PSIZE-1:0];
wire[(ASIZE+BSIZE)  *(2**PSIZE)-1:0]	test_out [PSIZE-1:0];

generate
	for(II=0;II<2**PSIZE;II=II+1)
		assign	indata[II*(ASIZE+BSIZE)+:(ASIZE+BSIZE)]	= aepan[II];
endgenerate

generate

for(II=0;II<PSIZE;II=II+1)begin:GEN_LOOP
//assign_ment JJ=JJ+(ASIZE+BSIZE)*(2**PSIZE)  Verilog can't do it, SO bad
/*
mult_add #(
	.DSIZE	( ASIZE+BSIZE	),
	.WSIZE	((ASIZE+BSIZE)*(2**PSIZE)  	)//number = WSIZE/DSIZE
)mult_add_inst(
	.clk		(clock			),
	.rst_n  	(rst_n			),
	.wdata  	(wdata[JJ +:(ASIZE+BSIZE)*(2**PSIZE)]			),
	.odata		(wdata[JJ + (ASIZE+BSIZE)*(2**PSIZE) +: (ASIZE+BSIZE)*(2**(PSIZE-1))]		)
);
*/

mult_add #(
	.DSIZE	( ASIZE+BSIZE	),
	.WSIZE	((ASIZE+BSIZE)*(2**(PSIZE-II))  	)//number = WSIZE/DSIZE
)mult_add_inst(
	.clk		(clock			),
	.rst_n  	(rst_n			),
	.wdata  	(indata [ (ASIZE+BSIZE)  *(2**PSIZE)*II +: (ASIZE+BSIZE)  *(2**(PSIZE-II))]		),
	.odata		(outdata[ (ASIZE+BSIZE+1)*(2**PSIZE)*II +: (ASIZE+BSIZE+1)*(2**(PSIZE-II)/2)]	)
);
if(II < PSIZE-1)begin
//	assign	indata[  (ASIZE+BSIZE)  *(2**PSIZE)*(II+1) +: (ASIZE+BSIZE)  *(2**(PSIZE-II)/2)] = 
//			outdata[ (ASIZE+BSIZE+1)*(2**PSIZE)* II    +: (ASIZE+BSIZE)  *(2**(PSIZE-II)/2)];
	for(JJ=0;JJ<2**PSIZE;JJ=JJ+1)begin
		assign	indata[  (ASIZE+BSIZE)  *(2**PSIZE)*(II+1) + (ASIZE+BSIZE)*JJ +: (ASIZE+BSIZE)] = 
				outdata[ (ASIZE+BSIZE+1)*(2**PSIZE)* II    +(ASIZE+BSIZE+1)*JJ+: (ASIZE+BSIZE)];
	end
end else begin
	assign	cdata	= outdata[(ASIZE+BSIZE+1) * (2**PSIZE)*II +: (ASIZE+BSIZE)];
end
end
//assign	cdata	= wdata[JJ+:(ASIZE+BSIZE)];
endgenerate

//integer				test0,text1 [PSIZE-1:0][(2**PSIZE)-1:0];		//suck
integer				test0 [PSIZE-1:0][(2**PSIZE)-1:0];		
integer				test1 [PSIZE-1:0][(2**PSIZE)-1:0];		
generate
	for(II=0;II<PSIZE;II=II+1)begin
		assign	test_in[II]		= indata [(ASIZE+BSIZE)  *(2**PSIZE)*II +: (ASIZE+BSIZE)*(2**PSIZE)];
		assign	test_out[II]	= outdata[(ASIZE+BSIZE+1)*(2**PSIZE)*II +: (ASIZE+BSIZE)*(2**PSIZE)];
		for(JJ=0;JJ<2**(PSIZE-II);JJ=JJ+1)begin
			always@(*)begin
				test0[II][JJ]	= test_in [II][(ASIZE+BSIZE)  *JJ +: (ASIZE+BSIZE)];
				test1[II][JJ]	= test_out[II][(ASIZE+BSIZE)  *JJ +: (ASIZE+BSIZE)];
			end
		end
	end
endgenerate

endmodule


