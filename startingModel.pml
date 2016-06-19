#define N 5

int A[N];

active [N] proctype Switcher() {
	int j;
	int i;
	int count = 0;
	int temp = count + 1;

	select (i: 0 .. N)
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
	int swap;
	swap = A[j];
	A[j] = A[i];
	A[i] = swap;

	/* Check for duplicates */
	do
		:: count < N ->
			do
				:: temp != count && temp < n ->
					assert{A[temp] != A[count]}
					temp++;
				:: temp == count && temp < n ->
					temp++;
				::else ->
					break;
			od
	od
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
}
