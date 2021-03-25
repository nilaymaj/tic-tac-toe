package players

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"tictactoe/board"
)

// A Human player
type Human struct {
	Token board.Token
}

// Print the board and get the user's next move
func (h Human) GetMove(b board.Board) int {
	fmt.Printf("\n%s\n", b)
	move := getUserMove(h.Token, &b)
	return move - 1
}

// Prompt the user for move input,
// validate the input and return move
func getUserMove(t board.Token, b *board.Board) int {
	for {
		fmt.Printf("You're %s. Make your move [1-9]: ", t)
		reader := bufio.NewReader(os.Stdin)
		text, _ := reader.ReadString('\n')
		text = text[:len(text)-1]
		num, err := strconv.Atoi(text)

		if err != nil {
			// Error in conversion
			fmt.Println("Invalid input!")
			continue
		}
		if num < 1 || num > 9 {
			// Out of bounds input
			fmt.Println("Out of bounds!")
			continue
		}
		if b.Get(num-1) != board.Blank {
			// Position already filled
			fmt.Println("Already filled!")
			continue
		}

		return num
	}
}
