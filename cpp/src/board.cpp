#include "board.h"

#include <iostream>
#include <vector>
using namespace std;

/**
 * Takes a token and prints corresponding
 * character or blank to stdout.
 */
static void printToken(Token &tk) {
  if (tk == Token::X)
    cout << "\u2717 ";
  else if (tk == Token::O)
    cout << "\u0be6 ";
  else
    cout << "\u2022 ";
}

Board::Board() {
  boardArray = array<Token, 9>{Token::None};
  cout << "Initialized empty board!" << endl;
}

void Board::makeMove(Player p, int position) {
  Token tk = (p == Player::Human) ? X : O;
  boardArray[position] = tk;
}

void Board::printBoard() {
  cout << endl;
  for (int i = 0; i < 3; ++i) {
    cout << "\t";
    for (int j = 0; j < 3; ++j) printToken(boardArray[i * 3 + j]);
    cout << endl;
  }
  cout << endl;
}

Token Board::tokenAt(int position) const { return boardArray[position]; }

bool Board::isOccupied(int position) const {
  return (boardArray[position] != Token::None);
}

GameStatus Board::checkStatus() {
  for (auto &[x, y, z] : WIN_LINES) {
    // Check if someone's already won
    if (boardArray[x] == Token::None) continue;
    if (boardArray[x] == boardArray[y] && boardArray[y] == boardArray[z]) {
      return (boardArray[x] == Token::X) ? GameStatus::WinX : GameStatus::WinO;
    }
  }

  // Check for any empty spaces
  for (auto token : boardArray) {
    if (token == Token::None) return GameStatus::Play;
  }

  // Board full, no one's won, so it's a draw
  return GameStatus::Draw;
}