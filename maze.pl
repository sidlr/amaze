room(s).
room(a).
room(b).
room(c).
room(d).
room(z).

open_door(s, a).
open_door(a, b).
open_door(a, c).
open_door(c, d).
open_door(b, d).
open_door(b, z).

connected(X,Y):- open_door(X,Y); open_door(Y,X).
connected(X,X).
 
guard_path([d, b, a, c]).


path(X,Y,Result) :-
       traverse(X,Y,[X],Q), 
       reverse(Q,Result).


traverse(X,Y,P,[Y|P]) :- 
       connected(X,Y).

traverse(X,Y,Visited,Result) :-
       connected(X,Z),           
       Z \== Y,
       %\+member(Z,Visited),
       \+length(Visited, 9),
       traverse(Z,Y,[Z|Visited],Result).  

solve(S):-
        path(s,z,S),
        guard_path(G),
        \+path_crosses(S, G),
        \+path_overlaps(S, G).
  % nicht in weg eines wächters

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


