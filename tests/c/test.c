#include <stdio.h>

struct mystruct {
  int num;
} mystruct;

void myfunc() {
  printf("hello1\n");
}

struct mystruct *myfunc2() {
  return NULL;
}

int main() {
  myfunc();
  return 0;
}
