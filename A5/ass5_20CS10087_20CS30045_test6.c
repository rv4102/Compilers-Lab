int gcd(int a, int b);

int diff(int a, int b){
    // gives index of first differing bits in a and b
    int n = a^b;
    int c = n & (n-1);
    int idx=0;
    while(c >0){
        c = c>>1;
        idx++;
    }
    return idx;
}

int gcd(int a, int b) {
    if(b == 0)
        return a;
    return gcd(b, a % b);
}

int main() {
    int a = 9, b = 3;
    gcd(a, b);
    diff(a, b);
    return 0;
}