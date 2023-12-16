module Model exposing (..)

import Dict exposing (Dict)
import Maybe exposing (withDefault)


type alias Model = {
     tape:   Dict Int Int -- cell index : cel value mapping. Use dictionary to allow negative values
    ,curPos: Int
    ,output: String
    ,stateInput: String
    ,timeStepToggle: Bool
    ,speed: Float
    }

getTapeValue : Model -> Int ->  Int
getTapeValue model index =
    withDefault 0 (Dict.get index model.tape)

