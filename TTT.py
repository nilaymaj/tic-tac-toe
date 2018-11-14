# A fully functional command-line tic-tac-toe game.
# Currently contains only two difficulty modes: easy and medium.
# Easy: Computer chooses randomly from all possible options.
# Medium: Computer looks a move ahead and tries to win on next move or blocks
# from winning on next move.
#
# Author: Nilay Majorwar
# Date started: June 23, 2018

import random

# Global variables.
X = "X"
O = "O"
turn = X
board = []
preferenceOrder = (4, 0, 2, 6, 8, 1, 3, 5, 7)
gameOver = False
difficulty = 0
winLines = [(0,1,2),
            (3,4,5),
            (6,7,8),
            (0,3,6),
            (1,4,7),
            (2,5,8),
            (0,4,8),
            (2,4,6)]

#Prints the instructions.
def printInstructions():
    print(
    """
    Welcome to the game of Tic-Tac-Toe!

    You know the rules, except how we're gonna play Tic-Tac-Toe on a command prompt.
    You are about to know that.

       |   |
     0 | 1 | 2
    ___|___|___
       |   |
     3 | 4 | 5
    ___|___|___
       |   |
     6 | 7 | 8
       |   |

    You're just gonna enter your choice as a number, according to the key above.
    As simple as that.

    And by the way you'll be X, and I'll be O.
    """
    )


def printBoard(board):
    # First row
    print("   |   |   ")
    print(" " + board[0] + " " + "|" + " " + board[1] + " " + "|" + " " + board[2] + " ")
    print("___|___|___")

    # Second row
    print("   |   |   ")
    print(" " + board[3] + " " + "|" + " " + board[4] + " " + "|" + " " + board[5] + " ")
    print("___|___|___")

    # Third row
    print("   |   |   ")
    print(" " + board[6] + " " + "|" + " " + board[7] + " " + "|" + " " + board[8] + " ")
    print("   |   |   ")


def checkIfEmpty(number):
    if board[number] == " ":
        return True
    else:
        return False


def startBoard():
    for i in range(9):
        board.append(" ")


def firstMove():
    response = input("Do you want to move first? Y/N  ")
    if response.lower() == 'y':
        return 1
    else:
        return 0


def askAndSetDifficulty():
    global difficulty
    response = input("What difficulty would you like to play at? Enter 1 for easy and 2 for medium.")
    difficulty = int(response) - 1
    

def switchTurn():
    global turn
    if turn == X:
        turn = O
    elif turn == O:
        turn = X


def playerTurn():
    response = getPlayerTurn()
    modifyBoard(int(response), X)


def computerTurn():
    if difficulty == 0:
        response = getComputerTurnEasy()
    elif difficulty == 1:
        response = getComputerTurnMedium()

    modifyBoard(int(response), O)


def getComputerTurnEasy():
    length = len(emptyBlocks(board))
    randomIndex = random.randrange(0, length)
    return emptyBlocks(board)[randomIndex]


def getComputerTurnMedium():
    # If computer can win on next move, choose that.
    globalBoard = board[:]
    for number in emptyBlocks(board):
        tempBoard = globalBoard[:]
        tempBoard[number] = O
        if checkIfWin(tempBoard) == O or checkIfDraw(tempBoard):
            return number

    # If player can win on next turn, block it.
    for number in emptyBlocks(board):
        tempBoard = globalBoard[:]
        tempBoard[number] = X
        if checkIfWin(tempBoard) == X:
            return number

    # If nothing can happen, choose in preference order.
    for i in preferenceOrder:
        if i in emptyBlocks(board):
            return i


def emptyBlocks(board):
    emptyList = []
    for i in range(9):
        if board[i] == " ":
            emptyList.append(i)
    return emptyList


def getComputerTurn():
    # Currently a temporary function that chooses randomly among choices.
    length = len(emptyBlocks(board))
    randomIndex = random.randrange(0, length)
    return emptyBlocks(board)[randomIndex]


def getPlayerTurn():
    response = input("Play your turn: enter a number from 0 to 8.")
    while not checkIfEmpty(int(response)):
        print("That choice is either out of range or already taken.")
        response = input("Play your turn: enter a number from 0 to 8.")
    return response


def modifyBoard(index, whoplayed):
    board[index] = whoplayed


def checkIfWin(board):
    for winLine in winLines:
        if board[winLine[0]] == board[winLine[1]] == board[winLine[2]] != " ":
            return board[winLine[0]]
    return ""


def congratulateWinner(winner):
    if winner == "draw":
        print("It's a draw!")
    else:
        print("And the winner is..." + winner + "!!!")


def checkIfDraw(board):
    for i in range(9):
        if board[i] == " ":
            return False
    return True

        
def main():
    global turn
    while True:
        # Print the introduction and instructions.
        printInstructions()

        # Ask the player for difficulty level and set accordingly.
        askAndSetDifficulty()

        # Set first move as per player's wish.
        if not firstMove():
            turn = O
        else:
            turn = X

        # Set up the board.
        startBoard()
        printBoard(board)

        # Start the loop.
        while not gameOver:
            print("\n")

            if turn == X:
                playerTurn()
            else:
                print("Computer's turn!")
                computerTurn()

            switchTurn()
            printBoard(board)

            if checkIfWin(board):
                winner = checkIfWin(board)
                break
            elif checkIfDraw(board):
                winner = "draw"
                break

        print("\n")
        print("The game has ended!")
        congratulateWinner(winner)
        print("Thank you for playing the game.\n")
        again = input("Would you like to play again? Y/N ")
        if again.lower() == "n":
            break
        
    input("Press enter to exit the game.")


if __name__ == "__main__":
    main()
