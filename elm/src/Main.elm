module Main exposing (..)

-- A simple Tic-Tac-Toe game against an unbeatable AI

import Browser
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Game
import Util
import Array
import Html exposing (button)
import Html exposing (pre)


-- MAIN

main : Program () Model Msg
main = Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = { game: Game.Game }

init : Model
init = { game = Game.initGame }


-- UPDATE

type Msg
  = PlayerMove Int
  | ResetGame

update : Msg -> Model -> Model
update msg model =
  case msg of
    PlayerMove index -> { model | game = Game.processGameAction model.game index}
    ResetGame -> { game = Game.initGame }


-- VIEW

{-| Root view function -}
view : Model -> Html Msg
view model = div [class "root"] [
  viewBoard model.game.board,
  viewStatus model.game.status,
  viewResetBtn model.game.status
  ]

{-| Renders the board -}
viewBoard : Game.Board -> Html Msg
viewBoard cells = div [class "board"] (List.indexedMap viewRow (Util.split 3 (Array.toList cells)))

{-| Renders a single row of cells -}
viewRow : Int -> List Game.Cell -> Html Msg
viewRow rowId cells = div [class "row"] (List.indexedMap (viewCell rowId) cells)

{-| Renders a single cell, taking cell row, col and value -}
viewCell : Int -> Int -> Game.Cell -> Html Msg
viewCell rowId colId cell = 
  case cell of
    Game.BlankCell -> div [class "cell", onClick (PlayerMove (rowId * 3 + colId))] [pre [] [text "\u{0020}"]]
    Game.PlayerCell -> div [class "cell"] [pre [] [text "X"]]
    Game.CPUCell -> div [class "cell"] [pre [] [text "O"]]

{-| Renders message for status of the game -}
viewStatus : Game.Status -> Html Msg
viewStatus status = 
  case status of
    Game.Ongoing -> div [] []
    Game.Draw -> div [class "msg draw-msg"] [text "Game drawn!"]
    Game.PlayerWin -> div [class "msg win-msg"] [text "You won the game!"]
    Game.CPUWin -> div [class "msg lose-msg"] [text "You lost the game!"]
 
{-| Renders button for resetting the game, only if current game is over -}
viewResetBtn : Game.Status -> Html Msg
viewResetBtn status =
  case status of
      Game.Ongoing -> div [] []
      _ -> button [class "reset-game", onClick ResetGame] [text "Play again!"]