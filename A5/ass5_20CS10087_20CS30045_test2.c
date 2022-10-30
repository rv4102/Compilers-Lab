int main(){
    int a=9, b=10, c=5;
    if(a <= b && b-a > c){
        c |= a;
        if(!a){
            c=69;
        }
    }
    else{
        c = -5;
        a = (b==10)? -9:8;
    }
    
    return 0;
}