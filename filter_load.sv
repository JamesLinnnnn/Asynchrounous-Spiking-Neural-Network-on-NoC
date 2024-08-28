`timescale 1ns/1fs

import SystemVerilogCSP::*;
//filter source addres is 0111(1,3)
module filter_load(interface load_start,interface filter_data,interface filter_addr, interface in,interface out);


parameter FL=2;
parameter BL=1;
parameter WIDTH=35;//the packet size
parameter data_size=8;// the data size in filter is 8 bit
//Address
parameter filter_addrr=4'b0100;// the position of filter in 4X4 mesh
// PEs address in 4X4 mesh
parameter PE1_addr=4'b1000;
parameter PE2_addr=4'b1100;
parameter PE3_addr=4'b0001;
parameter PE4_addr=4'b0101;
parameter PE5_addr=4'b1001;
parameter PE6_addr=4'b1101;
parameter PE7_addr=4'b0010;
parameter PE8_addr=4'b0110;
parameter PE9_addr=4'b1010;
parameter PE10_addr=4'b1110;

logic flag1,flag2;// if flag==1, which means receiving load_start value 1, starts to store data in 2-d memory with addresses
logic [11:0]row,col;//row and column count in receiving data
logic [4:0]row_cnt;//row count in sending data
logic [data_size-1:0]filter_mem[4:0][4:0];//stored filter memory
logic [4:0]addr;// for receiving address from filter_addr interface
logic [7:0]data;//for receiving data from filter_data interface
logic [4:0]counter=0;//to counter
logic [WIDTH-1:0]packet_out1;// Send packet to odd number of PEs
logic [WIDTH-1:0]packet_out2;// Send packet to even number of PEs
logic [WIDTH-1:0]done;

always begin
	load_start.Receive(flag1);
	if(flag1==1)begin
		$display("start loading filter value!");
	end	
    #FL;
	while(flag1)begin
		fork
		filter_addr.Receive(addr);
		filter_data.Receive(data);
		join
		#FL;
		row=addr/5;
		col=addr%5;
		filter_mem[row][col]=data;
		counter=counter+1;
		if(counter==25)begin
			$display("finish loading data");
			flag1=0;//RReset the flag1
			counter=0;// Reset counter to 0
		end	
	end	
    #BL;
	$display("Start sending data to PEs");
		for(row_cnt=0;row_cnt<5;row_cnt=row_cnt+1)begin
			if(row_cnt==0) begin
				packet_out1={filter_addrr,PE1_addr,3'b000,filter_mem[row_cnt][0],filter_mem[row_cnt][1],filter_mem[row_cnt][2]};
				out.Send(packet_out1);
				$display("send packet with 3 data to PE1");
				#BL;
				packet_out2={filter_addrr,PE2_addr,3'b000,filter_mem[row_cnt][3],filter_mem[row_cnt][4],8'h00};
				out.Send(packet_out2);
				$display("send packet with 3 data to PE2");
				#BL;
			end
			else if(row_cnt==1) begin
				packet_out1={filter_addrr,PE3_addr,3'b000,filter_mem[row_cnt][0],filter_mem[row_cnt][1],filter_mem[row_cnt][2]};
				out.Send(packet_out1);
				$display("send packet with 3 data to PE3");
				#BL;
				packet_out2={filter_addrr,PE4_addr,3'b000,filter_mem[row_cnt][3],filter_mem[row_cnt][4],8'h00};
				out.Send(packet_out2);
				$display("send packet with 3 data to PE4");
				#BL;
			end
			else if(row_cnt==2)	begin
				packet_out1={filter_addrr,PE5_addr,3'b000,filter_mem[row_cnt][0],filter_mem[row_cnt][1],filter_mem[row_cnt][2]};
				out.Send(packet_out1);
				$display("send packet with 3 data to PE5");
				#BL;
				packet_out2={filter_addrr,PE6_addr,3'b000,filter_mem[row_cnt][3],filter_mem[row_cnt][4],8'h00};
				out.Send(packet_out2);
				$display("send packet with 3 data to PE6");
				#BL;
			end
			else if(row_cnt==3)	begin
				packet_out1={filter_addrr,PE7_addr,3'b000,filter_mem[row_cnt][0],filter_mem[row_cnt][1],filter_mem[row_cnt][2]};
				out.Send(packet_out1);
				$display("send packet with 3 data to PE7");
				#BL;
				packet_out2={filter_addrr,PE8_addr,3'b000,filter_mem[row_cnt][3],filter_mem[row_cnt][4],8'h00};
				out.Send(packet_out2);
				$display("send packet with 3 data to PE8");
				#BL;
			end
			else if(row_cnt==4) begin
				packet_out1={filter_addrr,PE9_addr,3'b000,filter_mem[row_cnt][0],filter_mem[row_cnt][1],filter_mem[row_cnt][2]};
				out.Send(packet_out1);
				$display("send packet with 3 data to PE9");
				#BL;
				packet_out2={filter_addrr,PE10_addr,3'b000,filter_mem[row_cnt][3],filter_mem[row_cnt][4],8'h00};
				out.Send(packet_out2);
				$display("send packet with 3 data to PE10");
				#BL;
			end

		$display("Send all packets to PEs from %m");
		end	
end
endmodule	
