enum days {Mon, Tues, Wed, Thurs, Fri, Sat, Sun};

void incr(int x, int *y){
    enum days day;
    day = Tues;
    *y = x + day;
}

int main(){
    int x,y;
    x=9;
    y=6;
    float a;
    a=100.0;
    char *str;
    str = "Cats are cool";
    incr(x, &y);
    return 0;
}