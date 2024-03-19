module IOM_Module0(Intel8088Pins.Pheripheral0 bus);

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
reg [7:0] mem[(2**20)-1 : 0];

initial
	begin
		$readmemh("MEM_CONTENTS.txt",mem);
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
	IDLE	:	if(bus.CS1 && bus.ALE)
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

//output logic
always_comb
begin
	{OE,WREN,ADDR_LOAD} = 3'b000;
	case(CurrentState)
	IDLE	:	begin
				end
	
	LOAD	:	begin
					ADDR_LOAD = 1;
				end
	
	READ	:	begin
					OE = 1;
				end

	WRITE	:	begin
					WREN = 1;
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
assign bus.Data = (OE) ? mem[Address_reg] : 8'bzzzzzzzz;

always @(posedge bus.CLK)
	begin
		if(WREN)
			mem[Address_reg] <= bus.Data;
	end
	
	
/*final
	begin
		$display("Device 0 = %p", mem);
	end*/
endmodule

module IOM_Module1(Intel8088Pins.Pheripheral1 bus);

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
reg [7:0] mem[(2**20)-1 : 0];

initial
	begin
		$readmemh("MEM_CONTENTS.txt",mem);
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
	IDLE	:	if(bus.CS2 && bus.ALE)
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

//output logic
always_comb
begin
	{OE,WREN,ADDR_LOAD} = 3'b000;
	case(CurrentState)
	IDLE	:	begin
				end
	
	LOAD	:	begin
					ADDR_LOAD = 1;
				end
	
	READ	:	begin
					OE = 1;
				end

	WRITE	:	begin
					WREN = 1;
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
assign bus.Data = (OE) ? mem[Address_reg] : 8'bzzzzzzzz;

always @(posedge bus.CLK)
	begin
		if(WREN)
			mem[Address_reg] <= bus.Data;
	end
	
/*final
	begin
		$display("Device 1 = %p", mem);
	end*/
endmodule

module IOM_Module2(Intel8088Pins.Pheripheral2 bus);

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
reg [7:0] mem[(2**20)-1 : 0];

initial
	begin
		$readmemh("MEM_CONTENTS.txt",mem);
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
	IDLE	:	if(bus.CS3 && bus.ALE)
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

//output logic
always_comb
begin
	{OE,WREN,ADDR_LOAD} = 3'b000;
	case(CurrentState)
	IDLE	:	begin
				end
	
	LOAD	:	begin
					ADDR_LOAD = 1;
				end
	
	READ	:	begin
					OE = 1;
				end

	WRITE	:	begin
					WREN = 1;
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
assign bus.Data = (OE) ? mem[Address_reg] : 8'bzzzzzzzz;

always @(posedge bus.CLK)
	begin
		if(WREN)
			mem[Address_reg] <= bus.Data;
	end
	
/*final
	begin
		$display("Device 2 = %p", mem);
	end*/
endmodule

module IOM_Module3(Intel8088Pins.Pheripheral3 bus);

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
reg [7:0] mem[(2**20)-1 : 0];

initial
	begin
		$readmemh("MEM_CONTENTS.txt",mem);
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
	IDLE	:	if(bus.CS4 && bus.ALE)
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

//output logic
always_comb
begin
	{OE,WREN,ADDR_LOAD} = 3'b000;
	case(CurrentState)
	IDLE	:	begin
				end
	
	LOAD	:	begin
					ADDR_LOAD = 1;
				end
	
	READ	:	begin
					OE = 1;
				end

	WRITE	:	begin
					WREN = 1;
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
assign bus.Data = (OE) ? mem[Address_reg] : 8'bzzzzzzzz;

always @(posedge bus.CLK)
	begin
		if(WREN)
			mem[Address_reg] <= bus.Data;
	end
	
/*final
	begin
		$display("Device 3 = %p", mem);
	end*/
endmodule
