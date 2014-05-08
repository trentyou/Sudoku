Sudoku
======
A Sudoku solver that utilizes logic methods to rule out possible answers and guessing methods when no logical choice can be made. Given enough time, this code should be able to solve any sudoku puzzle. 



Usage
------

To solve your sudoku puzzle, instantiate a new Sudoku class, and pass in the sudoku board as a string of 81 numbers as a single argument. 

    sudoku_board = Sudoku.new("200300000804062003013800200000020390507000621032006000020009140601250809000001002")

The 81 numbers should correspond to the sudoku board reading the numbers from left to right, top to bottom.
For example, 200300000804062003013800200000020390507000621032006000020009140601250809000001002 would correspond to a board that looked like this, with zeroes denoting a blank square:

    2 0 0 3 0 0 0 0 0
    8 0 4 0 6 2 0 0 3
    0 1 3 8 0 0 2 0 0 
    0 0 0 0 2 0 3 9 0 
    5 0 7 0 0 0 6 2 1 
    0 3 2 0 0 6 0 0 0
    0 2 0 0 0 9 1 4 0 
    6 0 1 2 5 0 8 0 9
    0 0 0 0 0 1 0 0 2
    

    
