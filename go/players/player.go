package players

import "tictactoe/board"

// Player represents a player of the game.
// This may be a human or an AI bot.
type Player interface {
	GetMove(b board.Board) int
}
