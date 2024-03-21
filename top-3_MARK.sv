module top;

bit CLK = '0;
bit RESET = '0;

logic [3:0] CS;
//modules instantiation
Intel8088Pins i (.*);
Intel8088 P (.i(i.Processor));
IOM_Module #(0, 20'h7ffff, 20'h80000, 20'hfffff, 16'hff00, 16'hff0f, 16'h1c00, 16'h1dff) m0(i.Pheripheral, CS);
IOM_Module #(0, 20'h7ffff, 20'h80000, 20'hfffff, 16'hff00, 16'hff0f, 16'h1c00, 16'h1dff) m1(i.Pheripheral, CS);
IOM_Module #(1, 20'h7ffff, 20'h80000, 20'hfffff, 16'hff00, 16'hff0f, 16'h1c00, 16'h1dff) io0(i.Pheripheral, CS);
IOM_Module #(1, 20'h7ffff, 20'h80000, 20'hfffff, 16'hff00, 16'hff0f, 16'h1c00, 16'h1dff) io1(i.Pheripheral, CS);


always_latch
begin
if (i.ALE)
	i.Address <= {i.A, i.AD};
end

// 8286 transceiver
assign i.Data =  (i.DTR & ~i.DEN) ? i.AD   : 'z;
assign i.AD   = (~i.DTR & ~i.DEN) ? i.Data : 'z;


//chip selction logic
always_comb
	begin
	CS= 4'b0000;

	if (!i.Address[19] && !i.IOM)
		CS[0] = 1'd1;
	else if (i.Address[19] && !i.IOM)
		CS[1] = 1'd1;
	else if (i.IOM && i.Address[15:4] == 12'hFF0)
		CS[2] = 1'd1;
	else if (i.IOM && i.Address[15:9] == 7'h0E)
		CS[3] = 1'd1;
	end

always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(10000) @(posedge CLK);
$finish();
end

endmodule
