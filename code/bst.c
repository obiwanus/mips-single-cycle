#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <assert.h>

#define TRUE 1
#define FALSE 0

struct Node {
  int data;
  Node *left;
  Node *right;
  Node *parent;
};

struct BST {
  Node *root;
};

Node *new_node(int data, Node *parent) {
  Node *node = (Node *)malloc(sizeof(Node));
  node->data = data;
  node->left = NULL;
  node->right = NULL;
  node->parent = parent;
  return node;
}

void insert(Node *node, int data) {
  if (node->data <= data) {
    if (node->right == NULL) {
      node->right = new_node(data, node);
    } else {
      insert(node->right, data);
    }
  } else {
    if (node->left == NULL) {
      node->left = new_node(data, node);
    } else {
      insert(node->left, data);
    }
  }
}

BST *build(int *list) {
  BST *tree = (BST *)malloc(sizeof(BST));
  tree->root = new_node(list[0], NULL);  // assuming size of list >= 1
  int i = 1;
  while (list[i] != INT_MIN) {
    insert(tree->root, list[i]);
    ++i;
  }
  return tree;
}

bool check(Node *node) {
  return (node->left == NULL || (node->left->data < node->data && check(node->left))) && \
         (node->right == NULL || (node->right->data >= node->data && check(node->right)));
}

int sort2list(Node *node, int *o_list) {
  int nodes_sorted = 0;
  if (node->left != NULL) {
    nodes_sorted += sort2list(node->left, o_list);
    o_list += nodes_sorted;  // advance the pointer
  }
  *o_list = node->data;
  o_list++;
  nodes_sorted++;
  if (node->right != NULL) {
    nodes_sorted += sort2list(node->right, o_list);
  }
  return nodes_sorted;
}

int min(Node *node) {
  if (node->left == NULL) {
    return node->data;
  } else {
    return min(node->left);
  }
}

int max(Node *node) {
  if (node->right == NULL) {
    return node->data;
  } else {
    return max(node->right);
  }
}

int min_max(Node *node, int mode) {
  if (mode == 0) {
    return min(node);
  } else {
    return max(node);
  }
}

int find(Node *node, int value, Node **result) {
  if (node->data == value) {
    if (result != NULL) {
      *result = node;
    }
    return 1;
  }
  if (value < node->data) {
    if (node->left != NULL) {
      return find(node->left, value, result);
    } else {
      return 0;
    }
  } else {
    if (node->right != NULL) {
      return find(node->right, value, result);
    } else {
      return 0;
    }
  }
}

void try_to_find(int value, Node *node) {
  Node *result;
  printf("Trying to find %d... ", value);
  int found = find(node, value, &result);
  if (found > 0) {
    printf("Found at %p\n", result);
  } else {
    printf("Not found\n");
  }
}

int main() {
  int source[] = {1, 6, 7, 4, 3, 6, 8, 2, 9, 12, -3, 4, 54, 35, 5, INT_MIN};

  BST *tree = build(source);
  assert(check(tree->root));

  int *list = (int *)malloc(1000 * sizeof(*list));
  int nodes_sorted = sort2list(tree->root, list);
  for (int i = 0; i < nodes_sorted; ++i) {
    printf("(%d)-", list[i]);
  }

  printf("\n");

  printf("Min is %d\n", min_max(tree->root, 0));
  printf("Max is %d\n", min_max(tree->root, 1));

  try_to_find(1, tree->root);
  try_to_find(2, tree->root);
  try_to_find(-10, tree->root);
  try_to_find(-3, tree->root);

  return 0;
}
