module Util exposing (split, flip, findIndex)

{-| Split a list into equally divided groups -}
split : Int -> List a -> List (List a)
split i list =
  case List.take i list of
    [] -> []
    listHead -> listHead :: split i (List.drop i list)

{-| Flip the order of arguments of a function of arity 2 -}
flip : (a -> b -> result) -> b -> a -> result
flip originalFn argB argA = originalFn argA argB

{-| Find index of first item in list that satisfies predicate -}
findIndex : Int -> (a -> Bool) -> List a -> Maybe Int
findIndex base isGood list =
  Maybe.andThen (\x -> 
    if isGood x then Just base
    else Maybe.andThen (findIndex (base+1) isGood) (List.tail list)
  ) (List.head list)