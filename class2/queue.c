#include <stdio.h>
#include <stdlib.h>
#include "queue.h"
Queue *queue = NULL;
Queue *create_queue(int len){
    Queue *new_queue =  (Queue*)malloc(sizeof(Queue));
    new_queue -> buffer = malloc(sizeof(int) * len);
    new_queue -> length = len ;
    new_queue -> front = 0;
    new_queue -> rear = 0;
    queue = new_queue;
    return new_queue;
}
void enqueue(Queue *q, int d){
    if (queue -> front == queue -> rear){
        // エラー
        return ;
    }else{
        queue -> buffer[queue -> rear] = d;
        if (queue -> rear == (queue-> length)-1){
            queue -> rear = 0;
        }else{
            queue -> rear += 1;
        }
    }
}

int dequeue(Queue *q){

}
void display(Queue *q){

}
void delete_queue(Queue *q){

}