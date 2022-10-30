int main(){
    int a[5] = {1, 2, 3, 4, 5};
    int *p = a;
    int **q = &a;
    int b[10][5];
    q = &b;
    p = *q;
    b[9][4] = 56;
    float x = b[9][4];
}