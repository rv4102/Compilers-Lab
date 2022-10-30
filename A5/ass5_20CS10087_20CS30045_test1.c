int main(){
    // Arithmetic
    int a;
    a = 5;
    int b, c, d, e;
    b = 9;
    c = -1;
    d = 0;
    e = 15;

    // Shift operators
    a = b << 5;
    c = c >> a;
    a += b;
    a -= b--;
    c %= e;
    e /= c;

    // Bitwise operators
    int x1, x2, res;
    x2 = 0;
    x1 = 1;
    res = (x1 ^x2) & x1;
    res |= x1;
    x1 = !x2;

    // unary operators
    float f1, f2;
    f2 = -f1;
    f1 = 5.0;
    f2 = e++;
    int *p;
    p = &a;

    return 0;
}