#include <stdio.h>
#include <stdlib.h>
#include "queue.h"


Queue *create_queue(int len){
    Queue *new_queue =  (Queue*)malloc(sizeof(Queue));
    new_queue -> buffer = malloc(sizeof(Node**) * len);
    new_queue -> length = len ;
    new_queue -> front = 0;
    new_queue -> rear = 0;
    return new_queue;
}

void enqueue(Queue *q, Node *d){
    if ((q -> rear + 1) % q -> length == q -> front){
       exit(EXIT_FAILURE);
    }
    q -> buffer[q -> rear] = d;
    q -> rear = (q -> rear + 1) % q -> length; 
}


 Node*  dequeue(Queue *q){
    if (q -> front == q-> rear){
        exit(EXIT_FAILURE);
    }
    
    Node* ret_val =  q -> buffer[q -> front];
    q -> front = (q -> front + 1) % q -> length;
    return ret_val;
}




void delete_queue(Queue *q){
    free(q -> buffer);
    free(q);
}