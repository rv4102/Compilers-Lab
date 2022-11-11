int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

int max(int n1, int n2)
{
    if (n1 > n2)
        return n1;
    else
        return n2;
}

int main()
{
    printStr("\n********* TEST 5 *********\n");

    printStr("\nPattern printing using FOR loop: ");
    printStr("\n\n");

    int n = 16;
    int i, j;
    for (i = 1; i <= 2 * n - 1; i++)
    {
        int x1 = n + 1 - i;
        int x2 = i - n + 1;
        for (j = 1; j <= 2 * n - 1; j++)
        {
            int y1 = n + 1 - j;
            int y2 = j - n + 1;
            printInt(max(max(x1, x2), max(y1, y2))); // nested function call check
            printStr(" ");
        }
        printStr("\n");
    }
    printStr("\n");

    int pow3 = 1;
    printStr("\nPowers of 3 using *WHILE* loop: ");
    while (pow3 <= 729)
    {
        printInt(pow3);
        printStr(" ");
        pow3 = pow3 * 3;
    }
    printStr("\n\n");

    i = 0;
    int iters, ep;
    printStr("\nTesting DO-WHILE loop: ");
    do{
        if (i == 0)
        {
            printStr("\n We are in the do while loop. Please enter how many times it should execute: ");
            iters = readInt(&ep);
            if (ep != 0)
            {
                printStr("\nInvalid input. Exiting...\n\n");
                return 0;
            }
        }
        else
        {
            printStr("\nIteration ");
            printInt(i);
            printStr("\n");
        }
    }while (i++ < iters);

    printStr("\n\n");
    return 0;
}