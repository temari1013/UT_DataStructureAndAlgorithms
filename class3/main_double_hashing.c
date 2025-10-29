#include <stdio.h>
#include <stdlib.h>
#include "double_hashing.h"
#include <time.h>
#include <math.h>
#include "timer.h"

#define MAX_LINES 10000
#define TABLE_SIZE 10007
#define NUM_TRY 10000

double get_time(void);

int main(void) {
    long sample_data[MAX_LINES]; 
    FILE *fp;
    int count = 0;

    const char *filename = "dict_sample.txt";
    if ((fp = fopen(filename, "r")) == NULL) {
        fprintf(stderr, "エラー: ファイル '%s' を開けませんでした。\n", filename);
        return EXIT_FAILURE; 
    }
    while (count < MAX_LINES && fscanf(fp, "%ld", &sample_data[count]) == 1) {
        count++;
    }
    fclose(fp);
    printf("--- 読み込み完了 ---\n");
    printf("総データ数: %d\n", count);
    
    DictDoubleHashing *test_dict = create_dict(10);
    insert_hash(test_dict, 1);
    insert_hash(test_dict, 2);
    insert_hash(test_dict, 3);
    insert_hash(test_dict, 11);
    insert_hash(test_dict, 12);
    insert_hash(test_dict, 21);
    display(test_dict);

    printf("Search 1 ...\t%d\n", search_hash(test_dict, 1));
    printf("Search 2 ...\t%d\n", search_hash(test_dict, 2));
    printf("Search 21 ...\t%d\n", search_hash(test_dict, 21));
    printf("Search 5 ...\t%d\n", search_hash(test_dict, 5));

    delete_hash(test_dict, 3);
    display(test_dict);

    insert_hash (test_dict,3);
    display(test_dict);

    delete_hash(test_dict, 11);
    display(test_dict);

   /* insert_hash(test_dict, 4);
    insert_hash(test_dict, 6);
    insert_hash(test_dict, 7);
    insert_hash(test_dict, 19);
    insert_hash(test_dict, 154);
    insert_hash(test_dict, 213); */
    
    delete_dict(test_dict);
    printf("個々の関数の動作チェック終");

    printf("テーブルサイズ (B): %d\n", TABLE_SIZE);
    printf("計測繰り返し回数 (NUM_TRY): %d\n", NUM_TRY);
    printf("占有率α, 登録データ数, 探索平均時間[sec]\n");

    printf("ALPHA,NUM_INSERTED,AVG_SEARCH_TIME_SEC\n");
    
    Timer search_timer;

    for (double alpha = 0.0; alpha <= 1.0; alpha += 0.1) {
        // データ登録 → 登録したデータの検索　を繰り返す
        DictDoubleHashing *dict_for_test = create_dict(TABLE_SIZE);
        
        int num_to_insert = (int)ceil(alpha * TABLE_SIZE); 
        
        if (num_to_insert > count) {
            num_to_insert = count;
        }

        for (int i = 0; i < num_to_insert; i++) {
            insert_hash(dict_for_test, (int)sample_data[i]); 
        }

        double actual_alpha = (double)num_to_insert / TABLE_SIZE;
        timer_reset(&search_timer);
        
        if (num_to_insert > 0) {
            timer_start(&search_timer);
            
            for (int k = 0; k < NUM_TRY; k++) {
                for (int i = 0; i < num_to_insert; i++) {
                    search_hash(dict_for_test, (int)sample_data[i]);
                }
            }
            
            timer_stop(&search_timer);
        }

        double total_elapsed_time = timer_result(&search_timer);
        double total_searches = (double)NUM_TRY * num_to_insert;
        double elapsed_time = 0.0;
        
        if (total_searches > 0) {
            // 合計時間 / 登録データ数
            elapsed_time = total_elapsed_time / total_searches;
        }

        printf("%.1f,%d,%.13lf\n", actual_alpha, num_to_insert, elapsed_time);

        delete_dict(dict_for_test);
        
        if (num_to_insert < (int)ceil(alpha * TABLE_SIZE)) {
            break; 
        }
    }

    printf("\n--- 処理終了 ---\n");

    return EXIT_SUCCESS;
}