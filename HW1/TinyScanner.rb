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
#                  
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or 
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Class Scanner - Reads a TINY program and emits tokens
#
class Scanner 
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message

		# I will use an if else statement to do this, 
		# that gives an error message if fails to open
		# Use File.file?(filename) to return true for valid files
		if (File.file?(filename))
		@f = File.open(filename,'r:utf-8')
		else 
			abort("File could not be opened")
		end
		
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken() 
		if @c == "eof"
			return Token.new(Token::EOF,"eof")
				
		elsif (whitespace?(@c))
			str =""
			
			while whitespace?(@c)
				str += @c
				nextCh()
			end
		
		tok = Token.new(Token::WS,str)
		
		elsif (letter?(@c))
			str = ""
			#Runs through a collection of characters in a string
			while letter?(@c)
			str += @c
			nextCh()
			end
		
			#Checks for specifically the string "print"
			if (str == "print")
				tok = Token.new(Token::PRINT, str)
			#Checks for all other words or strings
			else 	
				tok = Token.new(Token::IDENTIFIER, str)
			end
	
		elsif (numeric?(@c))
			str = ""
			#Checks for a string of integers
			while (numeric?(@c))
				str += @c
				nextCh()
			end
			tok = Token.new(Token::NUMBER, str)

		#Checks the left parentheses
		elsif (@c == "(")
			tok = Token.new(Token::LPAREN, @c)
			nextCh()
	
		#Checks for rigth paren
		elsif (@c == ")")
			tok = Token.new(Token::RPAREN, @c)
			nextCh()

		elsif (@c == "+")
			tok = Token.new(Token::ADDOP, @c)
			nextCh()

		elsif (@c == "-")
			tok = Token.new(Token::SUBOP, @c)
			nextCh()
	
		elsif (@c == "=")
			tok = Token.new(Token::EQUALOP, @c)
			nextCh()

		elsif (@c == "*")
			tok = Token.new(Token::MULTIOP, @c)
			nextCh()

		elsif (@c == "/")
			tok = Token.new(Token::DIVOP, @c)
			nextCh()

		else
			tok = Token.new("unknown","unknown")
		end

		puts"Next token is: #{tok.type} Next lexeme is: #{tok.text}"
		return tok

	end
end


		


		# elsif ...
		# more code needed here! complete the code here 
		# so that your scanner can correctly recognize,
		# print (to a text file), and display all tokens
		# in our grammar that we found in the source code file
		
		# FYI: You don't HAVE to just stick to if statements
		# any type of selection statement "could" work. We just need
		# to be able to programatically identify tokens that we 
		# encounter in our source code file.
		
		# don't want to give back nil token!
		# remember to include some case to handle
		# unknown or unrecognized tokens.
		# below is an example of how you "could"
		# create an "unknown" token directly from 
		# this scanner. You could also choose to define
		# this "type" of token in your token class
		
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end