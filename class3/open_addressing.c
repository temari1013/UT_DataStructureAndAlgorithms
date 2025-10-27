#include <stdio.h>
#include <stdlib.h>
#include "open_addressing.h"

DictOpenAddr *create_dict(int len){
    DictOpenAddr *new_dict =  (DictOpenAddr*)malloc(sizeof(DictOpenAddr));
    new_dict -> B = len;
    new_dict -> H =  malloc(sizeof(DictData) * len);
    for (int i = 0; i < len; i++ ){
        new_dict -> H[i].state =  EMPTY;
    }
    return new_dict;
}

int h(DictOpenAddr *dict, int d, int count){
    int B  = dict -> B;
  int hash = ((d % B) + count ) % B ;
    return hash;
}

int search_hash(DictOpenAddr *dict, int d){
    int expected_hash = 0;
    for (int i = 0; i < (dict -> B) ; i++){
            expected_hash = h(dict, d, i);
            
            State current_state = dict -> H[expected_hash].state;

            if (current_state == OCCUPIED){
                if(dict -> H[expected_hash].name == d){
                    return expected_hash; 
                }
            } else if (current_state == EMPTY){
                return -1; 
            }
        }
    return -1 ;
}

void insert_hash(DictOpenAddr *dict, int d){
    if (search_hash(dict,d) != -1){
         fprintf(stderr,"データが既に登録されています。\n");
        exit(EXIT_FAILURE);
        return ;
    }
    for (int i = 0; i < (dict -> B) ; i++ ){
        if (dict -> H[h(dict, d, i)].state != OCCUPIED){
            dict -> H[h(dict, d, i)].name = d;
            dict -> H[h(dict, d, i)].state = OCCUPIED;
            return ;
        }else{
           continue;
        }
    }
    // ここに到達する時点で要素に空きが無い。
   fprintf(stderr,"辞書に空きがありません\n");
    exit(EXIT_FAILURE);
}



void delete_hash(DictOpenAddr *dict, int d){
    int hash = search_hash(dict, d);
    if(hash == -1){
      // データが存在しないときは何もしない
     return ;
    }else{
        dict -> H[hash].state =DELETED;
        return ;
    }
}

void display(DictOpenAddr *dict){
    for (int i = 0;  i < dict -> B ;  i++){
        if (i > 0) { 
            printf(" ");
        }
        switch (dict -> H[i].state) {
            case OCCUPIED:
                printf("%d", dict -> H[i].name);
                break;
            case EMPTY:
                printf("e"); 
                break;
            case DELETED:
                printf("d"); 
                break;
        }
    }
    printf("\n"); 
    return ;
}

void delete_dict(DictOpenAddr *dict){
    free(dict -> H);
    free(dict);
    return ;
}