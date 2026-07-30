//=========================================================
// Test Class : Digital Clock with Alarm
//=========================================================

`include "environment.sv"


program test (intf i_intf);


  // Environment handle

  environment env;


  initial begin


    // Create environment object

    env = new(i_intf);


    // Number of random transactions

    env.gen.repeat_count = 10;


    // Start test

    env.run();


  end


endprogram
