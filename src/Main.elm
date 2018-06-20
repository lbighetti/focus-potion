module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
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
    Float


init : ( Model, Cmd Msg )
init =
    ( 25 * minute, Cmd.none )



-- UPDATE


type Msg
    = Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( model - (1 * second), Cmd.none )



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
                            [ text (formatTime model) ]
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


formatTime : Float -> String
formatTime model =
    String.concat [ toString (floor (Time.inMinutes model) % 60), ":", toString (floor (Time.inSeconds model) % 60) ]
