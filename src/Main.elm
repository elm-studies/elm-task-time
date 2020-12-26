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


getCurrentTimeAsString : Model -> String
getCurrentTimeAsString (CurrentTime t) =
    String.fromInt t



---- MODEL ----


type Model
    = CurrentTime Int


init : ( Model, Cmd Msg )
init =
    ( CurrentTime 0, getTime )



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
            ( model, getTime )

        TimeUpdated t ->
            ( Time.posixToMillis t
                |> CurrentTime
            , Cmd.none
            )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text <| "Timestamp: " ++ getCurrentTimeAsString model ]
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
