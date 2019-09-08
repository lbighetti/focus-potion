module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String exposing (..)
import Time


main =
    Browser.element
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


init : () -> ( Model, Cmd Msg )
init flags =
    ( Model 0 0 False Stopped, Cmd.none )


type Period
    = Focusing
    | InSmallBreak
    | InBigBreak
    | Stopped



-- UPDATE


type Msg
    = Tick Time.Posix
    | Focus
    | SmallBreak
    | BigBreak
    | Stop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newCounter =
            if model.active then
                model.counter - 1000

            else
                model.counter
    in
    case msg of
        Tick _ ->
            ( { model | counter = newCounter }, Cmd.none )

        Focus ->
            ( { model | active = True, counter = 25 * 60000, counterMax = 25 * 60000, period = Focusing }, Cmd.none )

        SmallBreak ->
            ( { model | active = True, counter = 5 * 1000, counterMax = 5 * 60000, period = InSmallBreak }, Cmd.none )

        BigBreak ->
            ( { model | active = True, counter = 30 * 60000, counterMax = 30 * 60000, period = InBigBreak }, Cmd.none )

        Stop ->
            ( { model | active = False, counter = 0 * 60000, counterMax = 25 * 60000, period = Stopped }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



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
            Time.toMinute Time.utc <| Time.millisToPosix (round timeMod)

        seconds =
            Time.toSecond Time.utc <| Time.millisToPosix (round timeMod)

        negative =
            if time < 0 then
                "-"

            else
                ""
    in
    String.concat
        [ negative, toStringAndFormat minutes, ":", toStringAndFormat seconds ]


toStringAndFormat : Int -> String
toStringAndFormat num =
    if num < 10 then
        "0" ++ String.fromInt num

    else
        String.fromInt num


progressPercentageString : Float -> Float -> String
progressPercentageString current total =
    let
        percentage =
            (current / total) * 100
    in
    String.concat [ "width: ", String.fromFloat percentage, "%" ]
