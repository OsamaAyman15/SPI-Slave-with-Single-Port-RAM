module top (
    clk,rst_n,SS_n,MOSI,MISO
);
    input clk,rst_n,SS_n,MOSI;
    output MISO;
    wire [9:0]din;
    wire [7:0]dout;
    wire tx_valid,rx_valid;

    spi m1(MOSI,MISO,SS_n,clk,rst_n,din,rx_valid,dout,tx_valid);
    ram m2(clk,rst_n,din,rx_valid,dout,tx_valid);
    
endmodule //top