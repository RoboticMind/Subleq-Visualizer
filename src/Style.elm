module Style exposing (..)

import Model exposing (Model, getTapeValue)
import Html.Attributes exposing (style)
import Html


getBaseCellStyle : Model -> Int -> List (Html.Attribute msg)
getBaseCellStyle model index =
    --highlights the cells base on what they refer to
    if index == model.curPos then
        memStyleA
    else if index - model.curPos == 1 then
        memStyleB
    else if index - model.curPos == 2 then
        condJumpStyle
    else
        defualtStyle

getStyle : Model -> Int -> List (Html.Attribute msg)
getStyle model index = 
    let
        compareAppend =
            if getTapeValue model (model.curPos) == index then
                compareStyle ++ [style "text-decoration-color" "blue"]
            else if getTapeValue model (model.curPos+1) == index then
                compareStyle ++ [style "text-decoration-color" "darkorange"]
            else 
                []
        
        jumpPointCompare =
            if getTapeValue model (model.curPos+2) == index then
                [style "text-decoration" "underline overline 0.3ch"
                ,style "text-decoration-color" "yellow"
                ]
            else
                []

        appendedStyle = compareAppend ++ jumpPointCompare
    in
        getBaseCellStyle model index ++ appendedStyle

memStyleA : List (Html.Attribute msg)
memStyleA = [
    style "display" "inline"
    ,style "border" "solid black"
    ,style "background" "lightgreen"
    ,style "flex" "1 1 30%"
    ,style "color" "blue"
    ]

memStyleB : List (Html.Attribute msg)
memStyleB = [
     style "display" "inline"
    ,style "border" "solid black"
    ,style "background" "lightgreen"
    ,style "flex" "1 1 30%"
    ,style "color" "darkorange"
    ]

condJumpStyle : List (Html.Attribute msg)
condJumpStyle = [
     style "display" "inline"
    ,style "border" "solid black"
    ,style "background" "yellow"
    ,style "flex" "1 1 30%"
    ]

defualtStyle : List (Html.Attribute msg)
defualtStyle = [
     style "display" "inline"
    ,style "border" "solid black"
    ,style "border-spacing" "10px"
    ,style "flex" "1 1 30%"
    ]


compareStyle : List (Html.Attribute msg)
compareStyle = [
    style "text-decoration" "underline overline 0.3ch"
    ]

memDivStyle : List (Html.Attribute msg)
memDivStyle = [
         style "display" "flex"
        ,style "flex-wrap" "wrap"
        ,style "width" "50%"
        ,style "margin" "auto"
    ]

outputStyle : List (Html.Attribute msg)
outputStyle = [
     style "font-size" "50%"
    ,style "margin-top" "5px"
    ]

haltStyle = [
     style "color" "red"
    ,style "font-size" "300%"
    ]