
%%%
% WORLD
%%%
% VISUALIZATION OF THE WORLD
% 
% k* : key for closed door *
% _________________________
% |     |     |     |     |
% |  s     a     b  %  z  |
% |_____|_   _|_   _|_____|
%       |     |     |
%       |  c     d  |
%       |__#__|__ __|
%       |   k%|   k#|
%       |  e  |  f  |
%       |_____|_____|
%
% Guard controls the path b, a, c, d
% Guard:      G = [b, a, c, d, b, a, c, d, b, a, c, d, b, a, c]
% valid path: P = [s, s, a, c, d, f, f, f, d, c, e, c, d, b, z] 
%%%

% define all rooms. 
% s : start room; z : goal room
room(s).
room(a).
room(b).
room(c).
room(d).
room(e).
room(f).
room(z).

% define which rooms are connected over a open door
open_door(s, a).
open_door(a, b).
open_door(a, c).
open_door(b, d).
open_door(c, d).
open_door(d, f).
%open_door(b, z).

% define keys
% 1: where the key lies, 2 & 3: which door between two rooms the key belongs to
key(e, b, z).
key(f, c, e).
%key(x, x, x).

% define the path of the guard (in a endless loop)
guard_path([b, a, c, d]).
%guard_path([x]).


%%%
% SOLVER
% DO NOT CHANGE
%%%

connected(X,Y):- open_door(X,Y); open_door(Y,X).
connected(X,X).

connected_by_key(X,Y,Visited):-
        key(K, X, Y),
        member(K,Visited), !.

connected_by_key(X,Y,Visited):-
        key(K, Y, X),
        member(K,Visited), !.

path(X,Y,Result) :-
       traverse(X,Y,[X],Q), 
       reverse(Q,Result).

traverse(X,Y,P,[Y|P]) :- 
       (connected(X,Y);
        connected_by_key(X, Y, P)).

traverse(X,Y,Visited,Result) :-
       (connected(X,Z);
       connected_by_key(X,Z,Visited)),
       Z \== Y,
       %\+member(Z,Visited),
       \+length(Visited, 14), % define search depth
       traverse(Z,Y,[Z|Visited],Result).  

path_overlaps([Hx | _], [Hg | _]) :-
        Hx == Hg, !.

path_overlaps([_ | Tx], [Hg | Tg]) :-
        append(Tg, [Hg], G),
        path_overlaps(Tx, G).      

path_crosses([Hx | [Htx | _]], [Hg | [Htg | _]]) :-
        Hx == Htg,
        Htx == Hg,!.

path_crosses([_ | Tx], [Hg | Tg]) :-
        append(Tg, [Hg], G),
        path_crosses(Tx, G).

solve(S):-
        path(s,z,S),
        guard_path(G),
        \+path_crosses(S, G),
        \+path_overlaps(S, G).

