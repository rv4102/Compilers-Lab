int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

int main()
{
    printStr("\n*********** TEST 7 ************\n");

    int n1, n2;

    n1 = 1, n2 = 1;
    printStr("\nTesting (==) operator: ");
    if (n1 == n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    n2 = 2;
    printStr("\nTesting (!=) operator: ");
    if (n1 != n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    n1 = -6, n2 = -2;
    printStr("\nTesting < operator: ");
    if (n1 < n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    n2 = 5;
    printStr("\nTesting < operator: ");
    if (n1 < n2)
    {
        printStr("FAIL");
    }
    else
    {
        printStr("PASS");
    }
    printStr("\nTesting <= operator: ");
    if (n1 <= n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    n1 = 10;
    printStr("\nTesting <= operator: ");
    if (n1 <= n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    n1 = 66;
    printStr("\nTesting > operator: ");
    if (n1 > n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    n2 = 1;
    printStr("\nTesting > operator: ");
    if (n1 > n2)
    {
        printStr("FAIL");
    }
    else
    {
        printStr("PASS");
    }
    printStr("\nTesting >= operator: ");
    if (n1 >= n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    n1 = -10;
    printStr("\nTesting >= operator: ");
    if (n1 >= n2)
    {
        printStr("PASS");
    }
    else
    {
        printStr("FAIL");
    }

    printStr("\n\n");
    return 0;
}