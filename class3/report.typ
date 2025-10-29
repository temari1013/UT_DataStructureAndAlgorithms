#set text(
  lang: "ja",
  font:"Hiragino Mincho ProN",
)

#let today = datetime.today()


#set page(
  paper: "a4",
  margin: 1.5cm,
  footer: align(center, text(10pt)[
    #context {
      counter(page).display("1 / 1")
    }
  ])
)

#align(center, text(25pt)[
 データ構造とアルゴリズム　第3回レポート
])

#v(1em)
#align(center, text(12pt)[
  名前: 今井真里奈  #h(1cm) \
  学籍番号: 202411955 #h(1cm)\
  クラス名 : クラス4\
  提出日: #today.display()\
  締め切り: 10月16日 \
  課題名:   課題3：ハッシュ法 \
])

---
// --- 本文 ---
#v(3em)

== 課題3-1 オープンアドレス法
作成した関数群は以下の通り。
#```
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
```

まず、create/delete_dictについて解説する。\

create_dictは、配列の長さを引数に取り、すべてのデータの配列について、空のラベルを設定した辞書を作成し、自身のポインタを返す。\
delete_dictは、辞書のポインタを引数に取り、辞書が持っているデータ配列のメモリと、辞書そのもののメモリを解放する。\
この２つの関数は前回のcreate/delete_queueと本質的に変わらない。\

次に、h(ハッシュ関数)について説明する。\

今回のハッシュ関数は、格納するデータ mod データ長 であり、そのハッシュテーブルに既に値が格納されている場合は ハッシュ値を1増やす、という動作を繰り替えすというものである。\
引数として、辞書へのポインタ dict、格納するデータ d、および試行回数を示す count を取る。\
データ d を格納させるべき場所のハッシュ値を(int)を返す。\

search_hashについて説明する。\

この関数は、辞書のポインタとデータを引数に取る。\ｓ
search_hash 関数は、辞書 dict の中にデータ d が存在するかを探索し、存在する場合はそのインデックスを、存在しない場合は −1 を返す。\
辞書の配列長Bの回数だけ、インデックスを増やしながらハッシュ値を確認するという動作を繰り返す。
このループは、\
確認したデータの状態が OCCUPIED かつ、データが d　と一致するとき、その時のハッシュ値の値が配列のインデックスになるため、それを返す、\
もしくは、データの状態がEMPTYのものを見つけるか、配列全体を探索しても見つからなかったときに−1 を返す。

insert_hashについて\

これも辞書のポインタdict と データ dを引数に取る。\
まず、search_hash 関数を用いて、データ d が既に辞書に登録されていないかを確認し、登録済みなら、エラーを出力してプログラムを終了する。\
次に、配列長 B の回数だけループを回し、h 関数を使って順に格納されるべきインデックスを計算する。\
現在のスロットの状態が OCCUPIED ではないスロットを発見したとき、、そのスロットにデータ d を格納し、状態を OCCUPIED に変更して関数を終了する。\
配列全体を探索し終えても空きスロットが見つからなかった場合、辞書が満杯と判断し、エラーを出力する。\

delete_hash \

これも辞書のポインタdict と データ dを引数に取る。\
まず、search_hash 関数を用いて、データ d が格納されているインデックス hash を取得する。\
データ d が存在しない場合 (hash==−1)、何もしない。\
データ d が存在する場合、そのインデックスの state を DELETED に変更するする。物理削除ではなく、論理削除と言える)\

display\

display 関数は辞書を指すポインタdictを引数に取る。\
状態が OCCUPIED で、dict→H[i].name \
状態が EMPTY で ′e′ \
状態が DELETED で　′d′ \
を表示し、各要素の間にスペースを挿入し、最後に改行を出力する。\

=== main関数について
main関数についても多少変更した。\
主要部は以下の通り。コメントアウトしている部分は、コメントから戻すことで、辞書満杯時の動作確認を行える。\
#```
 DictOpenAddr *test_dict = create_dict(10);

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
return EXIT_SUCCESS; 
```

これを実行すると以下のような結果を得られる。\
#```
e 1 2 3 11 12 21 e e e
Search 1 ...    1
Search 2 ...    2
Search 21 ...   6
Search 5 ...    -1
e 1 2 d 11 12 21 e e e
e 1 2 3 11 12 21 e e e
e 1 2 3 d 12 21 e e e
```
1,2,3のインサートではインデックスが1,2,3になることが期待される。\
11,12,21はインデックス4(1,2,3が埋まっていることから),5,6が期待される。\
最初の表示結果から、表示関数が正しく動いていることと、インデックスが期待通りに振られたことがわかった。search関数の結果もインデックスが正しく振られたことと、格納していないデータは1を返していることが確認できる。\
最後の3行で、delete関数が正しく動作したことと、deleteして再挿入ができていることがわかる。\

== 課題3-2 ダブルハッシュ法

二重ハッシュを行う。ハッシュ関数以外の関数はオープンアドレス法と(型定義を除いて)同じであるため、省略する。\

#```
int h_0(DictDoubleHashing *dict, int d){
    int B  = dict -> B;
    return (d % B + B) % B; 
}

int g_0(DictDoubleHashing *dict, int d){
    int q = dict -> B - 1; 
    int rem = (d % q + q) % q;
    return q - rem;
}

int h(DictDoubleHashing *dict, int d, int count){
    int h0 = h_0(dict, d);
    int g0 = g_0(dict, d);
    long long intermediate = (long long)h0 + (long long)count * g0;
    int B = dict -> B;
    int hash = (int)(intermediate % B);
    return hash;
}
```

このハッシュ値決定では、\
h = h_0 + count x g_0 \
としてハッシュ値を決めている。h_0はオープンアドレス法のハッシュ関数そのままで、g_0は、格納する値 % (データ長 -1 )\
である。これによって、オープンアドレスの課題である、同じハッシュ値に値が集中したときにまとまったエリアが取られるため圧迫されるという課題を解決できる。\
また、今回のテーブルサイズは10007(素数)を設定したため、どのようなg0であってもテーブルサイズと互いに素であることが保証され、テーブル全体を探索することができる。\

二重ハッシュ法においてはmain関数も作成する必要があったため、main関数内部のコードをまず示す。\

#```
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
```
冒頭でデータを読み込み、オープンアドレス法と同様にして、基本的な関数の動作を調べている。\
その後、$alpha$ = 0.0,0.1,,,1.0について、\
テーブルサイズ x $alpha$ (切り上げ)個のデータを格納したあと、格納したすべてのデータを探索する。\
この探索を10000回繰り返し、その算術平均を更に格納したデータの個数で割ったものを出力する、と言う動作を繰り返す。\
実行結果の一例を示すと以下のようになる。当然だが、タイムは各実行ごとに多少揺らぐ。\

#```
temari@13351097194 class3 % ./double_hashing
--- 読み込み完了 ---
総データ数: 10000
e 1 2 3 12 e e 21 11 e
Search 1 ...    1
Search 2 ...    2
Search 21 ...   7
Search 5 ...    -1
e 1 2 d 12 e e 21 11 e
e 1 2 3 12 e e 21 11 e
e 1 2 3 12 e e 21 d e
個々の関数の動作チェック終テーブルサイズ (B): 10007
計測繰り返し回数 (NUM_TRY): 10000
占有率α, 登録データ数, 探索平均時間[sec]
ALPHA,NUM_INSERTED,AVG_SEARCH_TIME_SEC
Timer reset
Time precision: 0.000001000 sec
0.0,0,0.0000000000000
Timer reset
Time precision: 0.000001000 sec
0.1,1001,0.0000000190659
Timer reset
Time precision: 0.000001000 sec
0.2,2002,0.0000000235657
Timer reset
Time precision: 0.000001000 sec
0.3,3003,0.0000000276780
Timer reset
Time precision: 0.000001000 sec
0.4,4003,0.0000000331896
Timer reset
Time precision: 0.000001000 sec
0.5,5004,0.0000000392432
Timer reset
Time precision: 0.000001000 sec
0.6,6005,0.0000000462065
Timer reset
Time precision: 0.000001000 sec
0.7,7005,0.0000000533592
Timer reset
Time precision: 0.000001000 sec
0.8,8006,0.0000000596231
Timer reset
Time precision: 0.000001000 sec
0.9,9007,0.0000000691717
Timer reset
Time precision: 0.000001000 sec
1.0,10000,0.0000001165645

--- 処理終了 ---
```
これで出力された、各データの格納率毎の探索時間をグラフにすると以下の画像のようになり、確かに、占有率が1に近づくと急激に探索時間がかかる様になったことが確認できる。\
#image("hash_performance.png", width: 80%)