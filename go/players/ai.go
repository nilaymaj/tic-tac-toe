package players

import (
	"fmt"
	"tictactoe/board"
)

var winLines = [8][3]int{
	// Row victories
	{0, 1, 2},
	{3, 4, 5},
	{6, 7, 8},
	// Column victories
	{0, 3, 6},
	{1, 4, 7},
	{2, 5, 8},
	// Diagonal victories
	{0, 4, 8},
	{2, 4, 6},
}

// AI Move preference order, used when there is no
// winning move for AI or opponent
var preferenceOrder = [9]int{4, 0, 2, 6, 8, 1, 3, 5, 7}

// An unbeatable Tic-Tac-Toe AI
type AI struct {
	Token board.Token
}

// Get the AI's move
func (a AI) GetMove(b board.Board) int {
	moves, states := a.computeLineStates(&b)
	winLineID, loseLineID := -1, -1
	for i, state := range states {
		switch state {
		case None:
			continue
		case PlayerWin:
			winLineID = i
		case OppWin:
			loseLineID = i
		}
	}

	fmt.Println(moves)
	fmt.Println(states)

	if winLineID != -1 {
		// AI has a winnable line!
		return winLines[winLineID][moves[winLineID]]
	} else if loseLineID != -1 {
		// Opponent has winnable line!
		return winLines[loseLineID][moves[loseLineID]]
	} else {
		// No lines to be won or lost
		// Go by preference order
		for _, pos := range preferenceOrder {
			if b.Get(pos) == board.Blank {
				return pos
			}
		}
		panic("fully filled board passed to AI")
	}
}

// Compute the states and preferred moves of all winlines of the board
func (a AI) computeLineStates(b *board.Board) ([8]int, [8]LineState) {
	moves, states := [8]int{}, [8]LineState{}
	for i := range winLines {
		values := [3]int{}
		for i, position := range winLines[i] {
			token := b.Get(position)
			switch token {
			case board.Blank:
				values[i] = 0
			case a.Token:
				values[i] = 1
			default:
				values[i] = -1
			}
		}

		move, state := getLineState(values)
		moves[i], states[i] = move, state
	}

	return moves, states
}

// Represents the state of a line of the board
type LineState int

const (
	// Cannot be won by any player in next move
	None LineState = iota
	// Player can win line in next move
	PlayerWin
	// Opponent can win line in next move
	OppWin
)

// Given the tokens on a line, returns whether
// the line is ready to be won on by player, opponent
// or none of them.
func getLineState(values [3]int) (int, LineState) {
	product := values[0] * values[1] * values[2]
	if product != 0 {
		// The line is already full
		return -1, None
	}

	// Atleast one of the positions is blank
	sum := values[0] + values[1] + values[2]
	switch sum {
	case 0: // (1 -1 0) or (0 0 0)
		return -1, None
	case 2: // (1 1 0)
		zeroIdx, _ := find(values[:], 0)
		return zeroIdx, PlayerWin
	case -2: // (-1 -1 0)
		zeroIdx, _ := find(values[:], 0)
		return zeroIdx, OppWin
	default: // 2 blank spaces
		return -1, None
	}
}

// Find an element in the given slice
// Returns index of element, and if it was found
func find(values []int, key int) (int, bool) {
	for i := range values {
		if values[i] == key {
			return i, true
		}
	}
	return -1, false
}
