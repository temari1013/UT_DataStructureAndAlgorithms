#include <stdio.h>
#include <stdlib.h>

// Find the greatest common divisor of the two integers, n and m.

int gcd_euclid(int n, int m) {
  int tmp_n = n;
  int tmp_m = m;

  if (tmp_n >= tmp_m) {
    n = tmp_m;
    m = tmp_n; // これでnが小さい方で固定される
  }
  while (1 == 1) {
    int r = m % n;
    if (r == 0) {
      break;
    } else {
      m = n;
      n = r;
      continue;
    }
  }

  return n;
}
