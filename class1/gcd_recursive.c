#include <stdio.h>
#include <stdlib.h>

// Find the greatest common divisor of the two integers, n and m.
int gcd_recursive(int n, int m) {

  int tmp_n = n;
  int tmp_m = m;

  if (tmp_n >= tmp_m) {
    n = tmp_m;
    m = tmp_n; // これでnが小さい方で固定される
  }
  int r = m % n;
  if (r != 0) {
    n = gcd_recursive(r, n);
  }

  return n;
}
