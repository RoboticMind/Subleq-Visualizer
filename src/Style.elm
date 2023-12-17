module Style exposing (..)

import Model exposing (Model, getTapeValue)
import Html.Attributes exposing (style)
import Html
import Model exposing (isRunning)


mainDivStyle : List (Html.Attribute msg)
mainDivStyle = [
     style "text-align" "center"
    ,style "font-size" "300%"
    ,style "font-family" "monospace, monospace" --repeating monospace twice is recomended behaviour to stop browser from scaling down text: https://stackoverflow.com/questions/38781089/font-family-monospace-monospace
    ,style "transform" "scale(1.5)"
    ,style "transform-origin" "top"
    ]  

controlDivStyle : List (Html.Attribute msg)
controlDivStyle = [
     style "width" "25%"
    ,style "margin" "10px auto"
    ,style "box-shadow" "0 0px 8px 0 rgba(104, 104, 104, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19)"
    ,style "background-color" "#EEFFF4"
    ,style "padding-bottom" "5px"
    ]

oneStepButtonStyle : List (Html.Attribute msg)
oneStepButtonStyle = [
     style "background-color" "#b59aff"
    ,style "border" "3px solid"
    ,style "border-color" "#b79eff"
    ,style "padding" "2px"
    ,style "color" "white"
    ,style "margin-right" "7px"
    ,style "cursor" "pointer"
    ]


pauseButtonStyle : List (Html.Attribute msg)
pauseButtonStyle = [
     style "background-color" "rgb(255, 155, 155)"
    ,style "border" "3px solid"
    ,style "border-color" "#ff9b9b"
    ,style "padding" "2px"
    ,style "color" "white"
    ,style "width" "2.5ch"
    ,style "cursor" "pointer"
    ]

startButtonStyle : List (Html.Attribute msg)
startButtonStyle = [
     style "background-color" "#59d059"
    ,style "border" "3px solid"
    ,style "border-color" "#40ce40"
    ,style "padding" "2px"
    ,style "color" "white"
    ,style "width" "2.5ch"
    ,style "cursor" "pointer"
    ]

stopStartButtonStyle : Model -> List (Html.Attribute msg)
stopStartButtonStyle model = 
    if isRunning model then
        pauseButtonStyle
    else
        startButtonStyle


svgShowOnlyLight : List (Html.Attribute msg)
svgShowOnlyLight = [
    style "filter" "brightness(0) invert(1)" --brightness(0) set everything black then invert it all
 ]

stopStartIconStyle : List (Html.Attribute msg)
stopStartIconStyle = svgShowOnlyLight ++ [
    style "height" "1.5ex" --maps to exact height of 1 char (consitent due to monospace font)
    ]

baseCellStyle : Model -> Int -> List (Html.Attribute msg)
baseCellStyle model index =
    --highlights the cells base on what they refer to
    if index == model.curPos then
        memStyleA
    else if index - model.curPos == 1 then
        memStyleB
    else if index - model.curPos == 2 then
        condJumpStyle
    else
        defualtStyle

cellStyle : Model -> Int -> List (Html.Attribute msg)
cellStyle model index = 
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
        baseCellStyle model index ++ appendedStyle

cellIndexLabelStyle : Int -> List (Html.Attribute msg)
cellIndexLabelStyle index = [
         style "float" "right"
        ,style "font-size" "50%"
        ,style "margin-right" "2px"
        ,style "color" (if index >= 0 then "black" else "red")
    ]

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
    ,style "width" "50%"
    ,style "margin" "5px auto"
    ]

haltStyle : List (Html.Attribute msg)
haltStyle = [
     style "color" "red"
    ,style "font-size" "300%"
    ]

inputStyle : List (Html.Attribute msg)
inputStyle = [
     style "margin" "auto"
    ,style "width" "50%"
    ,style "text-align" "center"
    ]

