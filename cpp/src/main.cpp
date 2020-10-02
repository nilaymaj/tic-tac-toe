#include <iostream>
#include <string>

#include "ai.cpp"
#include "board.h"
using namespace std;

/**
 * Flips the given Player reference
 */
void flipTurn(Player& turn) {
  if (turn == Player::Human)
    turn = Player::Computer;
  else
    turn = Player::Human;
}

/**
 * Prints a message to console and waits for user to hit a key.
 */
void printMessage(const string& str) {
  cout << str;
  getchar();
}

/**
 * Prompts player for entering move.
 * Keeps repeating until user enters valid empty box id.
 */
int getPlayerMove(const Board& board) {
  int move = 0;
  while (move <= 0 || move > 9 || board.isOccupied(move - 1)) {
    cout << "Make your move. Enter a number from 1-9: ";
    cin >> move;
  }
  return move - 1;
}

/**
 * Prints welcome message for the user
 */
void welcomePlayer() {
  printMessage("Welcome, player, to the Impossible Tic-Tac-Toe challenge.");
  printMessage("Surely you know the rules. You are X, the computer is O.");
  printMessage("P.S: You cannot win this game.");
  cout << endl;
}

/**
 * Prints parting message for user
 */
void printEndingMessage(GameStatus& status) {
  if (status == GameStatus::WinX)
    printMessage("This is impossible.");
  else if (status == GameStatus::WinO)
    printMessage("The computer wins. You lose.");
  else
    printMessage("It's a draw. This is the closest you can get to a win.");
}

/**
 * Clears the screen and positions the cursor at (1,1).
 */
void clearScreen() { cout << "\033[2J\033[1;1H"; }

int main() {
  clearScreen();
  welcomePlayer();
  Board board;
  board.printBoard();
  Player turn = Player::Human;

  while (true) {
    int move =
        (turn == Player::Human) ? getPlayerMove(board) : getComputerMove(board);
    board.makeMove(turn, move);
    clearScreen();
    if (board.checkStatus() != GameStatus::Play) break;
    if (turn == Player::Computer) board.printBoard();
    flipTurn(turn);
  }

  board.printBoard();
  GameStatus status = board.checkStatus();
  printEndingMessage(status);

  return 0;
}
