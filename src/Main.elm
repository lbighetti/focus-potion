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
            ( { model | active = True, counter = 20 * minute, counterMax = 20 * minute, period = InBigBreak }, Cmd.none )

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
        [ nav [ class "navbar navbar-expand-md navbar-dark bg-dark fixed-top" ]
            [ a [ class "navbar-brand", href "#" ]
                [ text "Focus Potion" ]
            ]
        , div [ class "container" ]
            [ div [ class "starter-template" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-12" ]
                        [ h1 [ class "display-4" ]
                            [ text (formatTime model.counter) ]
                        ]
                    , div [ class "col-md-12" ]
                        [ p [ class "lead" ]
                            [ text
                                (case model.period of
                                    Focusing ->
                                        "Focus!"

                                    InSmallBreak ->
                                        "Catch your breath."

                                    InBigBreak ->
                                        "Relax and enjoy!"

                                    Stopped ->
                                        "Ready to roll?"
                                )
                            ]
                        ]
                    , div [ class "col-md-12" ]
                        [ div [ class "progress" ]
                            [ div
                                [ classList
                                    [ ( "progress-bar progress-bar-striped progress-bar-animated", True )
                                    , ( "bg-primary", model.period == Focusing )
                                    , ( "bg-secondary", model.period /= Focusing )
                                    ]
                                , attribute "style" (progressPercentageString model.counter model.counterMax)
                                ]
                                []
                            ]
                        ]
                    ]
                , div [ class "row mt-5" ]
                    [ div [ class "col-md-3" ]
                        [ div [ class "btn btn-primary btn-block", onClick Focus ]
                            [ i [ class "fas fa-hourglass-half fa-lg" ]
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


progressPercentageString : Float -> Float -> String
progressPercentageString current total =
    let
        percentage =
            (current / total) * 100
    in
    String.concat [ "width: ", toString percentage, "%" ]
