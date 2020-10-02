#pragma once
#include <array>
#include <vector>

const std::array<std::array<int, 3>, 8> WIN_LINES = {{{0, 1, 2},
                                                      {3, 4, 5},
                                                      {6, 7, 8},
                                                      {0, 3, 6},
                                                      {1, 4, 7},
                                                      {2, 5, 8},
                                                      {0, 4, 8},
                                                      {2, 4, 6}}};

enum Token { None, X, O };
enum Player { Human, Computer };
enum GameStatus { WinX, WinO, Draw, Play };

/**
 * Maintains board state and contains logic for checking game state, making
 * moves and printing out the board.
 */
class Board {
 private:
  std::array<Token, 9> boardArray;

 public:
  Board();
  void makeMove(Player p, int position);
  void printBoard();
  Token tokenAt(int position) const;
  bool isOccupied(int position) const;
  GameStatus checkStatus();
};