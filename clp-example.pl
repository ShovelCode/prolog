:- use_module(library(clpfd)).

schedule(Tasks, Workers, MaxTime) :-
    length(Tasks, NumTasks),
    length(StartTimes, NumTasks),
    MaxStart is MaxTime - 1,
    domain(StartTimes, 0, MaxStart),
    tasks_constraint(Tasks, StartTimes, Workers),
    maximum(End, StartTimes),
    End #=< MaxTime,
    labeling([minimize(End)], StartTimes),
    print_solution(Tasks, StartTimes).

tasks_constraint([], [], []).
tasks_constraint([Task|Tasks], [Start|StartTimes], [Worker|Workers]) :-
    Task = task(_, Duration, _, Worker),
    End #= Start + Duration,
    tasks_constraint(Tasks, StartTimes, Workers),
    cumulatives([task(Start, Duration, End, 1)], [limit(1)]),
    no_overlap(Start, Duration, StartTimes).

no_overlap(_, _, []).
no_overlap(Start1, Duration1, [Start2|StartTimes]) :-
    End1 #= Start1 + Duration1,
    End2 #= Start2 + Duration1,
    (End1 #=< Start2 ; End2 #=< Start1),
    no_overlap(Start1, Duration1, StartTimes).

print_solution([], []).
print_solution([Task|Tasks], [Start|StartTimes]) :-
    Task = task(Name, _, _, _),
    format("Task ~w starts at ~w~n", [Name, Start]),
    print_solution(Tasks, StartTimes).
