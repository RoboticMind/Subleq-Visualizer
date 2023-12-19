module Main exposing (..)


import Browser
import Html exposing (Html, button, div, text, li, br, input, span)
import Html.Attributes exposing (style, value, type_, placeholder, src)
import Html.Events exposing (onSubmit, onClick, onInput)
import Html.Events.Extra exposing (onEnter)
import String exposing (fromInt)
import Dict exposing (Dict)
import Maybe exposing (withDefault)
import String
import Time
import Html.Lazy exposing (lazy)


import Style exposing (..)
import Model exposing (..)
import Html exposing (textarea)
import Html exposing (img)

main : Program () Model Msg
main =
  Browser.element { 
      init = init
    ,update = update
    ,view = view 
    ,subscriptions = subscriptions
    }



--INIT
sayHiProgram : List ( Int, Int )
sayHiProgram = [(0,9),(1,-1),(2,3),(3,10),(4,-1),(5,6),(6,11),(7,-1),(8,0),(9,72),(10,105),(11,32)]

init : () -> (Model, Cmd Msg)
init _ = noCommand {
     tape= Dict.fromList sayHiProgram
    ,curPos=0
    ,output=""
    ,stateInput=""
    ,timeStepToggle=False
    ,speed=250
    }


-- UPDATE
subscriptions : Model -> Sub Msg
subscriptions model =
    if model.timeStepToggle == True then
        Time.every model.speed (\_ -> RunStep)
    else 
        Sub.none
    --Browser.Events.onAnimationFrame (\_ -> RunStep)
    --


runOneStep : Model -> Model
runOneStep model =
    let
        memAPointer = getTapeValue model model.curPos
        memA = getTapeValue model memAPointer

        memBPointer = getTapeValue model (model.curPos+1)
        memB = getTapeValue model memBPointer

        condJump = getTapeValue model (model.curPos+2)
    in
    
    if model.curPos < 0 then  --if pointing to a negative position halt (so don't do anything)
        model
    else 
        {model | tape =
            Dict.update memBPointer (\_ -> Just (memB - memA)) model.tape

            ,curPos = 
                if (memB - memA) <= 0 then 
                    condJump 
                else 
                    model.curPos + 3
            
            ,output =
                if memBPointer == -1 then
                    model.output ++ (String.fromChar <| Char.fromCode memA)
                else 
                    model.output
        }


type Msg
  = RunStep
  | SetState String
  | UpdateInput String
  | ToggleTimeStep
  | UpdateSpeed String

noCommand : Model -> (Model, Cmd Msg)
noCommand model =
    (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RunStep ->
        noCommand <| runOneStep model
    SetState value ->
        noCommand {model|
            output = ""
            ,curPos = 0
            ,tape = String.words value 
                |> List.filterMap String.toInt
                |> List.indexedMap Tuple.pair
                |> Dict.fromList
        }
    UpdateInput value ->
        noCommand {model|stateInput = value}
    
    ToggleTimeStep ->
        noCommand {model|timeStepToggle = not model.timeStepToggle}

    UpdateSpeed value ->
        noCommand {model| speed = Maybe.withDefault 100 (String.toFloat value)}

createIndex : Int -> Html msg
createIndex index =
    div (cellIndexLabelStyle index) [text (fromInt index)]

generateElement : Model -> Int -> Int -> Html Msg
generateElement model index num =
    li (cellStyle model index) [
        lazy text (fromInt num)
        ,lazy createIndex index
    ]


generateDict: Model -> Dict Int (Html Msg)
generateDict model = 
    Dict.map (
        generateElement model
    ) model.tape

generateList: Dict Int (Html Msg) -> Model -> List (Html Msg)
generateList dict model = 
    --creates a list up to the highest store
    --pulls to see if the tape has a value and shows zero if not
    let
        
        upperRange = Basics.max (model.curPos+2) <|withDefault 0 <| List.maximum (Dict.keys dict) 
        lowerRange = Basics.min model.curPos <|withDefault 0 <| List.minimum (Dict.keys dict) 
        --defualt of zero so will display just zero on empty list
        --if pointing at far out zeros, display the mem and jump positions
        count = List.range lowerRange upperRange
        zero index = li (cellStyle model index) [text "0", createIndex index]
    in
        List.map (
            \num -> withDefault (lazy zero num) (Dict.get num dict)
        ) count


renderList: Model -> List (Html Msg)
renderList model =
    generateList (generateDict model) model

-- VIEW

pauseImg : Html msg
pauseImg = img ((src "font-awesome/pause-solid.svg") :: stopStartIconStyle) []

playImg : Html msg
playImg = img ((src "font-awesome/play-solid.svg") :: stopStartIconStyle) []


view : Model -> Html Msg
view model =
  div mainDivStyle [
       div [style "font-size" "33%"] [
           div controlDivStyle [
                 span [] [text <| (String.fromFloat model.speed) ++ "ms/step"]
                ,br [] []
                ,input [
                    type_ "range"
                    ,Html.Attributes.min "0"
                    ,Html.Attributes.max "1000"
                    ,value <| String.fromFloat model.speed
                    ,onInput UpdateSpeed
                ] []
                ,br [] []
                ,button (
                    [onSubmit RunStep, onClick RunStep] ++ 
                    oneStepButtonStyle) [text "run single step"]
                ,button ((onClick ToggleTimeStep) :: stopStartButtonStyle model) 
                    [if isRunning model then pauseImg else playImg]
            ]
           ,br [] []
           ,div haltStyle (
                if isHalted model then [text "Halted"] else []
            )
       ]
       ,div outputStyle 
            [text "Output:"
            ,br [] [], 
            text model.output
            ]
       ,div memDivStyle (renderList model)
       ,input (inputStyle ++ [
            placeholder "set cell values as space seperated list"
            ,value model.stateInput
            ,onInput UpdateInput
            ,onEnter (SetState model.stateInput)
            ]) []
    ]
