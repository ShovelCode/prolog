edge(fresno, seattle).
edge(fresno, albany).
edge(fresno, boston).
edge(seattle, omaha).
edge(seattle, dallas).
edge(omaha, albany).
edge(omaha, atlanta).
edge(albany, dallas).
edge(dallas, seattle).
edge(dallas, albany).
edge(atlanta, boston).
edge(atlanta, albany).

connected(X,Y) :- edge(X,Y) ; edge(Y,X).

path(A,B,Path) :- 
	travel(A,B,[A],Q),
	reverse(Q,Path).

travel(A,B,P,[B|P]) :-
	connected(A,B).

travel(A,B,Visited,Path) :-
	connected(A,C),
	C \== B,
	\+member(C,Visited),
	travel(C,B,[C|Visited],Path).
	
%%%%%%%%%%%%
path(X,Y,[arc(X,Y)]) :- arc(X,Y).
path(X,Y,[arc(X,Z)|P]) :- arc(X,Z),path(Z,Y,P).
