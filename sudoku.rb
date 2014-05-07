class Sudoku

	#the board creates a 9 x 9 two dimensional array that takes coordinates by (row, column) for all of the methods
	def initialize(starting_numbers)
		@starting_numbers = starting_numbers
		@sudoku_board = Array.new(9) { Array.new(9) }
		@board_two_revisions_ago = []
		@board_one_revision_ago = []
		@sudoku_board_backup = []
		@guess_attempts = 0
		@period_count = 0

		@sudoku_board.each do |row|
			0.upto(8) do |column|
				row[column] = {:answer => @starting_numbers.slice!(0).to_i, :possible_answers => []}					
			end
		end

		
		

		fill_possible_numbers
		
		puts "\n"
		puts "Initial Puzzle:"
		puts "\n"
		print_board
		puts "\n"	
	end


	#quadrants go from left to right, top to bottom, numbered 1 - 9
	#1 | 2 | 3
	#----------
	#4 | 5 | 6
	#----------
	#7 | 8 | 9

	def get_quadrant(row, column)
		case row
		when 0..2
			return (column / 3) + 1
		when 3..5
			return (column / 3) + 4
		when 6..8
			return (column / 3) + 7
		end
	end

	
	#check_box, check_row, check_column check whether or not the number given as the argument is present in the box, row or column
	def check_box(input_row, input_column, number)

		case get_quadrant(input_row, input_column)
		when 1
			0.upto(2) do |row|
				0.upto(2) do |column|					
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 2
			0.upto(2) do |row|
				3.upto(5) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 3
			0.upto(2) do |row|
				6.upto(8) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 4
			3.upto(5) do |row|
				0.upto(2) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 5
			3.upto(5) do |row|
				3.upto(5) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 6
			3.upto(5) do |row|
				6.upto(8) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 7
			6.upto(8) do |row|
				0.upto(2) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 8
			6.upto(8) do |row|
				3.upto(5) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		when 9
			6.upto(8) do |row|
				6.upto(8) do |column|
					if @sudoku_board[row][column][:answer] == number && !(input_row == row && input_column == column)
						return true
					end
				end
			end
			false
		end
	end


	def check_row(input_row, input_column, number)
		0.upto(8) do |column|
			if @sudoku_board[input_row][column][:answer] == number && input_column != column
				return true
			end
		end
		false
	end


	def check_column(input_row, input_column, number)
		0.upto(8) do |row|
			if @sudoku_board[row][input_column][:answer] == number && input_row != row
				return true
			end
		end
		false
	end

	#checks if a number can be placed in a square by checking the row, column and box
	def valid_placement?(row, column, number)
		if !check_box(row, column, number) && !check_column(row, column, number) && !check_row(row, column, number)
			return true
		else
			return false
		end
	end



	def fill_possible_numbers
		0.upto(8) do |row|
			0.upto(8) do |column|
				if @sudoku_board[row][column][:answer] == 0					
					1.upto(9) do |number|
						if valid_placement?(row, column, number)
							@sudoku_board[row][column][:possible_answers] << number
						end
					end
				end
			end
		end
	end


	def update_possible_numbers
		0.upto(8) do |row|
			0.upto(8) do |column|
				if @sudoku_board[row][column][:answer] == 0					
					1.upto(9) do |number|
						if !valid_placement?(row, column, number) && @sudoku_board[row][column][:possible_answers].include?(number)						
							@sudoku_board[row][column][:possible_answers].delete(number)						
						end
					end
				end
			end
		end
	end

	def start_over_guess
		print "Starting over!"
		@period_count = 1
		puts "\n"
		@sudoku_board = Marshal.load(Marshal.dump(@sudoku_board_backup))
		guess
	end


	def is_solved?
		0.upto(8) do |row|
			0.upto(8) do |column|
				if !valid_placement?(row, column, @sudoku_board[row][column][:answer])
					return false
				end
			end
		end

		0.upto(8) do |row|
			0.upto(8) do |column|
				if @sudoku_board[row][column][:answer] == 0 				
					return false
				end
			end
		end
		
		true
	end

	#goes through every quadrant, and checks if there is only one instance of a number within :possible_answers, if so, assign :answer of that square to the 
	#:possible_answer
	def sub_group_exclusion_check
		(0..8).step(3) do |row|
			(0..8).step(3) do |column|
				1.upto(9) do |numcheck|
					numcount = 0
					row_coordinates = 0
					column_coordinates = 0
					

					0.upto(2) do |quadrantrow|
						0.upto(2) do |quadrantcolumn|
							if @sudoku_board[row + quadrantrow][column + quadrantcolumn][:possible_answers].include?(numcheck)
								numcount += 1
								row_coordinates = row + quadrantrow
								column_coordinates = column + quadrantcolumn							
							end
						end
					end

					if numcount == 1
								@sudoku_board[row_coordinates][column_coordinates][:answer] = numcheck
								@sudoku_board[row_coordinates][column_coordinates][:possible_answers] = []
					end

					update_possible_numbers
				end
			end
		end
	end

	def finished
		puts "\n"	
		puts "Finished!"
		puts "\n"			
		print_board
	end


	#signals a wrong guess
	def empty_check
		0.upto(8) do |row|
			0.upto(8) do |column|
				if @sudoku_board[row][column][:answer] == ""
					return true
				end
			end
		end
		false
	end


	def solve
		@board_one_revision_ago = Marshal.load(Marshal.dump(@sudoku_board))
		while !is_solved?			
			0.upto(8) do |row|
				0.upto(8) do |column|
					if @sudoku_board[row][column][:answer] == 0 && @sudoku_board[row][column][:possible_answers].length == 1
						@sudoku_board[row][column][:answer] = @sudoku_board[row][column][:possible_answers][0]
						@sudoku_board[row][column][:possible_answers].pop
					end
				 end
			end
			update_possible_numbers
			sub_group_exclusion_check

			if @sudoku_board == @board_two_revisions_ago
				break
			end
			
			@board_two_revisions_ago = Marshal.load(Marshal.dump(@board_one_revision_ago))
			@board_one_revision_ago = Marshal.load(Marshal.dump(@sudoku_board))

			if empty_check
				break
			end
											
		end

		if is_solved?
			finished
		elsif empty_check
			start_over_guess		
		else
			if @guess_attempts == 0
				@sudoku_board_backup = Marshal.load(Marshal.dump(@sudoku_board))
			end
			@guess_attempts += 1

			if @period_count > 3
				@period_count = 0 
			end
			puts "\n"
			print "Calculating" + "." * @period_count
			@period_count += 1
			puts "\n"
			puts "\n"
			print_board
			guess			
		end
	end


	def guess
		0.upto(8) do |row|
			0.upto(8) do |column|
				if @sudoku_board[row][column][:answer] == 0 && @sudoku_board[row][column][:possible_answers].length != 0
					@sudoku_board[row][column][:answer] = @sudoku_board[row][column][:possible_answers][rand(@sudoku_board[row][column][:possible_answers].length)]
					@sudoku_board[row][column][:possible_answers] = []
					@sudoku_board[row][column][:answer] = @sudoku_board[row][column][:answer]
					update_possible_numbers
					solve
					return
				elsif @sudoku_board[row][column][:answer] == 0 && @sudoku_board[row][column][:possible_answers].length == 0
					start_over_guess
					return
				end
			end
		end
		if is_solved?
			finished
		else
			start_over_guess
		end		
	end





	def print_board		
		puts "-" * 22
		0.upto(8) do |row|
			0.upto(8) do |column|
				print @sudoku_board[row][column][:answer].to_s + " "
				if (column + 1) % 3 == 0 && column != 8
					print "| "
				end
			end	

			puts "\n"

			if (row + 1) % 3 == 0
				puts "-" * 22
			end
		end			
	end



end
#easy one 000260701680070090190004500820100040004602900050003028009300074040050036703018000
#036801000010200000705060000090500003007349100400006020000010705000004090000608340 <- one i was working on tuesday
#020608000580009700000040000370000500600000004008000013000020000009800036000306090
#hard one http://www.websudoku.com/images/example-steps.html v
#000000680000073009309000045490000000803050902000000036960000308700680000028000000
#really hard one 020000000000600003074080000000003002080040010600500000000010780500009000000000040
#hard one 200300000804062003013800200000020390507000621032006000020009140601250809000001002
new_board = Sudoku.new('000000680000073009309000045490000000803050902000000036960000308700680000028000000')
new_board.solve





