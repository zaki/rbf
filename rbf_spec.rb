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
    oldstdout, $stdout = $stdout, StringIO.new
    @rbfc.run('++++++++++[>+++++++>+++++++"+++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.')
    $stdout.string.should == "Hello World!\n"
  end

  it "should ignore comments" do
    oldstdout, $stdout = $stdout, StringIO.new
    @rbfc.run('++++++++++Hello world with
               added comments
               enjoy # # [>+++++++>+++++++"+++>+++>+<<<<-]>++.>
               +.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.')
    $stdout.string.should == "Hello World!\n"
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


end
