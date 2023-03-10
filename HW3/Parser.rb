# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Token.rb"
load "Lexer.rb"
class Parser < Scanner
	def initialize(filename)
    	super(filename)
    	consume()
   	end
   	
	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end
  	
	def match(dtype)
      	if (@lookahead.type != dtype)
         	puts "Expected #{dtype} found #{@lookahead.text}"
			#add the error messages
			@errors += 1
      	end
      	consume()
   	end
   	
	def program()
		#reset errors at begginning program
		@errors = 0;
      	while( @lookahead.type != Token::EOF)
			statement()  
      	end
		#display the error message
		puts "There were #{@errors} parse errors found."
   	end

	def statement()
		puts "Entering STMT Rule"
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			exp()
		else
			assign()
		end
		
		puts "Exiting STMT Rule"
	end

	#Define assign()
	#"=" is the Token ASSGN
	def assign()
		puts "Entering ASSGN Rule"
		#call id rule 
		id()
		#Case for "="
		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN Token: #{@lookahead.text}"
			match(Token::ASSGN)
		else
			match(Token::ASSGN)
		end
		exp()
		puts "Exiting ASSGN Rule"
	end

	#Method for exp
	def exp()
		puts "Entering EXP Rule"
		#call term rule and etail
		term()
		etail()
		puts "Exiting EXP Rule"
	end

	#Method for etail
	def etail()
		puts "Entering ETAIL Rule"
		if (@lookahead.type == Token::ADDOP)
			puts "Found ADDOP Token: #{@lookahead.text}"
			match(Token::ADDOP)
			term()
			etail()
		elsif (@lookahead.type == Token::SUBOP)
			puts "Found SUBOP Token: #{@lookahead.text}"
			match(Token::SUBOP)
			term()
			etail()
		else
		puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
		end

		puts "Exiting ETAIL Rule"
	end

	#Method for term
	def term()
		puts "Entering TERM Rule"
		factor()
		ttail()
		puts "Exiting TERM Rule"
	end

	#Method for ttail
	def ttail()
		puts "Entering TTAIL Rule"
		if (@lookahead.type == Token::MULTOP)
			puts "Found MULTOP Token: #{@lookahead.text}"
			match(Token::MULTOP)
			factor()
			ttail()
		elsif (@lookahead.type == Token::DIVOP)
			puts "Found DIVOP Token: #{@lookahead.text}"
			match(Token::DIVOP)
			factor()
			ttail()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
		end
		puts "Exiting TTAIL Rule"
	end

	#Method for factor
	def factor()
		puts "Entering FACTOR Rule"
		if (@lookahead.type == Token::LPAREN)
			puts "Found LPAREN Token: #{@lookahead.text}"
			match(Token::LPAREN)
			exp()
			if (@lookahead.type == Token::RPAREN)
				puts "Found RPAREN Token: #{@lookahead.text}"
				match(Token::RPAREN)
			else 
				match(Token::RPAREN)
			end
		elsif (@lookahead.type == Token::ID)
			id()
		elsif (@lookahead.type == Token::INT)
			int()
		else
			puts "Expected ( or INT or ID found #{@lookahead.type}"
			@errors += 1
		end
		
		puts "Exiting FACTOR Rule"
	end

	#Method for id
	def id()
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
			match(Token::ID)
		else 
			match(Token::ID)
		end	
	end

	#Method for int
	def int()
		if(@lookahead.type == Token::INT)
			puts "Found INT Token: #{@lookahead.text}"
			match(Token::INT)
		else
			match(Token::INT)
		end
	end

end
