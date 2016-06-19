#define N 5
//This flag is just for write premissions
bool flagWrite[N];

int A[N];

active [N] proctype Switcher() {
	int j = 0;
	int i = 0;
	int count = 0;
	int temp = count + 1;
	int gotI=0, gotJ=0;

	do
		:: (i==j) -> select (i: 0 .. N)
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



		:: else ->
					break
	od
	do
		::gotI==0
			Atomic{
				if(flagWrite[i]==false)
					flagWrite[i]=true
					gotI=1
				fi
			}
	od;
	do
		::gotJ=0
			Atomic{
				if(flagWrite[j]==false)
					flagWrite[j]=true
					gotJ=1
				fi
			}
	od;

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
}
