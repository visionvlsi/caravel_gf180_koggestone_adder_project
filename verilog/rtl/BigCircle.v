module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
  
  wire e;
  and  (e, Pi, GiPrev);
  or  (G, e, Gi);
  and  (P, Pi, PiPrev);
  
endmodule
