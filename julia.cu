#include <stdio.h>
#include <stdlib.h>
#include "../book/common/book.h"
// #include "../book/common/cpu_bitmap.h"


struct complex{
  // internal variables
  float r;
  float i;
  //Constructor
  complex(float a, float b) : r(a), i(b) {}
  //methods
  void print(){printf("%f + %f*i", r, i);};
  float magnitude(){
    return (r*r) + (i*i);
  }

  //modify the actual + operator
  complex operator+(const complex &b){
    return complex(r*b.r, i*b.i);
  }

  //modify the actual * operator
  complex operator*(const complex &b){
    return complex(r*b.r - i*b.i, r*b.i - i*b.r);
  }
};

int main(){
  // printf("Hello");
  complex a(1,2);
  complex b(3,4);
  (a*a + b).print();
}
