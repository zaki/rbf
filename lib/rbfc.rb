class Rbfc
  attr_reader :buffer
  attr_reader :ptr
  attr_accessor :code

  def initialize()
    @buffer = [0]
	@ptr    = 0
	@code   = ''
	@cptr   = 0
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
    if @buffer[@ptr] == 0
      @cptr = find_matching_bracket(@cptr)
    end
  end

  def op_loop_end # ]
    @cptr = find_matching_bracket(@cptr)-1
  end

  def find_matching_bracket(start)
    dir, push, pop = @code[start].chr == '[' ? [1, '[', ']'] : [-1, ']', '[']
    lptr, stack  = start, ['x']
    while (stack.length > 0)
      lptr+=dir
      raise "] without matching [" if lptr < 0
      raise "[ without matching ]" if lptr > @code.length
      stack.push('x') if @code[lptr].chr == push
      stack.pop if @code[lptr].chr == pop
    end
    lptr
  end
end
