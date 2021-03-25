package board

import "fmt"

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

// Tokens fill board positions
type Token int

// A board position can be:
const (
	// a blank space
	Blank Token = iota
	// filled with X
	TokenX
	// filled with O
	TokenO
)

// Get string representation of token
func (t Token) String() string {
	switch t {
	case Blank:
		return " "
	case TokenX:
		return "X"
	case TokenO:
		return "O"
	default:
		panic("unknown token found")
	}
}

// Represents a 3x3 tic-tac-toe board
type Board struct {
	// Serialized slice of boxes in row-major order
	// 	(r, c) => boxes[3*(r-1) + (c-1)]
	boxes [3 * 3]Token
}

// Set board position i to token t
func (b *Board) Set(i int, t Token) {
	b.boxes[i] = t
}

// Get token located at position i
func (b *Board) Get(i int) Token {
	return b.boxes[i]
}

// Clear the board
func (b *Board) Clear() {
	for i := range b.boxes {
		b.boxes[i] = Blank
	}
}

// Print the board in user-friendly format
func (b Board) String() string {
	row1 := fmt.Sprintf(" %s | %s | %s \n", b.boxes[0], b.boxes[1], b.boxes[2])
	row2 := fmt.Sprintf(" %s | %s | %s \n", b.boxes[3], b.boxes[4], b.boxes[5])
	row3 := fmt.Sprintf(" %s | %s | %s \n", b.boxes[6], b.boxes[7], b.boxes[8])
	fullBlank := "   |   |   \n"
	underBlank := "___|___|___\n"
	return fullBlank + row1 + underBlank +
		fullBlank + row2 + underBlank +
		fullBlank + row3 + fullBlank
}

type BoardStatus int

const (
	Ongoing BoardStatus = iota
	WinX
	WinO
	Draw
)

// Check the board for a winner, or if
// it's a draw, or if the game is in play
func (b *Board) GetStatus() BoardStatus {
	for i := range winLines {
		values := [3]Token{}
		for j := range winLines[i] {
			values[j] = b.boxes[winLines[i][j]]
		}

		switch checkLine(values) {
		case Blank:
			continue
		case TokenX:
			return WinX
		case TokenO:
			return WinO
		}
	}

	if b.hasEmpty() {
		return Ongoing
	} else {
		return Draw
	}
}

// Check if the board has an empty square
func (b *Board) hasEmpty() bool {
	allProduct := 1
	for _, t := range b.boxes {
		allProduct *= int(t)
	}
	return allProduct == 0
}

// Check a board line for win status
func checkLine(line [3]Token) Token {
	product := line[0] * line[1] * line[2]
	sum := line[0] + line[1] + line[2]
	switch {
	case product == 0:
		// There's a blank space in the line
		return Blank
	case sum == 3*TokenO:
		// TokenO has won the line
		return TokenO
	case sum == 3*TokenX:
		// TokenX has won the line
		return TokenX
	default:
		// Some mix of TokenX and TokenO
		return Blank
	}
}
