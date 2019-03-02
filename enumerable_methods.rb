module Enumerable
	def my_each
		for elem in self do
			yield(elem)
		end
		return self
	end
	
	def my_each_with_index
		ind = 0
		for elem in self do
			yield(elem, ind)
			ind += 1
		end
		return self
	end
	
	def my_select
		res = []
		
		for elem in self do
			if (yield(elem))
				res.push(elem)
			end
		end
		return res
	end
	
	def my_all?
		for elem in self do
			if (block_given? && !yield(elem))
				return false
			
			elsif (!block_given?)
				if (!elem || elem == nil)
					return false
				end
			end
		end
		return true
	end
	
	def my_any?
		for elem in self do
			if (block_given? && yield(elem))
				return true
				
			elsif (!block_given?)
				if (elem)
					return true
				end
			end
		end
		return false
	end
	
	def my_none?
		for elem in self do
			if (block_given? && yield(elem))
				return false
				
			elsif (!block_given?)
				if (elem)
					return false
				end
			end
		end
		return true
	end
	
	def my_count(arg=nil)
		cnt = 0
		for elem in self do
			if (block_given? && yield(item))
				cnt += 1
				
			elsif (!block_given? && arg != nil)
				if (elem == arg)
					cnt += 1
				end
			
			else
				cnt = self.length
			end
		end
		return cnt
	end
	
	def my_map(&proc)
		res = []
		for elem in self do
			res.push(proc.call(elem))
		end
		return res
	end
	
	def my_inject(init=nil, sym=nil)
		if (init == nil || init.is_a?(Symbol))
			sym = init
			init = self.first
			i = 1
		else
			i = 0
		end
		
		for elem in self do
			if (i == 1)
				i = 0
				next
			end
				
			if (block_given?)
				init = yield(init, elem)
			
			elsif (!block_given? && sym != nil)
				sym = sym.to_s
				case sym
				when '*'
					init *= elem
				when '/'
					init /= elem
				when '+'
					init += elem
				when '-'
					init -= elem
				else
					break
				end
			end
		end
		return init
	end
end

# some tests to check functionality

=begin
a = [6, 2, 3 ,4 ,1, 0, 3]

puts "MY EACH: \n"
a.my_each do |item|
	puts item
end

puts

puts "MY EACH WITH INDEX: \n"
a.my_each_with_index do |item, ind|
	puts "#{ind}: #{item}"
end

puts
b = a.my_select {|item| item <= 2}

puts "MY SELECT: "
puts
puts b
puts

puts "MY ALL: \n"
puts a.my_all?
puts [nil, true, 99].my_all?
puts

puts "MY ANY: \n"
puts a.my_any?
puts [nil, true, 99].any?
puts

puts "MY NONE: \n"
puts [nil, false, true].my_none?
puts [].my_none? 
puts

puts "MY COUNT: \n"
puts a.my_count
puts a.count(3)
puts a.count {|item| item % 2 == 0}
puts

puts "MY MAP: \n"
puts (1..4).my_map {|item| item * item}
nproc = Proc.new {|item| item * item }
puts (1..4).my_map(&nproc)
puts

puts "MY INJECT: "
puts (5..10).my_inject(1) { |product, n| product * n }
puts (5..10).my_inject { |sum, n| sum + n }
puts (5..10).my_inject(1, :*)
longest = %w{ cat sheep bear }.inject do |memo, word|
   memo.length > word.length ? memo : word
end
puts longest
puts [2,4,5].my_inject(:*)
=end