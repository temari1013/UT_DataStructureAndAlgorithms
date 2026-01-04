#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>
#include "common.h"

extern bool S[N];
extern int Scount;                      // 頂点集合Sの要素数
extern int d[N];

/**
 * 頂点集合 S に頂点 u を追加する．
 * @param u 追加する頂点
 * @param S 頂点集合
 * @return なし
 */
void add(int u, bool S[]) {
    // 基本課題1で作成
    S[u] = true;
    Scount++;
}

/**
 * 頂点集合のうち S に追加されていない頂点があるかどうか確認する．
 * @return S に追加されていない頂点が存在すれば true，それ以外は false
 */
bool remain() {
    // 基本課題1で作成
    if (Scount < N){
        return true;
    }else return false;
}

/**
 * p からの最短距離が確定していない頂点のうち，d[] が最小の頂点を
 * 返す．
 * @param なし
 * @return 未確定の d[] が最小の頂点
 */
int select_min() {
    // S[i]がfalseの時のd[i]同士を比較して最小を返したい
    int min_index = -1;
    int min_dist = M; 

    for (int i = 0; i < N; i++) {
        if (!S[i] && d[i] < min_dist) {
            min_dist = d[i];
            min_index = i;
        }
    }
    return min_index;
}


/**
 * 頂点 u から頂点 x に接続する辺が存在すれば true, それ以外は
 * false を返す.
 * @param u 頂点
 * @param x 頂点
 * @return 辺が存在すれば true, それ以外は false
 */
bool member(int u, int x) {
    // 基本課題1で作成
    //w[n][x]がまともな数字ならtrue そうでないならfalse 
    return (w[u][x] < M);
}

/**
 * 配列の中身を標準出力に表示．結果出力およびデバッグ用．
 * @param name ラベル（変数名など）
 * @param ary 配列
 * @return なし
 */
void display(char* name, int* ary) {
  printf("%s: [", name);
  for (int i = 0; i < N; i++) {
    if (ary[i] == M)
      printf(" M");
    else
      printf(" %d", ary[i]);
  }
  printf(" ]\n");
}

/**
 * display_path 配列を元に各頂点からの最短経路を表示．
 * @param parent int配列
 * @param origin 出発点
 * @return なし
 */
void display_path(int* parent, int origin) {
    // 基本課題2で作成
}