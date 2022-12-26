-module(dog_string).

%-include("dog.hrl").

-export([split/2, split/3, trim/3,replace/4]).

-spec split(String :: string() , Delimiter :: string()) -> list().
split(String, Delimiter, all) ->
    string:split(String, Delimiter, all).
split(String, Delimiter) ->
    string:split(String, Delimiter).

-spec trim(String :: string() , trailing, TrimCharacters :: string()) -> list().
trim(String, trailing, " ") ->
    string:trim(String, trailing, " ").

replace(String,SearchPattern,Replacement,all) ->
    Replaced = re:replace(String,SearchPattern,Replacement,[global,{return,list}]),
    [Replaced].
