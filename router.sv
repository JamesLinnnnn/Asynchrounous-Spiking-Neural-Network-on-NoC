`timescale 1ns/1fs

import SystemVerilogCSP::*;

module router(interface N_in, interface N_out, interface E_in, interface E_out, interface W_in, interface W_out, interface S_in, interface S_out, interface PE_in, interface PE_out);


// Internal out from North
Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) Eout_N(),  Wout_N(),Sout_N(),PEout_N();
// Internal out from East
Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) Nout_E(),  Wout_E(),Sout_E(),PEout_E();
// Internal out from West
Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) Nout_W(), Eout_W(),Sout_W(),PEout_W();
// Internal out from South
Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) Nout_S(), Eout_S(),  Wout_S(),PEout_S();
// Internal out from PE
Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) Nout_PE(), Eout_PE(),  Wout_PE(),Sout_PE();

parameter FL=2;
parameter BL=1;
parameter WIDTH=35;

//Router
router_dir_N routt1(N_in,Eout_N, Wout_N,Sout_N, PEout_N);
router_dir_E routt2(E_in,Nout_E,Wout_E,Sout_E,PEout_E);
router_dir_W routt3(W_in,Nout_W, Eout_W, Sout_W,PEout_W);
router_dir_S routt4(S_in,Nout_S, Eout_S,Wout_S,PEout_S);
router_dir_PE routt5(PE_in,Nout_PE, Eout_PE, Wout_PE, Sout_PE);

//  Output Arbiter with buffers
//NORTH
arbiter_four arb_N(Nout_E,Nout_W,Nout_S,Nout_PE,N_out);
//East
arbiter_four arb_E(Eout_N,Eout_W,Eout_S,Eout_PE, E_out);
//West
arbiter_four arb_W(Wout_N,Wout_E, Wout_S,Wout_PE,W_out);
//South
arbiter_four arb_S(Sout_N,Sout_E,Sout_W,Sout_PE,S_out);
//PE
arbiter_four arb_PE(PEout_N,PEout_E,PEout_W,PEout_S,PE_out);

endmodule