module MainTest exposing (..)

import Util
import Game
import Expect
import Array
import Test exposing (..)

{-| Board where player has won the row of top three cells -}
playerWinTopRow : Game.Board
playerWinTopRow = Array.fromList [
  Game.PlayerCell, Game.PlayerCell, Game.PlayerCell,
  Game.CPUCell, Game.BlankCell, Game.BlankCell,
  Game.CPUCell, Game.BlankCell, Game.CPUCell
  ]

{-| Board where CPU has won the column of left three cells -}
cpuWinLeftCol : Game.Board
cpuWinLeftCol = Array.fromList [
  Game.CPUCell, Game.PlayerCell, Game.PlayerCell,
  Game.CPUCell, Game.PlayerCell, Game.BlankCell,
  Game.CPUCell, Game.BlankCell, Game.PlayerCell
  ]

{-| Board where nobody has won yet -}
ongoingBoard : Game.Board
ongoingBoard = Array.fromList [
  Game.BlankCell, Game.BlankCell, Game.CPUCell,
  Game.PlayerCell, Game.PlayerCell, Game.CPUCell,
  Game.CPUCell, Game.CPUCell, Game.PlayerCell
  ]

{-| Board where nobody has won yet -}
drawBoard : Game.Board
drawBoard = Array.fromList [
  Game.PlayerCell, Game.PlayerCell, Game.CPUCell,
  Game.CPUCell, Game.CPUCell, Game.PlayerCell,
  Game.PlayerCell, Game.CPUCell, Game.PlayerCell
  ]

{-| Board where CPU can win in the next turn -}
cpuCanWinBoard : Game.Board
cpuCanWinBoard = Array.fromList [
  Game.PlayerCell, Game.PlayerCell, Game.CPUCell,
  Game.CPUCell, Game.CPUCell, Game.BlankCell,
  Game.PlayerCell, Game.CPUCell, Game.PlayerCell
  ]

{-| Board where both CPU and player can win on same cell in the next turn -}
anyCanWinBoard : Game.Board
anyCanWinBoard = Array.fromList [
  Game.PlayerCell, Game.BlankCell, Game.PlayerCell,
  Game.CPUCell, Game.CPUCell, Game.PlayerCell,
  Game.PlayerCell, Game.CPUCell, Game.CPUCell
  ]

{-| Board where player can win in the next turn -}
playerCanWinBoard : Game.Board
playerCanWinBoard = Array.fromList [
  Game.CPUCell, Game.PlayerCell, Game.PlayerCell,
  Game.PlayerCell, Game.CPUCell, Game.BlankCell,
  Game.PlayerCell, Game.CPUCell, Game.PlayerCell
  ]

{-| Board where no one can win in the next turn -}
noneCanWinBoard : Game.Board
noneCanWinBoard = Array.fromList [
  Game.BlankCell, Game.BlankCell, Game.BlankCell,
  Game.BlankCell, Game.BlankCell, Game.PlayerCell,
  Game.BlankCell, Game.CPUCell, Game.BlankCell
  ]

{-| Board with some cells filled with CPUCell -}
boardWithCellsFilled : List Int -> Game.Board
boardWithCellsFilled indexes = 
  let initBoard = Array.repeat 9 Game.BlankCell in
  List.foldl (\idx board -> (Array.set idx Game.CPUCell board)) initBoard indexes


-- UNIT TESTS

utilSuite : Test.Test
utilSuite = Test.describe "Util.split"
  [ Test.test "Util::split" <|
      \_ -> let cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
          in Expect.equal cells (List.concat (Util.split 3 cells)),
          
    Test.test "Util::findIndex::1" <|
      \_ -> let cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
          in Expect.equal (Just 3) (Util.findIndex 0 ((==) 4) cells),
    Test.test "Util::findIndex::2" <|
      \_ -> let cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
          in Expect.equal (Just 3) (Util.findIndex 3 ((==) 1) cells),
    Test.test "Util::findIndex::3" <|
      \_ -> let cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
          in Expect.equal (Just 14) (Util.findIndex 6 ((==) 9) cells),
    Test.test "Util::findIndex::4" <|
      \_ -> let cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
          in Expect.equal Nothing (Util.findIndex 0 ((==) 10) cells)
  ]

gameSuite : Test.Test
gameSuite = Test.describe "Game logic"
  [ Test.test "Game::makeMove" <|
      \_ -> let initBoard = Array.repeat 9 Game.BlankCell in
            let finalBoard = Array.set 3 Game.PlayerCell (Array.repeat 9 Game.BlankCell) in
          Expect.equal finalBoard (Game.makeMove Game.PlayerCell initBoard 3),
    
    Test.test "Game::checkStatus::PlayerWin" <|
      \_ -> Expect.equal Game.PlayerWin (Game.checkStatus playerWinTopRow),
    Test.test "Game::checkStatus::CPUWin" <|
      \_ -> Expect.equal Game.CPUWin (Game.checkStatus cpuWinLeftCol),
    Test.test "Game::checkStatus::Ongoing" <|
      \_ -> Expect.equal Game.Ongoing (Game.checkStatus ongoingBoard),
    Test.test "Game::checkStatus::Draw" <|
      \_ -> Expect.equal Game.Draw (Game.checkStatus drawBoard)
  ]

cpuSuite : Test.Test
cpuSuite = Test.describe "CPU move logic"
  [
    Test.test "Game::checkCPUCanWin::1" <|
      \_ -> Expect.equal (Just 5) (Game.checkCPUCanWin cpuCanWinBoard),
    Test.test "Game::checkCPUCanWin::2" <|
      \_ -> Expect.equal (Just 1) (Game.checkCPUCanWin anyCanWinBoard),
    Test.test "Game::checkCPUCanWin::3" <|
      \_ -> Expect.equal Nothing (Game.checkCPUCanWin noneCanWinBoard),

    Test.test "Game::checkPlayerCanWin::1" <|
      \_ -> Expect.equal (Just 5) (Game.checkPlayerCanWin playerCanWinBoard),
    Test.test "Game::checkPlayerCanWin::2" <|
      \_ -> Expect.equal (Just 1) (Game.checkPlayerCanWin anyCanWinBoard),
    Test.test "Game::checkPlayerCanWin::3" <|
      \_ -> Expect.equal Nothing (Game.checkPlayerCanWin noneCanWinBoard),

    Test.test "Game::findPreferenceOrderMove::1" <|
      \_ -> Expect.equal (Just 4) (Game.findPreferenceOrderMove (boardWithCellsFilled [])),
    Test.test "Game::findPreferenceOrderMove::2" <|
      \_ -> Expect.equal (Just 0) (Game.findPreferenceOrderMove (boardWithCellsFilled [4])),
    Test.test "Game::findPreferenceOrderMove::3" <|
      \_ -> Expect.equal (Just 2) (Game.findPreferenceOrderMove (boardWithCellsFilled [4,0]))
  ]