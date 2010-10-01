require 'rbf'
require "spec"
describe "RBC" do
  before(:each) do
    @rbfc = Rbfc.new
  end

  it "should run op_cell_plus" do
    @rbfc.run('+')
    @rbfc.buffer[0].should == 1
  end

  it "should run multiple op_cell_plus" do
    @rbfc.run('+++')
    @rbfc.buffer[0].should == 3
  end

  it "should run op_cell_minus" do
    @rbfc.run('+++-')
    @rbfc.buffer[0].should == 2
  end

  it "should run op_ptr_plus" do
    @rbfc.run('+++>')
    @rbfc.buffer[@rbfc.ptr].should == 0
  end

  it "should run op_ptr_minus" do
    @rbfc.run('+++>+<')
    @rbfc.buffer[@rbfc.ptr].should == 3
  end

  it "should run hello world" do
    result = redirect_stdout do
      @rbfc.run('++++++++++[>+++++++>+++++++"+++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.')
    end
    result.should == "Hello World!\n"
  end

  it "should ignore comments" do
    result = redirect_stdout do
      @rbfc.run('++++++++++Hello world with
                 added comments
                 enjoy # # [>+++++++>+++++++"+++>+++>+<<<<-]>++.>
                 +.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.')
    end
    result.should == "Hello World!\n"
  end

  it "should match brackets" do
    #             012345678
    @rbfc.code = '[  [ ]  ]'
    @rbfc.find_matching_bracket(0).should == 8
    @rbfc.find_matching_bracket(3).should == 5
    @rbfc.find_matching_bracket(8).should == 0
    @rbfc.find_matching_bracket(5).should == 3
  end

  it "shoud interpret nested loops" do
    @rbfc.run('+++>+++<[>[>+++<-]+++<-]>>')
    @rbfc.buffer[@rbfc.ptr].should == 27
  end

  it "should run fizzbuzz" do
    result = redirect_stdout do
      @rbfc.run(
'>++++++++++[<++++++++++>-]>>>+++>+++++<<<<<[>>>>>>>+[<<<<<+<+>>>>>>-]<<<<<[>>>>>
+<<<<<-]++++++++++<[>-<-]>>+<[>[-]<[-]]>[>>>>[-]>+<<<<<-]>>>>>[<<<<<<+<+>>>>>>>-
]<<<<<<[>>>>>>+<<<<<<-]++++++++++<[>-<-]>>+<[>[-]<[-]]>[>>>>>[-]>+<<<<<<-]>>>+<<
-[<<+<+>>>-]<<<[>>>+<<<-]>>+<[>[-]<[-]]>[>+++<<+++++++[<++++++++++>-]<.>+++++[<+
++++++>-]<.>+++[<+++++>-]<++..[-]>>>>>[-]<<<-]>>-[<<<+<+>>>>-]<<<[>>>+<<<-]>+<<[
>>[-]<<[-]]>>[>>+++++<<<++++++++[<++++++++>-]<++.>++++++[<++++++++>-]<+++.+++++.
.[-]>>>>>[-]<<<-]>>>[>>>++++++++++++++++++++++++++++++++++++++++++++++++.-------
-----------------------------------------<++++++++++++++++++++++++++++++++++++++
++++++++++.------------------------------------------------<++++++++++++++++++++
++++++++++++++++++++++++++++.------------------------------------------------<-]
<<<<++++[<+++++++++++>-]<.>+++[<---->-]<.[-]<-]'
    )
    end
    result.should == '001, 002, Fizz, 004, Buzz, Fizz, 007, 008, Fizz, Buzz, 011, Fizz, 013, 014, FizzBuzz, ' +
                     '016, 017, Fizz, 019, Buzz, Fizz, 022, 023, Fizz, Buzz, 026, Fizz, 028, 029, FizzBuzz, ' +
                     '031, 032, Fizz, 034, Buzz, Fizz, 037, 038, Fizz, Buzz, 041, Fizz, 043, 044, FizzBuzz, ' +
                     '046, 047, Fizz, 049, Buzz, Fizz, 052, 053, Fizz, Buzz, 056, Fizz, 058, 059, FizzBuzz, ' +
                     '061, 062, Fizz, 064, Buzz, Fizz, 067, 068, Fizz, Buzz, 071, Fizz, 073, 074, FizzBuzz, ' +
                     '076, 077, Fizz, 079, Buzz, Fizz, 082, 083, Fizz, Buzz, 086, Fizz, 088, 089, FizzBuzz, ' +
                     '091, 092, Fizz, 094, Buzz, Fizz, 097, 098, Fizz, Buzz, '
  end

  def redirect_stdout
    oldstdout, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = oldstdout
  end
end
