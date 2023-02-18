
int binary_search ( int * numbers , int key , int length );
int numbers [100] = {
28 , 37 , 44 , 60 , 85 , 99 , 121 , 127 , 129 , 138 ,
143 , 155 , 162 , 164 , 175 , 179 , 205 , 212 , 217 , 231 ,
235 , 238 , 242 , 248 , 250 , 258 , 283 , 286 , 305 , 311 ,
316 , 322 , 326 , 351 , 355 , 364 , 366 , 376 , 391 , 398 ,
408 , 410 , 415 , 418 , 425 , 437 , 441 , 452 , 474 , 488 ,
506 , 507 , 526 , 532 , 534 , 547 , 548 , 583 , 585 , 595 ,
603 , 621 , 640 , 661 , 666 , 690 , 692 , 713 , 719 , 750 ,
755 , 768 , 775 , 776 , 784 , 785 , 791 , 797 , 798 , 804 ,
828 , 842 , 846 , 858 , 884 , 887 , 890 , 893 , 908 , 936 ,
939 , 953 , 960 , 970 , 978 , 979 , 981 , 990 , 1002 , 1007 };

int main ( void )
{
volatile int * ledr = ( int *) 0xFF200000 ; // recall LEDR_BASE is 0 xFF200000
int index = binary_search ( numbers ,418 ,100);
* ledr = index ; // display the * final * index value on the red LEDs as in Lab 8
}



int binary_search ( int * numbers , int key , int length )
 {
 int startIndex = 0;
 int endIndex = length - 1;
 int middleIndex = endIndex /2;
 int keyIndex = -1;
 int NumIters = 1;
 while ( keyIndex == -1) {
 if ( startIndex > endIndex )
break ;
 else if ( numbers [ middleIndex ] == key )
 keyIndex = middleIndex ;
 else if ( numbers [ middleIndex ] > key ) {
 endIndex = middleIndex -1;
 } else {
 startIndex = middleIndex +1;
}
 numbers [ middleIndex ] = - NumIters ;
 middleIndex = startIndex + ( endIndex - startIndex )/2;
 NumIters ++;
 }
  return keyIndex ;
 }