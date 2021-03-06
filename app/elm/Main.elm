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
    , counterMax : Float
    , active : Bool
    , period : Period
    }


init : ( Model, Cmd Msg )
init =
    ( { counter = 0 * minute
      , counterMax = 25 * minute
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
            ( { model | active = True, counter = 25 * minute, counterMax = 25 * minute, period = Focusing }, Cmd.none )

        SmallBreak ->
            ( { model | active = True, counter = 5 * minute, counterMax = 5 * minute, period = InSmallBreak }, Cmd.none )

        BigBreak ->
            ( { model | active = True, counter = 30 * minute, counterMax = 30 * minute, period = InBigBreak }, Cmd.none )

        Stop ->
            ( { model | active = False, counter = 0 * minute, counterMax = 25 * minute, period = Stopped }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ navbar
        , div [ class "container" ]
            [ div [ class "starter-template" ]
                (bodySection model)
            ]
        ]



-- View Pieces


navbar : Html msg
navbar =
    nav [ class "navbar navbar-expand-md navbar-dark bg-dark fixed-top" ]
        [ a [ class "navbar-brand", href "#" ]
            [ text "Focus Potion" ]
        ]


bodySection : Model -> List (Html Msg)
bodySection model =
    [ div [ class "row" ]
        [ div [ class "col-md-12" ]
            [ h1 [ class "display-4" ]
                [ text (formatTime model.counter) ]
            ]
        ]
    , div [ class "row" ]
        [ div [ class "col-md-12" ]
            [ p [ class "lead" ]
                [ text
                    (case model.period of
                        Focusing ->
                            if model.counter >= 0 then
                                "Focus!"
                            else
                                "Time to take a break!"

                        InSmallBreak ->
                            if model.counter >= 0 then
                                "Catch your breath."
                            else
                                "Time to Focus again!"

                        InBigBreak ->
                            if model.counter >= 0 then
                                "Relax and enjoy!"
                            else
                                "Time to Focus again!"

                        Stopped ->
                            "Ready to roll?"
                    )
                ]
            ]
        ]
    , div [ class "row justify-content-center mt-3" ]
        [ div [ class "col-md-12" ]
            [ div [ class "progress" ]
                [ div
                    [ classList
                        [ ( "progress-bar progress-bar-striped progress-bar-animated", True )
                        , ( "bg-primary", model.period == Focusing )
                        , ( "bg-secondary", model.period == InBigBreak || model.period == InSmallBreak )
                        , ( "bg-danger", model.period == Stopped )
                        ]
                    , attribute "style" (progressPercentageString model.counter model.counterMax)
                    ]
                    []
                ]
            ]
        ]
    , div [ class "row mt-5" ]
        [ div [ class "col-md-3 mt-1" ]
            [ button [ class "btn btn-primary btn-block", onClick Focus ]
                [ i [ class "fas fa-hourglass-half fa-lg" ]
                    []
                ]
            ]
        , div [ class "col-md-3 mt-1" ]
            [ button [ class "btn btn-secondary btn-block", onClick SmallBreak ]
                [ i [ class "fas fa-coffee fa-lg" ]
                    []
                ]
            ]
        , div [ class "col-md-3 mt-1" ]
            [ button [ class "btn btn-secondary btn-block", onClick BigBreak ]
                [ i [ class "fas fa-coffee fa-lg" ]
                    []
                , i [ class "fas fa-coffee fa-lg" ]
                    []
                ]
            ]
        , div [ class "col-md-3 mt-1" ]
            [ button [ class "btn btn-outline-danger btn-block", onClick Stop ]
                [ i [ class "fas fa-ban fa-lg" ] []
                ]
            ]
        ]
    , div [ class "row justify-content-center mt-5" ]
        [ div [ class "col-md-6" ]
            [ div
                [ class "input-group input-group-lg" ]
                [ div [ class "input-group-prepend" ]
                    [ span [ class "input-group-text" ]
                        [ i [ class "fas fa-tag" ]
                            []
                        ]
                    ]
                , input [ class "form-control" ]
                    []
                ]
            ]
        ]
    ]



-- Helper Functions


formatTime : Float -> String
formatTime time =
    let
        timeMod =
            if time < 0 then
                negate time
            else
                time

        minutes =
            floor (Time.inMinutes timeMod) % 60

        seconds =
            floor (Time.inSeconds timeMod) % 60
    in
    String.concat
        [ if time < 0 then
            "-"
          else
            ""
        , toStringAndFormat minutes
        , ":"
        , toStringAndFormat seconds
        ]


toStringAndFormat : Int -> String
toStringAndFormat num =
    if num < 10 then
        "0" ++ toString num
    else
        toString num


progressPercentageString : Float -> Float -> String
progressPercentageString current total =
    let
        percentage =
            (current / total) * 100
    in
    String.concat [ "width: ", toString percentage, "%" ]
