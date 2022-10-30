enum days {Mon=1, Tues, Wed, Thurs, Fri, Sat, Sun};

void incr(int x, int *y){
    enum days day = Tues;
    *y = x + day;
}

int main(){
    int x=9;
    int y=6;
    float a=100.0;
    char *str = "Cats are cool";
    incr(x, &y);
    return 0;
}