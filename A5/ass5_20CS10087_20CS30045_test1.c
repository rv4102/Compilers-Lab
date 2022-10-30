int main(){
    // Arithmetic
    int a = 5;
    int b=9, c=-1, d=0, e;
    e = 15;

    // Shift operators
    a = b << 5;
    c = c >> a;
    a += b;
    a -= b--;
    c %= e;
    e /= c;

    // Bitwise operators
    int x1 = 1, x2 = 0, res;
    res = (x1 ^x2) & x1;
    res |= x1;
    x1 = !x2;

    // unary operators
    float f1=5.0, f2=-f1;
    f2 = e++;
    int *p = &a;

    return 0;
}