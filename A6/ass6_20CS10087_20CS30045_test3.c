int printStr(char *s);
int readInt(int *eP);
int printInt(int n);

int testInt(int num)
{
    return num;
}

int *testIntPtr(int *numPtr)
{
    return numPtr;
}

char testChar(char c)
{
    return c;
}

char *testCharPtr(char *cPtr)
{
    return cPtr;
}

void testVoid()
{
    printStr("\n This function is void and empty like the Bootes void.");
    return;
}

int main()
{
    printStr("\n********* TEST 3 *********");
    int x = 20;
    int *nPtr = &x;

    printStr("\nTesting integer value return: ");
    int retInt = testInt(x);
    if (retInt == x)
    {
        printStr("Passed");
    }
    else
    {
        printStr("Failed");
    }

    printStr("\nTesting integer pointer return: ");
    int *retIntPtr = testIntPtr(nPtr);
    if (retIntPtr == nPtr)
    {
        printStr("Passed");
    }
    else
    {
        printStr("Failed");
    }

    char c = 'x';
    char *cPtr = &c;

    printStr("\nTesting character value return: ");
    char retChar = testChar(c);
    if (retChar == c)
    {
        printStr("Passed");
    }
    else
    {
        printStr("Failed");
    }

    printStr("\nTesting character pointer return: ");
    char *retCharPtr = testCharPtr(cPtr);
    if (retCharPtr == cPtr)
    {
        printStr("Passed");
    }
    else
    {
        printStr("Failed");
    }

    char *str = "We are prepared for the Compilers end-sem. But fir bhi makha ke hi aayenge :,) .";
    printStr("\nTesting string return: ");
    char *retStr = testCharPtr(str);
    if (retStr == str)
    {
        printStr("Passed");
    }
    else
    {
        printStr("Failed");
    }
    printStr(" [ Passed string: ");
    printStr(str);
    printStr(" ], ");
    printStr("[ Returned string: ");
    printStr(retStr);
    printStr(" ]");

    printStr("\nTesting void return: ");
    testVoid();
    printStr("\n\n");
    return 0;
}