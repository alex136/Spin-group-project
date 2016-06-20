#define N 5

#define NoDuplication (dup_finder == 0)
ltl dup { [] <> NoDuplication }


//This flag is just for write premissions
bool flagWrite[N];
bool pids[N];


//for duplication finding
int dup_finder;


int A[N];




active [N] proctype Switcher() {
	int j = 0;
	int i = 0;
	int count = 0;
	int temp = count + 1;


	do
		:: (((flagWrite[i] == true) || (flagWrite[j] == true)) || (i==j)) -> select (i: 0 .. N)
					do 
						:: (i == N)  ->
							select (i: 0 .. N)
						:: else -> break
					od;
					do 
						:: ((j == i) || (j == N))  ->
							select (j: 0 .. N)
						:: else -> break
					od;



		:: else ->	flagWrite[i] = true;
					flagWrite[j] = true;
					break
	od
	int swap;

CS: swap = A[j];
	A[j] = A[i];
	A[i] = swap;
	flagWrite[i] = false;
	flagWrite[j] = false;
}

init {
	A[0] = 0; 
	A[1] = 1;
	A[2] = 2;
	A[3] = 3;
	A[4] = 4;
	/*A[5] = 5;
	A[6] = 6;
	A[7] = 7;
	A[8] = 8;
	A[9] = 9;*/
	run Switcher();

	int j = 0;
	int i;
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
			:: (dup_finder >= 1) -> 	break
			fi;
			j++;
		:: (dup_finder >= 1) -> break;
		:: else -> break;
	od;

}


