module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { gifUrl : String }


init : ( Model, Cmd Msg )
init =
    ( Model "", getRandomGif )



-- UPDATE


type Msg
    = GetGif
    | NewGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetGif ->
            ( model, getRandomGif )

        NewGif (Ok url) ->
            ( Model url, Cmd.none )

        NewGif (Err _) ->
            ( model, Cmd.none )



-- SUBSCRIBPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ img [ src model.gifUrl ] [] ]
        , button [ onClick GetGif ] [ text "Next Gif" ]
        ]



-- HTTP


getRandomGif : Cmd Msg
getRandomGif =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC"
    in
        Http.send NewGif (Http.get url decodeGifUrl)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string
