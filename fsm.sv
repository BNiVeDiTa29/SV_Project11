module IOM_Module(Intel8088Pins.Pheripheral bus, input [3:0] CS);
parameter IOM = 0, mem0size, mem1sizel, mem1sizeh, io0sizel, io0sizeh, io1sizel, io1sizeh; // 0 memory and 1 io device
logic OE, WREN, ADDR_LOAD;

typedef enum logic[0:4]{
	IDLE = 5'b00001,
	LOAD = 5'b00010,
	READ = 5'b00100,
	WRITE= 5'b01000,
	WAIT = 5'b10000
	} State;
	
	State CurrentState, NextState;
logic [19:0] Address_reg;

reg [7:0] mem0[mem0size : 0];
reg [7:0] mem1[mem1sizeh : mem1sizel];
reg [7:0] io0[io0sizeh : io0sizel];
reg [7:0] io1[io1sizeh : io1sizel];



initial
	begin
		$readmemh("MEM_CONTENTS1.txt",mem0);
		$readmemh("MEM_CONTENTS2.txt",mem1);
		$readmemh("MEM_CONTENTS3.txt",io0);
		$readmemh("MEM_CONTENTS4.txt",io1);
	end
		
//sequential logic
always_ff@(posedge bus.CLK)
begin
	if (bus.RESET)
		CurrentState <= IDLE;
	else
		CurrentState <= NextState;
end

//next state logic
always_comb
begin
	NextState = CurrentState;
	case(CurrentState)
	IDLE	:	if((CS == 4'b1000 || CS == 4'b0100 || CS == 4'b0010 || CS ==4'b0001) && bus.ALE)
					begin
						NextState = LOAD;
					end
				else
					begin
						NextState = IDLE;
					end
				
	LOAD	:	if(!bus.RD)
					begin
						NextState = READ;
					end
				else if(!bus.WR)
					begin
						NextState = WRITE;
					end
				else
					begin
						NextState = LOAD;
					end
		
	READ	:	begin
						NextState = WAIT;
				end
	
	WRITE	:	begin
						NextState = WAIT;
				end
	
	WAIT	:	begin
						NextState = IDLE;
				end
	endcase
end

//output combinational logic
always_comb
begin
	{OE,WREN,ADDR_LOAD} = 3'b000;
	case(CurrentState)
	IDLE	:	begin
				end
	
	LOAD	:	begin
					ADDR_LOAD = 1'd1;
				end
	
	READ	:	begin
					OE = 1'd1;
				end

	WRITE	:	begin
					WREN = 1'd1;
				end
				
	WAIT	:	begin
				end
	endcase
end

//latching Address into Address Register
always_latch
begin
	if (ADDR_LOAD)
		Address_reg <= bus.Address;
end

//Memory or IO registers
assign bus.Data = (OE & CS[0] & ~IOM) ? mem0[Address_reg] : 'z;
assign bus.Data = (OE & CS[1] & ~IOM) ? mem1[Address_reg] : 'z;
assign bus.Data = (OE & CS[2] & IOM) ? io0[Address_reg] : 'z;
assign bus.Data = (OE & CS[3] & IOM) ? io1[Address_reg] : 'z;

always @(posedge bus.CLK)
	begin
		if(WREN)
			begin
				if(CS[0] == 1 && IOM == 1'd0)
					mem0[Address_reg] = bus.Data;
				if(CS[1] == 1 && IOM == 1'd0)
					mem1[Address_reg] = bus.Data;
				if(CS[2] == 1 && IOM == 1'd1)
					io0[Address_reg] = bus.Data;
				if(CS[3] == 1 && IOM == 1'd1)
					io1[Address_reg] = bus.Data;
			end
	end
	
	
final
	begin
		if(CS[0] == 1)
			$display("Device 0 = %p", mem0);
		if(CS[1] == 1)
			$display("Device 0 = %p", mem1);
		if(CS[2] == 1)
			$display("Device 0 = %p", io0);
		if(CS[3] == 1)
			$display("Device 0 = %p", io1);
		
	end
endmodule
