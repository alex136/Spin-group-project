#define N 4

#define NoDuplication (dup_finder == 0)
#define EnoughSwap (swapNumber < N)


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
	

do
	:: start == false -> skip;
	:: else -> break;
od

// wait loop
TRY: do
		::  (pids[currentPid] == false) -> 
					select (j: 0 .. N);
					atomic {if
						:: pids[pidNum[i]] == false -> pidNum[i] = currentPid;
					fi;}
					do 
						:: ((j == i) || (j == N)) -> select (j: 0 .. N);
						:: else -> break;
					od;
					atomic {if
						:: pids[pidNum[j]] == false -> pidNum[j] = currentPid;
					fi;}
					atomic {if
						:: ((pidNum[i] == currentPid) && (pidNum[j] == currentPid)) -> pids[currentPid] = true;
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

ltl dup { [] <> NoDuplication }
//ltl swapCheck { [] <> EnoughSwap }

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


	//run Switcher();

	do
		:: swapNumber < N -> skip;
		:: else -> break;
	od

	do
		:: (j < N) -> 		
			i = j + 1;
			dup_finder = 0;
			do
				:: (i < N) -> 
						if
							:: A[i] == A[j] -> dup_finder++;
						fi;
						i++;
				:: else -> break;
			od;
			if
			:: (dup_finder >= 1) -> break;
			fi;
			j++;
		:: (dup_finder >= 1) -> break;
		:: else -> break;
	od;

}