#include <stdio.h>
#include <stdlib.h>
// #include "../book/common/book.h"
// #include "../book/common/cpu_bitmap.h"

// Seeting up for complex number
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

// Test if a coordiate is in the julia set

int julia(int x, int y){

  const float scale = 1.5;

  // Need to normalize this so that has range -1, to 1
  float jx = scale * x;
  float jy = scale * y;

  // Creating 2 complex numbers
  complex a(jx, jy);
  complex c(-0.8, 0.156);

  // Do 200 calculation of the julia set
  for(int i = 0; i < 200; i++){
    a = a*a + c;
    // When a get really big -> a diverge -> not in Julia set
    if(a.magnitude() > 1000){
      return 0;
    }
  }

  // a did not diverge
  return 1;
}

int main(){
  // printf("Hello");
  int res = julia(0.5, 0.7);
  printf("%d \n", res);
}
