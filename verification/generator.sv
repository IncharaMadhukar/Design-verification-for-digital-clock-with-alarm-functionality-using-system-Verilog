//=========================================================
// Generator Class : Digital Clock with Alarm
//=========================================================

class generator;
// Transaction handle

rand transaction trans;


  // Number of transactions

  int repeat_count;


  // Mailbox for communication with driver

  mailbox gen2driv;


  // Event to indicate generator completion

  event ended;



  // Constructor

  function new(mailbox gen2driv);

    this.gen2driv = gen2driv;

  endfunction



  //=======================================================
  // Main Task
  //=======================================================

  task main();


    repeat(repeat_count) begin


      // Create new transaction

      trans = new();



      // Randomize transaction

      if(!trans.randomize())

        $fatal("[GENERATOR] Transaction randomization failed");



      // Display generated values

      trans.display("[GENERATOR]");



      // Send transaction to driver

      gen2driv.put(trans);


    end
        

    ->ended;


  endtask


endclass
