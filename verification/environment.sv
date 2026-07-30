//=========================================================
// Environment Class : Digital Clock with Alarm
//=========================================================

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"


class environment;

  // Verification Components

  generator   gen;
  driver      driv;
  monitor     mon;
  scoreboard  scb;


  // Mailboxes

  mailbox gen2driv;
  mailbox mon2scb;


  // Virtual Interface

  virtual intf vif;


  //=======================================================
  // Constructor
  //=======================================================

  function new(virtual intf vif);

    this.vif = vif;


    // Create mailboxes

    gen2driv = new();
    mon2scb  = new();


    // Create components

    gen  = new(gen2driv);

    driv = new(vif, gen2driv);

    mon  = new(vif, mon2scb);

    scb  = new(mon2scb);


  endfunction



  //=======================================================
  // Pre Test
  //=======================================================

  task pre_test();

    driv.reset();

  endtask



  //=======================================================
  // Test
  //=======================================================

task test();

    fork

        gen.main();

        driv.main();

        mon.main();

        scb.main();


    join_none


endtask


  //=======================================================
  // Post Test
  //=======================================================

  task post_test();


    wait(gen.ended.triggered);


    wait(gen.repeat_count == driv.no_transactions);


    wait(gen.repeat_count == scb.no_transactions);



    $display("------------------------------------");

    $display(" ALL TRANSACTIONS COMPLETED ");

    $display("------------------------------------");



    #100;


endtask


  //=======================================================
  // Run
  //=======================================================

  task run();


    pre_test();

    test();

    post_test();


    $finish;


  endtask


endclass
