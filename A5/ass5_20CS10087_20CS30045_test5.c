int main(){
    int i, j, k=0;
    for(i=0; i<10; i++){
        for(j=5; j<=i; j++){
            k += i*j;
        }
    }
    while(k>0){
        k /= 10;
    }
    do{
        k -= j;
        j += i;
        int n=5;
        while(n>=0)
            n--;
    }while(i%j != 0);
    return 0;
}