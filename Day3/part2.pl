:- consult('facts.txt').
:- consult('gear.txt').

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


adjacent_to_gear(X1, Y1, XGear, YGear) :- 
    cell(X1, Y1, _),
    adjacent(X1, Y1, XGear, YGear),
    cell(XGear, YGear, Gear),
    gear(Gear).


% Checking for adjacent numbers, both left and right.
adjacent_number_right(X, Y) :- 
    X2 is X + 1, Y2 = Y,
    cell(X2, Y2, N), number(N).


adjacent_number_left(X, Y) :- 
    X2 is X - 1, Y2 = Y,
    cell(X2, Y2, N), number(N).


number_starts_here(X, Y, [Number, XGear, YGear]) :-
    cell(X, Y, Digit), number(Digit),
    \+ adjacent_number_left(X, Y), % No number to the left.
    (   
        adjacent_to_gear(X,Y, XGear, YGear) ->  NewAdjacentToGear = true; 
        NewAdjacentToGear = false
    ),
    build_number(X, Y, Digit, Number, NewAdjacentToGear, XGear, YGear).


build_number(X, Y, CurrentNumber, FinalNumber, AdjacentToGear, XGear, YGear) :- 
    adjacent_number_right(X, Y),
    X2 is X + 1, Y2 = Y,
    cell(X2, Y2, Digit), number(Digit),
    NewNumber is CurrentNumber * 10 + Digit,
    (   
        adjacent_to_gear(X2, Y2, XGear, YGear) ->  NewAdjacentToGear = true; 
        NewAdjacentToGear = AdjacentToGear
    ),
    build_number(X2, Y2, NewNumber, FinalNumber, NewAdjacentToGear, XGear, YGear).

build_number(X, Y, CurrentNumber, CurrentNumber, true, XGear, YGear) :-
    \+ adjacent_number_right(X, Y).


find_and_sum_part_numbers(Sum) :-
    findall([Number, XGear, YGear], number_starts_here(_, _, [Number, XGear, YGear]), Numbers),
    calculate_gear_products(Numbers, Sum).

calculate_gear_products(NumbersList, ProductsSum) :-
    calculate_gear_products_helper(NumbersList, [], [], Products),
    sum_list(Products, ProductsSum).

calculate_gear_products_helper([], _, ProductsAcc, ProductsAcc).
calculate_gear_products_helper([[Number, XGear, YGear] | Rest], GearsChecked, ProductsAcc, Products) :-
    (   memberchk((XGear, YGear), GearsChecked)
    ->  calculate_gear_products_helper(Rest, GearsChecked, ProductsAcc, Products)
    ;   findall(N, member([N, XGear, YGear], Rest), AdjacentNumbers),
        AllNumbers = [Number | AdjacentNumbers],
        sort(AllNumbers, UniqueNumbers),
        length(UniqueNumbers, Length),
        (   Length > 1 % Check if more than one number is adjacent to the gear
        ->  product_of_list(UniqueNumbers, Product),
            NewProductsAcc = [Product | ProductsAcc]
        ;   NewProductsAcc = ProductsAcc
        ),
        NewGearsChecked = [(XGear, YGear) | GearsChecked],
        calculate_gear_products_helper(Rest, NewGearsChecked, NewProductsAcc, Products)
    ).

product_of_list(List, Product) :-
    product_of_list_helper(List, 1, Product).

product_of_list_helper([], Acc, Acc).
product_of_list_helper([H | T], Acc, Product) :-
    NewAcc is Acc * H,
    product_of_list_helper(T, NewAcc, Product).

:- calculate_gear_products([[633,121,1],[17,130,1],[312,31,2], ...], ProductsSum).
