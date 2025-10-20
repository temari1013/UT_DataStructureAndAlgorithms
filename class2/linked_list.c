#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"

Cell *head = NULL;

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
    Cell *new_head = head -> next;
    Cell *current_cell = head;
    while (current_cell -> next != NULL){
        current_cell = current_cell-> next;
    }
    current_cell -> next = NULL;
    Cell *old_head = head;
    head = head->next;
    free(old_head);
    return ;
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
