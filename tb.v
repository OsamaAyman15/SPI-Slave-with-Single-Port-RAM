module tb();
    reg clk,rst_n,MOSI_tb,SS_n;
    wire MISO_dut;

    reg [7:0]address;
    reg [7:0]data;
    reg [7:0]dummy_data;

    //instentiation
    /**/
    top top1(clk,rst_n,SS_n,MOSI_tb,MISO_dut);

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        address = 8'b11111110; //254
        data = 8'haa;   //aa in hex
        dummy_data = 8'b11110000; //F0
    end

    integer i;
    initial begin
        //init memory
        $readmemh("mem.dat",top1.m2.mem);
        
        rst_n = 0;
        MOSI_tb=1; 
        SS_n=0;
        @(negedge clk);
        for (i = 0; i<5 ; i=i+1 ) begin //reset  (MISO should be x)
            MOSI_tb=$random;  
            SS_n=$random;
            @(negedge clk);
        end
        rst_n = 1;
        
        //check write condition
        SS_n = 0;
        @(negedge clk);
        MOSI_tb = 0; //write 
        @(negedge clk);

        MOSI_tb = 0;
        @(negedge clk);
        MOSI_tb = 0;  //write addr
        @(negedge clk)
        for (i = 0; i<8 ; i=i+1) begin  //enter serial address on mosi 
            MOSI_tb = address[7-i]; //most to least
            @(negedge clk);
        end

        SS_n = 1;
        @(negedge clk);
        SS_n = 0;
        @(negedge clk);
        MOSI_tb = 0; 
        @(negedge clk);

        MOSI_tb = 0;
        @(negedge clk);
        MOSI_tb = 1;  //write data
        @(negedge clk)
        for (i = 0; i<8 ; i=i+1) begin  //enter serial data on mosi 
            MOSI_tb = data[7-i];
            @(negedge clk);
        end

        //check read condition
        SS_n = 1;
        @(negedge clk);
        SS_n = 0;
        @(negedge clk);
        MOSI_tb = 1; 
        @(negedge clk);

        MOSI_tb = 1;
        @(negedge clk);
        MOSI_tb = 0;  //read addr
        @(negedge clk)
        for (i = 0; i<8 ; i=i+1) begin  //enter serial read address on mosi 
            MOSI_tb = address[7-i];
            @(negedge clk);
        end

        SS_n = 1;
        @(negedge clk);
        SS_n = 0;
        @(negedge clk);
        MOSI_tb = 1; 
        @(negedge clk);

        MOSI_tb = 1;
        @(negedge clk);
        MOSI_tb = 1;  //read data
        @(negedge clk);
        for (i = 0; i<8 ; i=i+1) begin  //enter serial data on mosi 
            MOSI_tb = dummy_data[7-i]; //dummy data
            @(negedge clk);
        end

        //out serial data on miso
        SS_n = 0;
        for (i = 0; i<10 ; i=i+1) begin //make recieved data serial on miso 
            @(negedge clk);
        end
        $stop;
    end

endmodule 