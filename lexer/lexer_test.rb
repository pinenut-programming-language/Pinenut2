require './main.rb' # lexer/main.rb
@code = ARGF.read
@chomp = @code.split(" ")
p Lexer.new(@chomp).run