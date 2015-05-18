/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	
--Version:VERA.1.0.0
--Data modified:
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:2015/5/15
________________________________________________________
********************************************************/
`timescale	1ns/1ps
module mult_add #(
	parameter		DSIZE	= 10,
	parameter		WSIZE	= 100
)(
	clk		,
	rst_n   ,
	wdata   ,
	odata
);

initial begin
	if(WSIZE%DSIZE != 0)begin
		$display("ERROR:WRONG PARAMETER");
		$stop;
	end
end

localparam		WLEN	= WSIZE/DSIZE/2;
localparam		WMOD	= WSIZE/DSIZE%2; 

input					clk		;
input					rst_n   ;
input[WSIZE-1:0]		wdata   ;
output[((DSIZE+1)*(WLEN+WMOD))-1:0]	odata;



wire[DSIZE:0] sdata [(WLEN+WMOD)-1:0];

genvar II;
generate 
for(II=0;II<WLEN;II=II+1)begin:GEN_ADD
assign	sdata[II]	= wdata[(II*2)*DSIZE+:DSIZE] + wdata[((II*2)+1)*DSIZE+:DSIZE]; // [BASE+:8] == [(BASE+8)-1:BASE]
end
endgenerate

generate
if(WMOD==1)
assign	sdata[(WLEN+WMOD)-1]	= wdata[WSIZE-1:WSIZE-DSIZE];
endgenerate

reg	[DSIZE:0]	data_reg [(WLEN+WMOD)-1:0];

always@(posedge clk,negedge rst_n)begin:GEN_BLOCK
integer JJ;
	if(~rst_n)begin
		for(JJ=0;JJ<(WLEN+WMOD);JJ=JJ+1)
			data_reg[JJ]	<= {(DSIZE+1){1'b0}};
	end else begin
		for(JJ=0;JJ<(WLEN+WMOD);JJ=JJ+1)
			data_reg[JJ]	<= sdata[JJ];
end end

generate
for(II=0;II<(WLEN+WMOD);II=II+1)
//	assign odata[(II+1)*DSIZE:II*DSIZE]	= data_reg[II];
	assign odata[II*(DSIZE+1)+:(DSIZE+1)]	= data_reg[II];
endgenerate

endmodule

