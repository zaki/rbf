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

end
