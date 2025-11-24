#include "binarytree.h"
#include "stdbool.h"
#include <stdlib.h>

int min_bst(Node *root){
////root を根とする2分探索木における最小値を探索し，その値を返す．2分探索木が空の場合は -1 を返す．
}

bool search_bst(Node *root, int d){
    //整数 d が root を根とする2分探索木に存在するか検査し，存在すれば true，存在しなければ false を bool 型で返す
}

void insert_bst(Node **root, int d){
    /*
    root を根とする2分探索木に整数 d を追加する．2分探索木が空の場合は，整数 d の根を作成する．
    insert_bst関数内でNode型ポインタ root が保持する内容 (アドレス) を書き換えるため，
    insert_bstにはNode型ポインタのポインタ (ダブルポインタ) を第一引数にセットしている．
    シングルポインタだと所謂「アドレスの値渡し」となるので，関数内でアドレスを変更しても，
    それは関数にコピーされた値を操作しただけなので，関数の呼び出し側には反映されない
*/

}

void delete_bst(Node **root, int d){
    /*root を根とする2分探索木から整数 d を削除する．
    insert_bst関数と同様に，第一引数にNode型ポインタ root のポインタをセットしている．*/
}