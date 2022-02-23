module Game exposing (..)

import Array
import Util

{-| Winning lines of a tic-tac-toe board -}
winLines : List (List Int)
winLines = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8],
  [0, 3, 6], [1, 4, 7], [2, 5, 8],
  [0, 4, 8], [2, 4, 6]]

{-| Power order of the nine cells on the board, in descending order -}
preferenceOrder : List Int
preferenceOrder = [4, 0, 2, 6, 8, 1, 3, 5, 7]

{-| A cell of the board -}
type Cell = BlankCell | PlayerCell | CPUCell

{-| The game board, represented as list of cells -}
type alias Board = Array.Array Cell

{-| Status of the game -}
type Status = Ongoing | PlayerWin | CPUWin | Draw

{-| Represents the complete state of a game -}
type alias Game = {
  board: Board,
  status: Status
  }

{-| The initial state of a game -}
initGame : Game
initGame = {board = Array.repeat 9 BlankCell, status = Ongoing}

{-| Change the `index`'th element of board `cells` to `newCell` -}
makeMove : Cell -> Board -> Int -> Board
makeMove newCell cells index = Array.set index newCell cells

{-| Process a single game action, which is a move by player -}
processGameAction : Game -> Int -> Game
processGameAction game index =
  case game.status of
    Ongoing -> let newGame = makePlayerMove game index in
      if newGame.status /= Ongoing then newGame
      else makeCPUMove newGame
    _ -> game

{-| Apply the player's move on a game and recompute status -}
makePlayerMove : Game -> Int -> Game
makePlayerMove game index = 
  case game.status of
      Ongoing -> 
        if Array.get index game.board /= Just BlankCell then game
        else let newBoard = makeMove PlayerCell game.board index in
        {board = newBoard, status = checkStatus newBoard}
      _ -> game

{-| Apply the CPU's move on a game and recompute status -}
makeCPUMove : Game -> Game
makeCPUMove game = 
  let newBoard = makeMove CPUCell game.board (getCPUMove game.board) in
  {board = newBoard, status = checkStatus newBoard}

{-| Check the status of a game board -}
checkStatus : Board -> Status
checkStatus board =
  let winners = List.map (checkWinLine board) winLines in
  if List.any ((==) PlayerWin) winners then PlayerWin
  else if List.any ((==) CPUWin) winners then CPUWin
  else if List.any ((==) Ongoing) winners then Ongoing
  else Draw

{-| Check if an agent is winning the given winline in the board -}
checkWinLine : Board -> List Int -> Status
checkWinLine board indexes =
  let getCellAt = (Util.flip Array.get) board in
  let values = List.map getCellAt indexes in
  if List.all ((==) (Just PlayerCell)) values then PlayerWin
  else if List.all ((==) (Just CPUCell)) values then CPUWin
  else if List.any ((==) (Just BlankCell)) values then Ongoing
  else Draw


-- CPU MOVE-MAKING

{-| Check if CPU can win in a single move -}
checkCPUCanWin : Board -> Maybe Int
checkCPUCanWin board = 
  let isEmptyCellAt = \x -> (Array.get x board) == (Just BlankCell) in
  let emptyIndexes = List.filter isEmptyCellAt (List.range 0 8) in
  let newBoards = List.map (\x -> Array.set x CPUCell board) emptyIndexes in
  let boardStatuses = List.map checkStatus newBoards in
  let winningBoardId = Util.findIndex 0 ((==) CPUWin) boardStatuses in
  Maybe.andThen (\x -> Array.get x (Array.fromList emptyIndexes)) winningBoardId

{-| Check if player can win in a single move -}
checkPlayerCanWin : Board -> Maybe Int
checkPlayerCanWin board =
  let isEmptyCellAt = \x -> (Array.get x board) == (Just BlankCell) in
  let emptyIndexes = List.filter isEmptyCellAt (List.range 0 8) in
  let newBoards = List.map (\x -> Array.set x PlayerCell board) emptyIndexes in
  let boardStatuses = List.map checkStatus newBoards in
  let winningBoardId = Util.findIndex 0 ((==) PlayerWin) boardStatuses in
  Maybe.andThen (\x -> Array.get x (Array.fromList emptyIndexes)) winningBoardId

{-| Find best cell to move on purely by preference order -}
findPreferenceOrderMove : Board -> Maybe Int
findPreferenceOrderMove board = 
  let isBlankCell = (\x -> ((Array.get x board) == Just BlankCell)) in
  List.head (List.filter isBlankCell preferenceOrder)

{-| Find the optimal CPU move for board. Returns 0 if board is invalid -}
getCPUMove : Board -> Int
getCPUMove board =
  case (checkCPUCanWin board) of
    Just cellId -> cellId
    Nothing -> 
      case (checkPlayerCanWin board) of
        Just cellId -> cellId
        Nothing ->
          case (findPreferenceOrderMove board) of
            Just cellId -> cellId
            Nothing -> 8