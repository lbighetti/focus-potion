module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Time exposing (Time, minute, second)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { counter : Float
    , active : Bool
    , period : Period
    }


init : ( Model, Cmd Msg )
init =
    ( { counter = 0 * minute
      , active = False
      , period = Stopped
      }
    , Cmd.none
    )


type Period
    = Focusing
    | InSmallBreak
    | InBigBreak
    | Stopped



-- UPDATE


type Msg
    = Tick Time
    | Focus
    | SmallBreak
    | BigBreak
    | Stop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newCounter =
            if model.active then
                model.counter - (1 * second)
            else
                model.counter
    in
    case msg of
        Tick _ ->
            ( { model | counter = newCounter }, Cmd.none )

        Focus ->
            ( { model | active = True, counter = 25 * minute, period = Focusing }, Cmd.none )

        SmallBreak ->
            ( { model | active = True, counter = 5 * minute, period = InSmallBreak }, Cmd.none )

        BigBreak ->
            ( { model | active = True, counter = 20 * minute, period = InBigBreak }, Cmd.none )

        Stop ->
            ( { model | active = False, counter = 0 * minute, period = Stopped }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
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
                            [ text (formatTime model.counter) ]
                        , p [ class "lead" ]
                            [ text "Focus!"
                            ]
                        ]
                    ]
                , div [ class "row" ]
                    [ div [ class "col-md-3" ]
                        [ div [ class "btn btn-primary btn-block", onClick Focus ]
                            [ i [ class "fas fa-clock fa-lg" ]
                                []
                            ]
                        ]
                    , div [ class "col-md-3" ]
                        [ div [ class "btn btn-secondary btn-block", onClick SmallBreak ]
                            [ i [ class "fas fa-coffee fa-lg" ]
                                []
                            ]
                        ]
                    , div [ class "col-md-3" ]
                        [ div [ class "btn btn-secondary btn-block", onClick BigBreak ]
                            [ i [ class "fas fa-coffee fa-lg" ]
                                []
                            , i [ class "fas fa-coffee fa-lg" ]
                                []
                            ]
                        ]
                    , div [ class "col-md-3" ]
                        [ div [ class "btn btn-outline-danger btn-block", onClick Stop ]
                            [ i [ class "fas fa-ban fa-lg" ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
        ]



-- Helper Functions


formatTime : Float -> String
formatTime model =
    let
        minutes =
            floor (Time.inMinutes model) % 60

        seconds =
            floor (Time.inSeconds model) % 60
    in
    String.concat
        [ toStringAndFormat minutes
        , ":"
        , toStringAndFormat seconds
        ]


toStringAndFormat : Int -> String
toStringAndFormat num =
    if num < 10 then
        "0" ++ toString num
    else
        toString num
