`timescale 1ns/100ps
import SystemVerilogCSP::*;

module two_d_mesh(interface filter_in, filter_out, ifmap_in,ifmap_out,PE1_in, PE1_out,PE2_in, PE2_out,PE3_in, PE3_out,PE4_in, PE4_out,PE5_in, PE5_out,PE6_in, PE6_out,PE7_in, PE7_out,PE8_in, PE8_out,PE9_in, PE9_out,PE10_in, PE10_out,sum1_in,sum1_out,sum2_in,sum2_out,sum3_in,sum3_out,ofm_in,ofm_out);

parameter WIDTH=35;

Channel #(.hsProtocol(P4PhaseBD),.WIDTH(WIDTH)) intf[111:0]();//79:0
//nterface N_in, interface N_out, interface E_in, interface E_out, interface W_in, interface W_out, interface S_in, interface S_out, interface PE_in, interface PE_out
router #(.WIDTH(35)) r1(.N_in(intf[80]), .N_out(intf[81]), .W_in(intf[82]), .W_out(intf[83]), .E_in(intf[69]), .E_out(intf[68]), .S_in(intf[58]), .S_out(intf[59]), .PE_in(sum1_out), .PE_out(sum1_in));

router #(.WIDTH(35)) r2(.N_in(intf[84]), .N_out(intf[85]), .W_in(intf[68]), .W_out(intf[69]), .E_in(intf[73]), .E_out(intf[72]), .S_in(intf[60]), .S_out(intf[61]), .PE_in(sum2_out), .PE_out(sum2_in));

router #(.WIDTH(35)) r3(.N_in(intf[86]), .N_out(intf[87]), .W_in(intf[72]), .W_out(intf[73]), .E_in(intf[77]), .E_out(intf[76]), .S_in(intf[62]), .S_out(intf[63]), .PE_in(sum3_out), .PE_out(sum3_in));

router #(.WIDTH(35)) r4(.N_in(intf[88]), .N_out(intf[89]), .W_in(intf[76]), .W_out(intf[77]), .E_in(intf[90]), .E_out(intf[91]), .S_in(intf[64]), .S_out(intf[65]), .PE_in(ofm_out), .PE_out(ofm_in));

router #(.WIDTH(35)) r5(.N_in(intf[59]), .N_out(intf[58]), .W_in(intf[92]), .W_out(intf[93]), .E_in(intf[47]), .E_out(intf[46]), .S_in(intf[36]), .S_out(intf[37]), .PE_in(PE7_out), .PE_out(PE7_in));

router #(.WIDTH(35)) r6(.N_in(intf[61]), .N_out(intf[60]), .W_in(intf[46]), .W_out(intf[47]), .E_in(intf[51]), .E_out(intf[50]), .S_in(intf[38]), .S_out(intf[39]), .PE_in(PE8_out), .PE_out(PE8_in));

router #(.WIDTH(35)) r7(.N_in(intf[63]), .N_out(intf[62]), .W_in(intf[50]), .W_out(intf[51]), .E_in(intf[55]), .E_out(intf[54]), .S_in(intf[40]), .S_out(intf[41]), .PE_in(PE9_out), .PE_out(PE9_in));

router #(.WIDTH(35)) r8(.N_in(intf[65]), .N_out(intf[64]), .W_in(intf[54]), .W_out(intf[55]), .E_in(intf[94]), .E_out(intf[95]), .S_in(intf[42]), .S_out(intf[43]), .PE_in(PE10_out), .PE_out(PE10_in));

router #(.WIDTH(35)) r9(.N_in(intf[37]), .N_out(intf[36]), .W_in(intf[96]), .W_out(intf[97]), .E_in(intf[25]), .E_out(intf[24]), .S_in(intf[14]), .S_out(intf[15]), .PE_in(PE3_out), .PE_out(PE3_in));

router #(.WIDTH(35)) r10(.N_in(intf[39]), .N_out(intf[38]), .W_in(intf[24]), .W_out(intf[25]), .E_in(intf[29]), .E_out(intf[28]), .S_in(intf[16]), .S_out(intf[17]), .PE_in(PE4_out), .PE_out(PE4_in));

router #(.WIDTH(35)) r11(.N_in(intf[41]), .N_out(intf[40]), .W_in(intf[28]), .W_out(intf[29]), .E_in(intf[33]), .E_out(intf[32]), .S_in(intf[18]), .S_out(intf[19]), .PE_in(PE5_out), .PE_out(PE5_in));

router #(.WIDTH(35)) r12(.N_in(intf[43]), .N_out(intf[42]), .W_in(intf[32]), .W_out(intf[33]), .E_in(intf[98]), .E_out(intf[99]), .S_in(intf[20]), .S_out(intf[21]), .PE_in(PE6_out), .PE_out(PE6_in));

router #(.WIDTH(35)) r13(.N_in(intf[15]), .N_out(intf[14]), .W_in(intf[100]), .W_out(intf[101]), .E_in(intf[3]), .E_out(intf[2]), .S_in(intf[102]), .S_out(intf[103]), .PE_in(ifmap_out), .PE_out(ifmap_in));

router #(.WIDTH(35)) r14(.N_in(intf[17]), .N_out(intf[16]), .W_in(intf[2]), .W_out(intf[3]), .E_in(intf[7]), .E_out(intf[6]), .S_in(intf[104]), .S_out(intf[105]), .PE_in(filter_out), .PE_out(filter_in));

router #(.WIDTH(35)) r15(.N_in(intf[19]), .N_out(intf[18]), .W_in(intf[6]), .W_out(intf[7]), .E_in(intf[11]), .E_out(intf[10]), .S_in(intf[106]), .S_out(intf[107]), .PE_in(PE1_out), .PE_out(PE1_in));

router #(.WIDTH(35)) r16(.N_in(intf[21]), .N_out(intf[20]), .W_in(intf[10]), .W_out(intf[11]), .E_in(intf[108]), .E_out(intf[109]), .S_in(intf[110]), .S_out(intf[111]), .PE_in(PE2_out), .PE_out(PE2_in));
endmodule	