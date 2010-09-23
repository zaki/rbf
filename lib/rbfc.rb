class Rbfc
  attr_reader :buffer
  attr_reader :ptr

  def initialize()
    @buffer = [0]
	@ptr    = 0
	@code   = ''
	@cptr   = 0
    @loop_s = -1
    @synt   = {
                '>'=>:op_ptr_plus, '<'=>:op_ptr_minus,
                '+'=>:op_cell_plus, '-'=>:op_cell_minus,
                '.'=>:op_print, ','=>:op_getc,
                '['=>:op_loop_start, ']'=>:op_loop_end
              }
  end
  
  def run(code)
    @code = code
	@cptr = 0

    while (@cptr < @code.length)
      op = @code[@cptr].chr
      self.send @synt[op] if @synt.include? op
      @cptr += 1      
    end
  end

  def op_ptr_plus # >
    @ptr += 1
    @buffer[@ptr] ||= 0
	warn "Possible pointer overflow, ptr > 30000" if @ptr > 30000
  end
  
  def op_ptr_minus # <
    @ptr -= 1
	raise "Pointer underflow" if @ptr < 0
  end
  
  def op_cell_plus # +
    @buffer[@ptr] += 1
  end
  
  def op_cell_minus # -
    @buffer[@ptr] -= 1
  end
  
  def op_print # .
    print @buffer[@ptr].chr
  end
  
  def op_gets # ,
    @buffer[@ptr] = getc
  end
  
  def op_loop_start # [
    if @buffer[@ptr] != 0
      @loop_s = @cptr
    else
      idx = @code.index(']', @cptr)
      raise "Syntax error, no matching ]" if idx.nil?
      @cptr = idx
      @loop_s = -1
    end
  end

  def op_loop_end # ]
    raise "Syntax error, ] without starting [" if @loop_s == -1
    @cptr = @loop_s-1
  end
end
