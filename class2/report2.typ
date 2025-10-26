#set text(
  lang: "ja", // 言語設定
  font:"Hiragino Mincho ProN", // フォント設定
)

// 今日の日付を変数に格納
#let today = datetime.today()

// ページ設定: A4、余白1.5cm、ページ番号をフッターに表示
#set page(
  paper: "a4",
  margin: 1.5cm,
  footer: align(center, text(10pt)[
    // contextで囲むことで、ページ番号を正しく取得
    #context {
      counter(page).display("1 / 1")
    }
  ])
)


// --- タイトル部分 ---
#align(center, text(25pt)[
 データ構造とアルゴリズム　第一回レポート
])

// --- 提出情報 ---
#v(1em)
#align(center, text(12pt)[
  名前: 今井真里奈  #h(1cm) \
  学籍番号: 202411955 #h(1cm)\
  クラス名 : クラス4\
  提出日: #today.display()\
  締め切り: 10月16日 \
  課題名:   課題2：連結リスト，スタック，キュー \
])

---

// --- 本文 ---
#v(3em)
10/26日に全学停電があることを失念しており、課題の詳細が確認できませんでした。\
レポートの形式面でのミスや、課題のテンプレートファイルの確認ができていないことに起因するミスは見逃していただきたいです。

#v(3em)
== 課題2-1 連結リスト

コードの本質的な部分は以下である。

#```
void insert_cell(Cell *p, int d) {
    Cell *new_cell = (Cell*)malloc(sizeof(Cell));
    new_cell->data = d;
    new_cell->next = (p -> next);
    p -> next = new_cell; 
    return ;
}

void insert_cell_top(int d) {
    Cell *new_cell = (Cell*)malloc(sizeof(Cell));
    new_cell->data = d;
    new_cell->next = head;
    head = new_cell;
    return;
}

void delete_cell(Cell *p) {
   Cell *previous_cell =  NULL;
   Cell *current_cell = head;
   if (p == head){
    head = head -> next;
   }else{
    while (current_cell -> next != p){
    current_cell = current_cell -> next;
   }
    current_cell -> next = p -> next ;
   }  
    free(p);
}

void delete_cell_top(void) {
    Cell *old_head = head;
    head = head->next; 
    free(old_head);
    return;
}

void display(void) {
   Cell *current_cell = head;
   while (current_cell != NULL){ 
        printf("%d", current_cell->data); 
        current_cell = current_cell->next;
        if (current_cell != NULL) { 
            printf(" ");
        }
    }
    printf("\n");
}
```

display関数から説明する。\
まず、この関数は自身の見ているセルを先頭に指定する。
\
次に、自身が見ているセルのポインタ(ポインタが指す値ではなく、ポインタそのもの)がnullであるかどうかをチェックする。NULLであれば繰り返しから抜け、そうでなければ自身が指すデータの値を表示し、今見ているセルを次のセルに移動する。この移動後の時点で、自身が末尾でなければ空白を表示する。そして、この、次に...以降の作業を繰り返す。
\ 
最後にループを抜けたあと、改行を表示する。\

insert_cellについて説明する。\
新しいセルを作成し、そのセルを関数にポインタとして渡されたセルの次に挿入する必要がある。このとき、\
p => (p->nextで示されるセル)\
という並びから、\
p => 新しいセル =>  (p->nextで示されるセル) \
という並びに変化することに留意し、 p->next と new_cell -> next に適切な値を入れてやれば良い。\

insert_cell_topについて説明する。\
insert_cellとの違いは、前のセルが存在しないことである。\
新しいポインタの次(new_cell -> next)に、もともとの先頭(書き換え前のhead)を先頭のセルを示すheadに新しいセルのポインタを代入すれば良い。\

delete_cellに付いて説明する。\
指定されたセルを削除するのに、指定されたセルの前のセルに対して書き換えがあることに留意する。\
このとき、指定されたセルが先頭であれば、headが指すセルを、指定されたセルの次のセルに変更したあと、指定されたセルのメモリを解法することで削除する。\
先頭でない場合、前のセルを探す必要がある。前のセル、と言うのは  当該セルの持つ -> next が指す先が、削除指定されたセルであれば、当該セルは削除指定された前のセルである。headから、 -> next　を辿ってまえのセルを見つける。前のセルを見つけたら、そのセルの指す -> next を、(p -> next)に変更する。\
その後、指定されたセルを削除する。\

delete_cell_topについて説明する。\
head を、 現在のセルの次のセルに変更したあと、今までの先頭セルのメモリをfreeする。\

== 課題2-2 キューの実装
 今回のキューは循環する(リングバッファ)。queue -> buffer がキューの本体となる配列であり、今回はint型のみが格納される想定である。length は buffer　のサイズであり、リングバッファの性質上、実際に格納できるのはlength -1 個の要素である。\
また、front がデータ取り出し口で、 rear は データを格納する点である。\

以下にコードを示す。\

#``` 
void enqueue(Queue *q, int d){
    if ((q -> rear + 1) % q -> length == q -> front){
       exit(EXIT_FAILURE);
    }
    q -> buffer[q -> rear] = d;
    q -> rear = (q -> rear + 1) % q -> length; 
}

int dequeue(Queue *q){
    if (q -> front == q-> rear){
        exit(EXIT_FAILURE);
    }
    
    int ret_val =  q -> buffer[q -> front];
    q -> front = (q -> front + 1) % q -> length;
    return ret_val;
}

void display(Queue *q){
    if (q -> front == q-> rear){
        printf("\n"); 
        return;
    }
    
    int current = q -> front;
    
    while (current != q -> rear){
        printf("%d", q -> buffer[current]);
        
        current = (current + 1) % q -> length;
        if (current != q -> rear) {
            printf(" ");
        }
    }
    printf("\n"); 
}
void delete_queue(Queue *q){
    free(q -> buffer);
    free(q);
}
```

enqueue 関数について説明する。\
この関数では、queueの末尾に値を挿入する。データ格納口の次のキューの番号が、データ取り出し口である場合、queueは満杯であるためエラーとなる。\
満杯でないのなら末尾にデータを挿入し、rearの値を一つ進める。一周して戻って来るところの処理はmodを使う。\

dequeueについて説明する。\
front = rear なら、キューは空であるためエラーにする。そうでないなら、frontが示すデータを取得したあと、frontのインデックスを進める。エンキュー同様に、一周する場合の処理を行い、取得したデータをreturn する。セルと違って、intが入るべきキューのバッファにNULLを入れることはできない。キューとして値が入っている場所の処理はfront,rearによって行われているため、連結リストでのfree(cell_pointer)に当たる処理は存在しない。\

display関数について説明する。\
front = rear なら、空であるため、改行のみ行う。\
そうでないなら、frontから順にrearに到達するまで、格納しているデータとスペースを順に出力する。\
rearに到達したら繰り返しを抜け、改行を出力する。\
deleteは、bufferとして確保した領域と、構造体自身のメモリを解法する。











