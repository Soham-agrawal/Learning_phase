// Let's declare a new class called "ABC" with a single variable that
// can be randomized. We want this variable to have values between 2 and 6.
// when randomized. This is achieved by a constraint called "c_mode" (you
// can name it anything else).
class ABC;
    rand bit [3:0] mode;

    constraint c_implicit;              // Implicit: won't error if body is missing
    extern constraint c_explicit;       // Explicit: will error if body is missing
endclass

// This is an external constraint because it is outside
// the class-endclass body of the class. The constraint
// is reference using ::
constraint ABC::c_implicit { mode > 2; }
constraint ABC::c_explicit { mode <= 6; }

module tb;
	ABC abc;

	initial begin
      	// Create a new object with this handle
		abc = new();

      	// In a for loop, lets randomize this class handle
      	// 5 times and see how the value of mode changes
        // A class can be randomized by calling its "randomize()"
		for (int i = 0; i < 5; i++) begin
			abc.randomize();
          $display ("mode = 0x%0h", abc.mode);
		end
	end
endmodule
