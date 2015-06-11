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
--Data created: 2015/6/10 17:15:20
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module DA_multiper_tb;

reg			clock	= 1'b0;
reg			rst_n	= 1'b0;

always #5 clock	= ~clock;

initial begin
	repeat(5)	@(posedge clock);
	rst_n	= 1'b1;
end

DA_multiper #(
	.ASIZE			(8			),
	.BSIZE			(8			),		//BSIZE should be smaller than ASIZE
	.PSIZE			(3			)			// it will raise error ,if 2^PSIZE !>= BSIZE
)DA_multiper_inst(
	.clock			(clock		),
	.rst_n			(rst_n		),
	.adata			(9          ),
	.bdata			(7          ),
	.cdata			(			)
);    

endmodule


