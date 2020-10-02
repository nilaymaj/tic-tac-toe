#include <algorithm>

#include "board.h"

static std::vector<int> PREFERRED_BOXES = {4, 0, 2, 6, 8, 1, 3, 5, 7};

static int getWinningMove(const Board& board) {
  for (auto& [x, y, z] : WIN_LINES) {
    Token a = board.tokenAt(x);
    Token b = board.tokenAt(y);
    Token c = board.tokenAt(z);
    if (a + b + c != 4) continue;

    if (a == Token::None)
      return x;
    else if (b == Token::None)
      return y;
    else if (c == Token::None)
      return z;
  }

  return -1;
}

static int blockHumanWin(const Board& board) {
  for (auto& [x, y, z] : WIN_LINES) {
    Token a = board.tokenAt(x);
    Token b = board.tokenAt(y);
    Token c = board.tokenAt(z);
    if (a + b + c != 2) continue;
    if (std::max({a, b, c}) == 2) continue;

    if (a == Token::None)
      return x;
    else if (b == Token::None)
      return y;
    else if (c == Token::None)
      return z;
  }

  return -1;
}

static int getPreferredEmptyBox(const Board& board) {
  for (int box : PREFERRED_BOXES) {
    if (board.tokenAt(box) == Token::None) return box;
  }
  return -1;
}

int getComputerMove(const Board& board) {
  int winningMove = getWinningMove(board);
  if (winningMove != -1) return winningMove;

  int blockingMove = blockHumanWin(board);
  if (blockingMove != -1) return blockingMove;

  return getPreferredEmptyBox(board);
}