int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

void fillFib(int *fib, int n)
{
    int i;
    fib[0] = 0;
    for (i = 1; i <= n; i++)
    {
        if (i == 1)
        {
            fib[i] = 1;
        }
        else
        {
            fib[i] = fib[i - 1] + fib[i - 2];
        }
    }
}

int main()
{
    printStr("\n********* TEST 2 *********");
    int fib[21];
    fillFib(fib, 20);
    int i;
    printStr("\nFibonacci Series: ");
    for (i = 1; i <= 20; i++)
    {
        printInt(fib[i]);
        printStr(" ");
    }
    char vowels[5];
    vowels[0] = 'a';
    vowels[1] = 'e';
    vowels[2] = 'i';
    vowels[3] = 'o';
    vowels[4] = 'u';
    printStr("\nAscii values of vowels: ");
    for (i = 0; i < 5; i++)
    {
        printInt(vowels[i]);
        printStr(" ");
    }
    printStr("\n\n");
    return 0;
}