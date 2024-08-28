`timescale 1ns/100ps
import SystemVerilogCSP::*;

module Sum_Threshold1 (interface in, out);
parameter WIDTH = 35;
parameter FL= 2, BL = 1;
parameter threshold = 64;

parameter sum_addr = 4'b0011;//s&t1_addr=4'b0011;
parameter pe1_addr = 4'b1000;
parameter pe2_addr = 4'b1100;
parameter pe3_addr = 4'b0001;
parameter pe4_addr = 4'b0101;
parameter pe5_addr = 4'b1001;
parameter pe6_addr = 4'b1101;
parameter pe7_addr = 4'b0010;
parameter pe8_addr = 4'b0110;
parameter pe9_addr = 4'b1010;
parameter pe10_addr = 4'b1110;
parameter res_addr = 4'b1111;
parameter res_zeros = {14{1'b0}};

logic [1:0]tstep2 = 0;

logic [WIDTH-1:0]value;
logic [7:0]pe1_value, pe2_value, pe3_value, pe4_value, pe5_value, pe6_value, pe7_value, pe8_value, pe9_value, pe10_value;
logic [7:0]Add_value;
logic [7:0]res_value;
logic [7:0]new_value;
logic output_spike;
logic [WIDTH-1:0]packet_out;
logic [9:0]counter=0;//counter for map1 to show timestep1 and 2
logic [3:0]counter_receive=0;
always begin
	if(tstep2==0)begin
    in.Receive(value);
	#FL;
		if (value[WIDTH-9:WIDTH-12]==pe1_addr)
		begin 
			pe1_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe2_addr)
		begin 
			pe2_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe3_addr)
		begin 
			pe3_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe4_addr)
		begin 
			pe4_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe5_addr)
		begin 
			pe5_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe6_addr)
		begin 
			pe6_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe7_addr)
		begin 
			pe7_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe8_addr)
		begin 
			pe8_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe9_addr)
		begin 
			pe9_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe10_addr)
		begin 
			pe10_value = value[7:0];
			counter_receive=counter_receive+1;
		end
		$display("pe1_value:%b---pe2_value:%b---pe3_value:%b---pe4_value:%b---pe5_value:%b---pe6_value:%b---pe7_value:%b---pe8_value:%b---pe9_value:%b---pe10_value:%b in %m", pe1_value,pe2_value,pe3_value,pe4_value,pe5_value,pe6_value,pe7_value,pe8_value,pe9_value,pe10_value);
		if(counter_receive==10)begin
			$display("%m receive all data from PE1 to PE10 in %m");
			Add_value = pe1_value + pe2_value + pe3_value + pe4_value + pe5_value + pe6_value + pe7_value + pe8_value + pe9_value + pe10_value;
			$display("Add value in map 1:%b in %m", Add_value);
		//Threshold
			if (Add_value>=threshold) begin
				output_spike = 1;
				new_value = Add_value - threshold;
			end
			else if(Add_value<threshold)begin
				output_spike = 0;
				new_value = Add_value;
			end
			packet_out = {sum_addr, res_addr,sum_addr,output_spike, res_zeros, new_value};//4+4+4+1+14+8=35 bits
			$display("Send packet to OFM from %m");
			out.Send(packet_out);
			counter=counter+1'b1;
			$display("counter number %d is in %m",counter);
			counter_receive=0;
			
		#BL;
		end
		if(counter==280)begin//trst
		counter=0;
		tstep2=1;
		counter_receive=0;
		//end
		end
	end	
    if(tstep2==1)begin
		in.Receive(value);
		if(value[WIDTH-9:WIDTH-12]==res_addr)begin
			res_value=value[7:0];
			counter_receive=counter_receive+1;
		end
		#FL;
		if (value[WIDTH-9:WIDTH-12]==pe1_addr)
		begin 
			pe1_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe2_addr)
		begin 
			pe2_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe3_addr)
		begin 
			pe3_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe4_addr)
		begin 
			pe4_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe5_addr)
		begin 
			pe5_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe6_addr)
		begin 
			pe6_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe7_addr)
		begin 
			pe7_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe8_addr)
		begin 
			pe8_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe9_addr)
		begin 
			pe9_value = value[7:0];
			counter_receive=counter_receive+1;
		end

		if (value[WIDTH-9:WIDTH-12]==pe10_addr)
		begin 
			pe10_value = value[7:0];
			counter_receive=counter_receive+1;
		end
		$display("pe1_value:%b---pe2_value:%b---pe3_value:%b---pe4_value:%b---pe5_value:%b---pe6_value:%b---pe7_value:%b---pe8_value:%b---pe9_value:%b---pe10_value:%b --res_value %b in %m", pe1_value,pe2_value,pe3_value,pe4_value,pe5_value,pe6_value,pe7_value,pe8_value,pe9_value,pe10_value,res_value);
		//if(flag1&&flag2&&flag3&&flag4&&flag5&&flag6&&flag7&&flag8&&flag9&&flag10&&flag11)begin
		if(counter_receive==11)begin
			$display("%m receiveresidue from Residue MEM");
			Add_value = pe1_value + pe2_value + pe3_value + pe4_value + pe5_value + pe6_value + pe7_value + pe8_value + pe9_value + pe10_value + res_value;
				$display("Add value in map 2:%b in %m", Add_value);
			if(Add_value>=threshold) begin
				output_spike = 1;
				new_value = Add_value - threshold;
			end
			if(Add_value<threshold)begin
				output_spike = 0;
				new_value = Add_value;
			end
			packet_out = {sum_addr, res_addr, sum_addr,output_spike, res_zeros, new_value};//4+4+4+1+14+8=35 bits
			out.Send(packet_out);
			counter=counter+1'b1;
			counter_receive=0;
			$display("counter number %d is in %m",counter);
		end	
		#BL;
		if(counter==280)begin
			counter=0;
		end
	end
end
endmodule

    




    

    

    
    
