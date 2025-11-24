#include "binarytree.h"
#include "queue.h"
#include <stdlib.h>
#include <stdio.h>

Node *create_node(char *label, Node *left, Node *right){
     Node *new_node  =  (Node*)malloc(sizeof(Node));
     new_node -> left = left;
     new_node -> right = right;
     new_node -> label = label;

     return new_node;
}



void preorder_r(Node *n){
 //行きがけ
  printf(" ");
    printf("%c", *(n->label));
   if (n ->left){
   preorder_r(n-> left);
   }

   if (n ->right){
  
    preorder_r(n-> right);
   }
}

void inorder_r(Node *n){
    //通りがけ
    // 左 -> 根 -> 右
     if (n ->left){
        
        inorder_r(n-> left);
        
    
   }
printf(" ");
     printf("%c", *(n->label));
    if (n ->right){
        
    inorder_r(n-> right); 
   
}


   
}

void postorder_r(Node *n){

     if (n ->left){
        postorder_r(n-> left);
   }
   if (n ->right){
    postorder_r(n-> right);
    }
    printf(" ");
    printf("%c", *(n->label));
   
}
void preorder(Node *n){
    printf("PRE:");
    preorder_r(n);
    printf("\n");
}

void inorder(Node *n){
    printf("IN:");
    inorder_r(n);
    printf("\n");
}

void postorder(Node *n){
    printf("POST:");
    postorder_r(n);
    printf("\n");
}

void breadth_first_search(Node *n){
    Queue* queue = create_queue(100);
    enqueue(queue, n);
    int is_first = 1;
    while(queue->front != queue->rear){
        Node *current = dequeue(queue);
        if (!is_first) {
            printf(" ");
        }
        printf("%c", *(current->label));
        is_first = 0;
        if(current->left){
             enqueue(queue, current->left);
        }
        if(current->right){
             enqueue(queue, current->right);
        }
    }
    printf("\n");
    delete_queue(queue);
}




void display_r(Node *n){
 printf("%c", *(n->label)); //先頭のラベルの値
 printf("(");
 if(n->left){
    display_r(n->left); 
 }else printf("null");

  printf(",");
  if(n->right){
display_r(n->right); 
  }else printf("null");

  printf(")");
     
}

void display(Node *n){
    display_r(n);
     printf("\n");
}
int max(int a, int b) {
    if (a > b)
        return a;
    else
        return b;
}

int height(Node *n){
    int height_1 =1;
     int height_2 =1;
    if(n->left){
        height_1 =1 +height(n->left);
    }
    if(n->right){
        height_2 =1 +height(n->right);
    }
return (max(height_1,height_2));
}

void delete_tree(Node *n){
    if(n->left)delete_tree(n->left);
    if(n->right)delete_tree(n->right);
    
    free(n);
}