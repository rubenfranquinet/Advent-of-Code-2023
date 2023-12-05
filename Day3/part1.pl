:- consult('facts.txt').
:- consult('symbols.txt').

% Horizontal and Vertical adjacency
adjacent(X1, Y1, X2, Y1) :- X2 is X1 + 1.  % Right
adjacent(X1, Y1, X2, Y1) :- X2 is X1 - 1.  % Left
adjacent(X1, Y1, X1, Y2) :- Y2 is Y1 + 1.  % Down
adjacent(X1, Y1, X1, Y2) :- Y2 is Y1 - 1.  % Up

% Diagonal adjacency
adjacent(X1, Y1, X2, Y2) :- X2 is X1 + 1, Y2 is Y1 + 1.  % Down-right
adjacent(X1, Y1, X2, Y2) :- X2 is X1 + 1, Y2 is Y1 - 1.  % Up-right
adjacent(X1, Y1, X2, Y2) :- X2 is X1 - 1, Y2 is Y1 + 1.  % Down-left
adjacent(X1, Y1, X2, Y2) :- X2 is X1 - 1, Y2 is Y1 - 1.  % Up-left


adjacent_to_symbol(X1, Y1) :- 
    cell(X1, Y1, _),
    adjacent(X1, Y1, X2, Y2),
    cell(X2, Y2, Symbol),
    symbol(Symbol).


% Checking for adjacent numbers, both left and right.
adjacent_number_right(X, Y) :- 
    X2 is X + 1, Y2 = Y,
    cell(X2, Y2, N), number(N).


adjacent_number_left(X, Y) :- 
    X2 is X - 1, Y2 = Y,
    cell(X2, Y2, N), number(N).


number_starts_here(X, Y, Number) :-
    cell(X, Y, Digit), number(Digit),
    \+ adjacent_number_left(X, Y), % No number to the left.
    (   
        adjacent_to_symbol(X,Y) ->  NewAdjacentToSymbol = true; 
        NewAdjacentToSymbol = false
    ),
    build_number(X, Y, Digit, Number, NewAdjacentToSymbol).


build_number(X, Y, CurrentNumber, FinalNumber, AdjacentToSymbol) :- 
    adjacent_number_right(X, Y),
    X2 is X + 1, Y2 = Y,
    cell(X2, Y2, Digit), number(Digit),
    NewNumber is CurrentNumber * 10 + Digit,
    (   
        adjacent_to_symbol(X2, Y2) ->  NewAdjacentToSymbol = true; 
        NewAdjacentToSymbol = AdjacentToSymbol
    ),
    build_number(X2, Y2, NewNumber, FinalNumber, NewAdjacentToSymbol).

build_number(X, Y, CurrentNumber, CurrentNumber, true) :-
    \+ adjacent_number_right(X, Y).


% Find all part numbers and sum them.
find_and_sum_part_numbers(Sum) :-
    findall(Number, number_starts_here(_, _, Number), Numbers),
    format('Numbers found: ~w~n', [Numbers]),
    sum_list(Numbers, Sum).

