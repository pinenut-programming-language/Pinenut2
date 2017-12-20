class Runner
	def initialize(tkn)
		@token = tkn
		@var   = {}
		@line  = 1
		@PktMth = []
	end

	def run(ss,ff)
		pp = ss # sも処理される。fも処理される。
		while true
			case @token[pp][0]
			when "PRINT" #PRINT
				pp+=1
				# byebug
				puts getVar(@token[pp][1])
			when "VAR" # VAR EQUAL
				# byebug
				pp+=1
				if @token[pp][0] == "EQUAL"
					pp+=1
					@var[@token[pp-2][1]] = getVar(@token[pp][1])
				else
					rerror(1,pp)
					break
				end
			when "WHILE" # WHILE COND DO
				# byebug
				if (@token[pp+1][0] == "TOF" || @token[pp+1][0] == "COND") && @token[pp+2][0] == "DO"
					pp += 3
					# i = px,
					# byebug
					while getVar(@token[pp-2][1])
						# print ">"
						# byebug
						run(pp,dosearch(pp))
						# print "|"
						# p = i
					end
					# p = i
					pp = dosearch(pp)+1
				else
					rerror(2,pp)
					break
				end
			when "IF" # IF COND DO
				if @token[pp+1][0] == "TOF" || @token[pp+1][0] == "COND"
					if @token[pp+2][0] == "DO"
						pp+=3
						if getVar(@token[pp-2][1])
							run(pp,dosearch(pp))
						end
						pp = dosearch(pp)+1
					else
						rerror(5,pp)
						break
					end
				else
					rerror(3,pp)
					break
				end
			when "START"
				if @token[pp+1][0] == "STR_FILE"
					pp+=1
					if @token[pp][1] == "#<PckAnl.pkt_pi>"
						sleep 3
						# `sudo echo;echo`
						# Thread.new do
						# 	`(sudo tcpdump -f -tt | ruby Packages/PktAnl/PktAnl.pck_pi)&`
						# end
					end
				else
					mt=[]
					mt = @token[pp][1].match(/#<([.+]).pck_pi>/)
					`ruby Packages/#{mt[1]}/#{mt[1]}.pck_pi`
				end
			# when "DEBUG_VAR"
			# 	p @var
			when "<BR>"
				@line+=1
			# Please write your new method here.
			#when "Token_Name"
			#  Your Method Movement
			else
				rerror(4,pp)
				break
			end
			pp+=1

			if @token[pp] == nil || pp==ff+1
				# byebug
				break
			end
		end
	end

	def rerror(n,pp)
		puts "Error: #{@line}:#{pp.to_i+1}th ( #{@token[pp.to_i]} ): RunnerError, (Point: #{n})"
	end

	def dosearch(i) # 処理しなきゃいけないとこまで
		c = 1
		while c != 0
			if @token[i][0] == "DO"
				c+=1
			elsif @token[i][0] == "ENDW" || @token[i][0] == "ENDI"
				c-=1
			end
			i+=1
		end
		return i-2
	end

	def getValue(e)
		exp = e.split(/(\+|-)/)

		if exp[0] == ""
			exp.delete_at(0)
		end

		i=0
		type="start"
		acc=0
		while i != exp.size
			if exp[i] == "+" && type != "opr"
				type = "opr"
			elsif exp[i] == "-" && type != "opr"
				type = "opr"
			elsif exp[i] =~ /\d+/ && type != "value" && type != "var"
				type = "value"
			elsif exp[i] =~ /\w+/ && type != "var" && type != "value"
				type = "var"
				exp[i] = getVar(exp[i])
			else
			end
			i+=1
		end

		if exp[0] != "+" && exp[0] != "-"
			exp.unshift("+")
		end

		i=0
		while i != exp.size
			if exp[i] == "+"
				i+=1
				acc += exp[i].to_i
			elsif exp[i] == "-"
				i+=1
				acc -= exp[i].to_i
			end
			i+=1
		end
		return acc
	end

	def evalCond(c)
		# if @var["i"]==10
		# 	byebug
		# end
		l = c.split(/(==|!=|<|>)/)[0]
		ope = c.split(/(==|!=|<|>)/)[1]
		r = c.split(/(==|!=|<|>)/)[2]
		if ope == "=="
			s = (getVar(l) == getVar(r))
		elsif ope == "!="
			s = (getVar(l) != getVar(r))
		elsif ope == "<"
			s = (getVar(l) < getVar(r))
		elsif ope == ">"
			s = (getVar(l) > getVar(r))
		end
		# if s
		# 	return "true"
		# else
		# 	return "false"
		# end
		return s
	end

	def getVar(c)
		case c
		when "PktAnl_new"
				return eval(`cat ~/.pinenut/.pa_text.txt`)
		when /"(.+)"/
			return $1.gsub("\\n","\n")
		when "true"
			return eval(c)
		when "false"
			return eval(c)
		when /\w+==\w+/
			return evalCond(c)
		when /\w+!=\w+/
			return evalCond(c)
		when /\w+<\w+/
			return evalCond(c)
		when /\w+>\w+/
			return evalCond(c)
		when /(\w(\+|-))+\w/
			return getValue(c)
		when /(\w+)\[(\d+)\]/
			# p @var
			return @var[$1][$2.to_i]
		when /\[(.+,)*.+\]/
			return eval(c).to_s
		when /[0-9\.]+/
			return c.to_i
		when /\[.+[,.+]*\]/
			return eval(c)
		when /(\w+)\[(\d+)\]/
			return getvar(@var[$1][$2.to_i])
		when /.+/ # 最後
			return @var[c]
		else
			rerror(6,p)
		end
	end
end
