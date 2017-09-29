#include <stdio.h>
#include <stdlib.h>
#include "../book/common/book.h"
// #include "../book/common/cpu_bitmap.h"

// Seeting up for complex number
struct complex{
  // internal variables
  float r;
  float i;
  //Constructor
  __device__ complex(float a, float b) : r(a), i(b) {}

  //methods
  // void print(){printf("%f + %f*i", r, i);};

  __device__ float magnitude(){
    return r*r + i*i;
  }

  //modify the actual + operator
  __device__ complex operator+(const complex &b){
    return complex(r + b.r, i + b.i);
  }

  //modify the actual * operator
  __device__ complex operator*(const complex &b){
    return complex(r*b.r - i*b.i, r*b.i + i*b.r);
  }
};

// Test if a coordiate is in the julia set

__device__ int julia(int x, int y, int dim, float scale){

  // Declare scale
  // const float scale = 3;

  // Need to normalize this so that has range -1, to 1
  float jx = scale * (float) (dim/2 - x)/(dim/2);
  float jy = scale * (float) (dim/2 - y)/(dim/2);

  // Creating 2 complex numbers
  complex a(jx, jy);
  complex c(-0.8, 0.156);

  int val = 0;

  // Do 200 calculation of the julia set
  for(int i = 0; i < 200; i++){
    a = a*a + c;
    // When a get really big -> a diverge -> not in Julia set
    if(a.magnitude() > 100 && i < 50) {val = 2; break;}
    // else if (a.magnitude() > 80 && i > 50) {val = 1; break;}
  }
  // if(a.magnitude() > 1000) val = 2;

  return val;
}

__global__ void kernel(int *c, float scale){

  // get the current position
  int x = blockIdx.x;
  int y = blockIdx.y;
  // int y = 0;

  // get the grid dimention
  int dim = gridDim.x;

  // caclulate if the current coordiate is in the julia set
  c[x + dim*y] = julia(x, y, dim, scale);
}


int main(int argc, char **argv){
  // printf("%d -- %c \n", argc, argv[2]);


  float scale = 2.0;
  if(argc > 1){
    // char *p; // For using in strtol
    scale = atof(argv[1]);
  }
  // printf(" %d \n", strtol(argv[1], &p, 10));

  // int res = julia(0.5, 0.7);
  int dimgrid = 2048;
  dim3 grid(dimgrid, dimgrid);
  // int dimthread = 1;

  int *c_host;
  int *c_dev;
  c_host = (int*) malloc(dimgrid* dimgrid * sizeof(int));

  cudaMalloc((int **) &c_dev, dimgrid*dimgrid*sizeof(int));

  kernel<<<grid, 1>>>(c_dev, scale);

  cudaMemcpy(c_host, c_dev,  dimgrid*dimgrid*sizeof(int),cudaMemcpyDeviceToHost);
  // printf("%d \n", res);

  int total = dimgrid*dimgrid;

  FILE *fp;

  fp = fopen("test.txt", "w");
  printf("File opened n = %d | scale = %.3f", dimgrid, scale);
  for(int i = 0; i < total; i++){
    // printf(" %d ", c_host[i]);
    fprintf(fp, "%d ", c_host[i]);
  }

  // Closing the file
  fclose(fp);

  // Free the memory
  free(c_host);
  cudaFree(c_dev);
}
