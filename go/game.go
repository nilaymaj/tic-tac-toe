package main

import (
	"fmt"
	"tictactoe/board"
	"tictactoe/players"
)

// Represents the current turn
type Turn int

const (
	TurnX Turn = iota
	TurnO
)

// State of the game
type GameStatus int

const (
	Ongoing GameStatus = iota
	WinX
	WinO
	Draw
)

// Represents a game of Tic-Tac-Toe
type Game struct {
	board   board.Board
	players [2]players.Player
	turn    Turn
}

// Create and return a new game between
// a human and an unbeatable AI
func CreateHumanAIGame() Game {
	b := board.Board{}
	h := players.Human{Token: board.TokenX}
	a := players.AI{Token: board.TokenO}
	ps := [2]players.Player{h, a}
	return Game{b, ps, TurnX}
}

// Begin the game
func (g *Game) Start() {
	// Lay out the rules
	g.introduce()

	// Run the game loop
	for g.board.GetStatus() == board.Ongoing {
		g.executeTurn()
		g.flipTurn()
	}

	// Print the end board
	fmt.Println(g.board)

	// Check status and finish appropriately
	switch g.board.GetStatus() {
	case board.Draw:
		fmt.Println("It's a draw!")
	case board.WinO:
		fmt.Println("You lost...")
	case board.WinX:
		fmt.Println("ain't possible")
	}
}

// Execute the current turn
func (g *Game) executeTurn() {
	var nextPlayer players.Player
	if g.turn == TurnX {
		nextPlayer = g.players[0]
	} else {
		nextPlayer = g.players[1]
	}

	move := nextPlayer.GetMove(g.board)
	if g.board.Get(move) != board.Blank {
		panic("invalid move index")
	}
	g.board.Set(move, board.Token(g.turn+1))
}

// Flip the game turn
func (g *Game) flipTurn() {
	switch g.turn {
	case TurnX:
		g.turn = TurnO
	case TurnO:
		g.turn = TurnX
	default:
		panic("game turn invalid")
	}
}

// Introduce the game to the player
func (*Game) introduce() {
	fmt.Println("=== TIC-TAC-TOE ===")
	fmt.Println("You know the rules, and so do I.")
	fmt.Println("You're playing X, I'm O.")
	fmt.Println("")
}
