`timescale 1ns/1ns

module testbench();
    // Các tham số và biến
    reg flick, clk, rst;
    wire [15:0] led;
    
    // Gọi unit under test bound_flash
    bound_flash uut (
        .flick(flick), 
        .clk(clk), 
        .rst(rst), 
        .led(led)
    );
    
    // Khối always điều chỉnh tín hiệu clk
    always begin
        clk = 1;
        #1 clk = 0;
        #1;
    end
    
    // Khối initial điều chỉnh các tín hiệu trong unit under test
    // Kiểm tra các chức năng trong hệ thống
    initial begin
        #1 rst = 0;
        #1 rst = 1;
        
        $monitor("At %0t: clk = %b, flick = %b, led = %b", $time, clk, flick, led);
        
        $display("Testcase: normal_flow");
        #1 flick = 1;
        #1 flick = 0;
        #120;
        
        $display("Testcase: flick_kickback_led5_state3");
        flick = 1;
        #1 flick = 0;
        #34 flick = 1;
        #1 flick = 0;
        #120;
        
        $display("Testcase: flick_kickback_led10_state3");
        flick = 1;
        #1 flick = 0;
        #44 flick = 1;
        #1 flick = 0;
        #120;
        
        $display("Testcase: flick_kickback_led5_state5");
        flick = 1;
        #1 flick = 0;
        #58 flick = 1;
        #1 flick = 0;
        #70;
        
        $display("Testcase: flick_kickback_led10_state5");
        flick = 1;
        #1 flick = 0;
        #68 flick = 1;
        #1 flick = 0;
        #70;
        
        $display("Testcase: flick_led10_off (an example among many testcases for flicking at non kickback points)");
        flick = 1;
        #1 flick = 0;
        #46 flick = 1;
        #1 flick = 0;
        #80;
        
        $display("Testcase: reset_check");
        flick = 1;
        #1 flick = 0;
        #44 flick = 1;
        #1 flick = 0;
        #10 rst = 0;
        #1 rst = 1;
        #1 flick = 1;
        #1 flick = 0;
        #120;
        
        $finish;
    end
    
    // Khối initial tạo file mô phỏng biểu diễn dưới dạng sóng các tín hiệu trong testbench
    initial begin
        $recordfile("waves");
        $recordvars("depth=0", testbench);
    end
    
endmodule
