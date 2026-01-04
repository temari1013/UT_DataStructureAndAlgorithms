#ifndef _DIJKSTRA_UTIL_H_
#define _DIJKSTRA_UTIL_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>

void add(int u, bool S[]);
bool remain();
int select_min();
bool member(int u, int x);
void display(char* name, int* ary);
void display_path(int* ary, int origin);

#endif
