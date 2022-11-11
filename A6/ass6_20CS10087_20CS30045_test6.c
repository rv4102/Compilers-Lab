int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

void printNums(int curr, int limit)
{
    if (curr > limit)
    {
        return;
    }
    printInt(curr);
    if (curr == limit)
    {
        printStr("\n");
    }
    else
    {
        printStr(" ");
        printNums(curr + 1, limit);
    }
}

int fibNum(int x)
{
    if (x == 0)
    {
        return 0;
    }
    else if (x == 1)
    {
        return 1;
    }
    else
    {
        return fibNum(x - 1) + fibNum(x - 2);
    }
}

int main()
{
    printStr("\n********* TEST 6 *********");
    int start, end, ep;
    printStr("\nEnter start: ");
    start = readInt(&ep);
    if (ep != 0)
    {
        printStr("Invalid start\n");
        return 0;
    }
    printStr("Enter end: ");
    end = readInt(&ep);
    if (ep != 0)
    {
        printStr("Invalid end\n");
        return 0;
    }
    if (start > end)
    {
        printStr("Invalid range\n");
        return 0;
    }
    printStr("Numbers from ");
    printInt(start);
    printStr(" to ");
    printInt(end);
    printStr(" are: ");
    printNums(start, end);

    printStr("\n\nEnter value of x (<40) to find the nth fibonacci number: ");
    int x;
    x = readInt(&ep);
    if (ep != 0)
    {
        printStr("Invalid x\n\n");
        return 0;
    }
    else if (x >= 40)
    {
        printStr("x should be less than 40\n\n");
        return 0;
    }
    else
    {
        printStr("\nfib(");
        printInt(n);
        printStr(") = ");
        printInt(fibNum(n));
        printStr("\n\n");
    }
    return 0;
}