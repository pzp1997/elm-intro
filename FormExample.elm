module Main exposing (..)

import Char exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , passwordMessage : (String, String)
    }


model : Model
model =
    Model "" "" "" ("", "")



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain passwordAgain ->
            { model | passwordAgain = passwordAgain }

        Submit ->
            { model | passwordMessage = viewValidation model }



-- VIEW


view : Model -> Html Msg
view model =
    let ( color, message ) = model.passwordMessage in
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Repeat password", onInput PasswordAgain ] []
        , button [ onClick Submit ] [ text "Submit" ]
        , div [ style [ ( "color", color ) ] ] [ text message ]
        ]


viewValidation : Model -> (String, String)
viewValidation model =
    if String.length model.password < 8 then
        ( "red", "Password too short!" )
    else if not (String.any Char.isUpper model.password) then
        ( "red", "Password must contain an uppercase letter!" )
    else if not (String.any Char.isLower model.password) then
        ( "red", "Password must contain a lowercase letter!" )
    else if not (String.any Char.isDigit model.password) then
        ( "red", "Password must contain a number!" )
    else if model.password /= model.passwordAgain then
        ( "red", "Passwords don't match!" )
    else
        ( "green", "OK!" )
