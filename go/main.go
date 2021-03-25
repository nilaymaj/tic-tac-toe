package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	for {
		game := CreateHumanAIGame()
		game.Start()

		fmt.Println("Play again [y/N]? ")
		reader := bufio.NewReader(os.Stdin)
		text, _ := reader.ReadString('\n')
		text = text[:len(text)-1]
		if strings.ToLower(text) != "y" {
			break
		}
	}
}
