int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

void num(int n)
{
    printStr("Value  = ");
    printInt(n);
}

int main()
{
    printStr("\n********* TEST 1 ***********");
    int n1, n2, n3, n4;
    n1 = 15;
    n2 = 8;
    n3 = 9;
    n4 = -33;

    printStr("\nn1 = ");
    printInt(n1);
    printStr("\nn2 = ");
    printInt(n2);
    printStr("\nn3 = ");
    printInt(n3);
    printStr("\nn4 = ");
    printInt(n4);

    int n5 = n1 + n2;
    int n6 = n1 - n2;
    int n7 = n1 * n2;
    int n8 = n1 / n2;
    int n9 = n1 % n2;

    printStr("\nn1 + n2 = ");
    printInt(n5);
    printStr("\nn1 - n2 = ");
    printInt(n6);
    printStr("\nn1 * n2 = ");
    printInt(n7);
    printStr("\nn1 / n2 = ");
    printInt(n8);
    printStr("\nn1 % n2 = ");
    printInt(n9);

    int n10 = -n1 + n2 - n3 + n4 + 10;
    int n11 = n1 * n2 / n3 + n4 - 10;
    int n12 = n1 + n2 * n3 / n4 - 0;
    int n13 = (n1 + n2) * (-n3 / n4) - 15;
    printStr("\n-n1 + n2 - n3 + n4 + 10 = ");
    printInt(n10);
    printStr("\nn1 * n2 / n3 + n4 - 10 = ");
    printInt(n11);
    printStr("\nn1 + n2 * n3 / n4 - 0 = ");
    printInt(n12);
    printStr("\n(n1 + n2) * (n3 / n4) - 15 = ");
    printInt(n13);
    printStr("\n-n3 = ");
    printInt(-n3);
    printStr("\n-n4 = ");
    printInt(-n4);

    printStr("\nPre increment test: ");
    num(++n1);
    printStr(", Value after pre increment call = ");
    printInt(n1);

    printStr("\nPost increment test: ");
    num(n1++);
    printStr(", Value after post increment call = ");
    printInt(n1);

    printStr("\nPre decrement test: ");
    num(--n1);
    printStr(", Value after pre increment call = ");
    printInt(n1);

    printStr("\npost decrement test: ");
    num(n1--);
    printStr(", Value after post decrement call = ");
    printInt(n1);
    printStr("\n\n");
    return 0;
}