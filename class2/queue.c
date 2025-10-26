#include <stdio.h>
#include <stdlib.h>
#include "queue.h"


Queue *create_queue(int len){
    Queue *new_queue =  (Queue*)malloc(sizeof(Queue));
    new_queue -> buffer = malloc(sizeof(int) * len);
    new_queue -> length = len ;
    new_queue -> front = 0;
    new_queue -> rear = 0;
    return new_queue;
}

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
        printf("\n"); // 空の場合は改行のみ
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