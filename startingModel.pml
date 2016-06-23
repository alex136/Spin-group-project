#define N 4

#define NoDuplication (dup_finder == 0)
#define EnoughSwap (swapNumber == N)
#define Termination (np_ == 0)


// willingness to go to CS
bool pids[N];

//for duplication finding
int dup_finder;


int A[N];
int pidNum[N];

bool start = false;
int swapNumber = 0;


active [N] proctype Switcher() {
	int j = 0;
	int currentPid = _pid;
	int i = currentPid;
	pids[currentPid] = false;
	
start == true;


// wait loop
TRY: do
		::  (pids[currentPid] == false) -> 
					select (j: 0 .. N);
					atomic {if
						:: pids[pidNum[i]] == false -> pidNum[i] = currentPid;
						:: else -> skip;
					fi;}
					do 
						:: ((j == i) || (j == N)) -> select (j: 0 .. N);
						:: else -> break;
					od;
					atomic {if
						:: pids[pidNum[j]] == false -> pidNum[j] = currentPid;
						:: else -> skip;
					fi;}
					atomic {if
						:: ((pidNum[i] == currentPid) && (pidNum[j] == currentPid)) -> pids[currentPid] = true;
						:: else -> skip;
					fi;}
		:: (pids[currentPid] == true) && ( pidNum[i] == currentPid) && (pidNum[j] == currentPid) -> break;
		:: atomic {( pidNum[i] != currentPid) || (pidNum[j] != currentPid) -> pids[currentPid] = false;}
	od;

	int swap;
CS: swap = A[j];
	A[j] = A[i];
	A[i] = swap;
	pids[currentPid] = false;
	swapNumber++;
}

//ltl dup { [] (Termination -> NoDuplication) }
ltl swapCheck { [] (Termination -> EnoughSwap) }

init {

	int j = 0;
	int i = 0;

	do
		:: i < N ->    
			A[i] = i;
			pidNum[i] = i;	
			i++;
		:: i >= N -> 
			start = true;
			break;
	od;

	swapNumber == N;

	do
		:: (j < N) -> 		
			i = j + 1;
			dup_finder = 0;
			do
				:: (i < N) -> 
						if
							:: A[i] == A[j] -> dup_finder++;
							:: else -> skip;
						fi;
						i++;
				:: else -> break;
			od;
			if
				:: (dup_finder >= 1) -> break;
				:: else -> skip;
			fi;
			j++;
		:: else -> break;
	od;

}