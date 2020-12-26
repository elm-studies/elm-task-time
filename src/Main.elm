module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h3, text)
import Html.Events exposing (onClick)
import Task
import Time



---- // ----


getTime : Cmd Msg
getTime =
    Time.now
        |> Task.perform TimeUpdated



---- MODEL ----


type alias Model =
    { wasPressed : Bool
    , time : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { wasPressed = False, time = 0 }, getTime )



---- UPDATE ----


type Msg
    = NoOp
    | PressMe
    | TimeUpdated Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        PressMe ->
            ( { model | wasPressed = not model.wasPressed }, getTime )

        TimeUpdated t ->
            let
                toNum =
                    Time.posixToMillis t
            in
            ( { model | time = toNum }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text <| "Timestamp: " ++ String.fromInt model.time ]
        , button [ onClick PressMe ] [ text "press me" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
