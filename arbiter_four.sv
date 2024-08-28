`timescale 1ns/1fs

import SystemVerilogCSP::*;

module arbiter_four(interface in0, interface in1, interface in2, interface in3, interface out);

Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD))  out1(),out2();

arbiter_two ar0(in0, in1, out1);
arbiter_two ar1(in2,in3,out2);
arbiter_two ar3(out1, out2,out);


endmodule