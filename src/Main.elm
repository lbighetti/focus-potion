module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main =
    div []
        [ nav [ class "navbar navbar-expand-md navbar-dark bg-dark fixed-top" ]
            [ a [ class "navbar-brand", href "#" ]
                [ text "Focus Potion" ]
            ]
        , div [ class "container" ]
            [ div [ class "starter-template" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-12" ]
                        [ h1 []
                            [ text "25:00" ]
                        , p [ class "lead" ]
                            [ text "Focus!" ]
                        ]
                    ]
                , div [ class "row" ]
                    [ div [ class "col-md-4" ]
                        [ div [ class "btn btn-primary btn-block" ] [ text "focus" ] ]
                    , div [ class "col-md-4" ]
                        [ div [ class "btn btn-secondary btn-block" ] [ text "small break" ] ]
                    , div [ class "col-md-4" ]
                        [ div [ class "btn btn-secondary btn-block" ] [ text "big break" ] ]
                    ]
                ]
            ]
        ]
