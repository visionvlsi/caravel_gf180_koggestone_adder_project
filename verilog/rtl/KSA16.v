`default_nettype none

module Triangle(output Si, input Pi, CiPrev);
  
  xor  (Si, Pi, CiPrev);
  
endmodule


module KSA16(output [15:0] sum, output cout, input [15:0] a, b);
  
  //Definition of the Power Pins

`ifdef USE_POWER_PINS
	inout vdd, //User area 1 1.8V Supply
	inout vss, //User area 1 digital ground
`endif
  
  wire cin = 1'b0;
  wire [15:0] c;
  wire [15:0] g, p;
    
    
    
    genvar i,j;
    generate for(i=0; i<16; i=i+1) begin : test1
  //Square sq[15:0](g, p, a, b);
        Square sq(g[i], p[i], a[i], b[i]);
    end
    endgenerate

  // first line of circles
  wire [15:1] g2, p2;
  SmallCircle sc0_0(c[0], g[0]);
 
    generate for(j=1; j<16; j=j+1) begin : test2
  //BigCircle bc0[15:1](g2[15:1], p2[15:1], g[15:1], p[15:1], g[14:0], p[14:0]);
        BigCircle bc0(g2[j], p2[j], g[j], p[j], g[j-1], p[j-1]);
    end
    endgenerate

  // second line of circle
  wire [15:3] g3, p3;
    genvar k;
    generate for(k=1; k<3; k=k+1) begin : test2
  //SmallCircle sc1[2:1](c[2:1], g2[2:1]);
        SmallCircle sc1(c[k], g2[k]);
    end
    endgenerate

    genvar i1;
    generate for(i1=3;i1<16;i1=i1+1) begin: test3
  //BigCircle bc1[15:3](g3[15:3], p3[15:3], g2[15:3], p2[15:3], g2[13:1], p2[13:1]);
        BigCircle bc1(g3[i1], p3[i1], g2[i1], p2[i1], g2[i1-2], p2[i1-2]);
    end
    endgenerate
  // third line of circle
  wire [15:7] g4, p4;
  
    genvar j1;
    generate for(j1=3; j1<7; j1=j1+1) begin:test4
  //SmallCircle sc2[6:3](c[6:3], g3[6:3]);
        SmallCircle sc2(c[j1], g3[j1]);
    end
    endgenerate
    genvar k1;
    generate for(k1=7; k1<16; k1=k1+1) begin:test5
  //BigCircle bc2[15:7](g4[15:7], p4[15:7], g3[15:7], p3[15:7], g3[11:3], p3[11:3]);
        BigCircle bc2(g4[k1], p4[k1], g3[k1], p3[k1], g3[k1-4], p3[k1-4]);
    end
    endgenerate

  // fourth line of circle
  wire [15:15] g5, p5;
  
    genvar m1,m2;
    generate for(m1=7; m1<15; m1=m1+1) begin:test6

  //SmallCircle sc3[14:7](c[14:7], g4[14:7]);
        SmallCircle sc3(c[m1], g4[m1]);
    end
        endgenerate

  BigCircle bc3_15(g5[15], p5[15], g4[15], p4[15], g4[7], p4[7]);  

  // fifth line of circle
  SmallCircle sc4_15(c[15], g5[15]);

  // last line - triangles
  Triangle tr0(sum[0], p[0], cin);
  //Triangle tr[15:1](sum[15:1], p[15:1], c[14:0]);
    generate for(m2=1; m2<16; m2=m2+1) begin:test7
  //Triangle tr[15:1](sum[15:1], p[15:1], c[14:0]);
        Triangle tr1(sum[m2], p[m2], c[m2-1]);
    end
    endgenerate

  // generate cout
 // buf (cout, c[15]);
    assign cout=c[15];
endmodule
`default_nettype wire
