/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	
--Version:VERA.1.0.0
--Data modified:2015/5/18 13:45:49
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:2015/5/15
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module mult_add_tb;

parameter 	DSIZE	= 8;
parameter	NUM		= 6;	//try 2 3 4 5 6 7
parameter 	WSIZE	= DSIZE*NUM;

bit			clock	= 0;
bit			rst_n	= 0;

always #5 clock	= ~clock;
initial begin
	repeat(10) @(posedge clock);
	rst_n	= 1;
end

logic [DSIZE-1:0] indata [NUM-1:0];
logic [DSIZE:0]	outdata [NUM/2 + NUM%2 -1 :0];

always@(posedge clock)begin:GEN_IN_DATA
integer II;
	for(II=0;II<NUM;II=II+1)
		indata[II]	<= {$random} % 64;
//		indata[II]	<= II*10;
end

logic [WSIZE-1:0]	ind;
logic [(DSIZE+1)*(NUM/2 + NUM%2)-1:0] outd;

mult_add #(
	.DSIZE	(DSIZE),
	.WSIZE	(WSIZE)
)mult_add_inst(
	.clk	(clock),
	.rst_n  (rst_n),	
	.wdata  (ind),
	.odata	(outd)
);

genvar II;
generate
for(II=0;II<NUM;II+=1)
	assign	ind[(II+1)*DSIZE-1:II*DSIZE] 	= indata[II];
for(II=0;II<(NUM/2 + NUM%2);II+=1)
	assign	outdata[II]	= outd[II*(DSIZE+1)+:(DSIZE+1)];
endgenerate


//-----test--------


logic [DSIZE:0]	cul_data [NUM/2 + NUM%2 -1 :0];
always@(posedge clock)begin:TEST_BLOCK
integer II;
    if(rst_n)begin
	for(II=0;II<(NUM/2 + 0);II+=1)
	    cul_data[II]	<= indata[II*2]+indata[II*2+1];
	if(NUM%2 == 1)
	    cul_data[NUM/2 + NUM%2 -1]  <= indata[NUM-1]+1'b0;
    end else begin
	for(II=0;II<(NUM/2 + 0);II+=1)
	    cul_data[II]	<= 0;
	if(NUM%2 == 1)
	    cul_data[NUM/2 + NUM%2 -1]  <= 0;
    end
end:TEST_BLOCK

always@(posedge clock)begin:DIS_BLOCK
integer II;
    if(rst_n)begin
	$display("============================================================");
	for(II=0;II<(NUM/2 + NUM%2);II++)begin
	    $write("%3d : calculate results => %4d    add block results => %4d",II,cul_data[II],outdata[II]);	    
	    if(cul_data[II] != outdata[II])begin
		$write("   >>>>ERROR<<<<\n");
		$stop;
	    end else
		$write("   >>>>CURRECT<<<<\n");
	end
    end
end

    
    



endmodule


	
