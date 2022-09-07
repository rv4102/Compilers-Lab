enum months {Jan = 1, Feb, Mar, Apr, May, June, July, Aug, Sept, Oct, Nov, Dec};

typedef signed int si;
typedef unsigned long ul;

static const double e = 2.7183;
double d = .244f; // this is not recognised correctly due to the assignment's definition of lexer
auto b = 50;
_Bool tf = 1;

struct node {
    int val;
    struct node* next;
};

union a{
    int y;
};

inline char name (char c);

signed main(){
    // test identifiers and constants
    enum months _m = Feb;
    float f1_ = 2.456;
    float f2_ = .45;
    float f3_ = -.214e23; // this is not recognised correctly due to the assignment's definition of lexer
    float f4_ = 69.E-2;
    char _1 = '†';
    char _2 = '₹';

    // testing strings
    char *s = "abcd";
    char c1 = ''; // invalid character
    char s[10];
    s = "abcda\n";
    char *str = "This is group 69.\t jg_in_cf is Jatin\'s codeforces id.\n";

    // testing punctuators
    int a = 6, b = 70l; // this is not recognised correctly due to the assignment's definition of lexer
    a = (a&b) ^ (a|b) + (a*b) + ~b - (a&1);
    b = (a>>b) ^ (b<<a) * b+a;
    a = (a>b)? a:b;
    a += b;
    a <<= b;
    b = 0;

    struct node *head;
    if(!head){
        head = head->next;
    }

    switch(_m){
        case 1:
            a -= b;
            break;
        default:
            a ^= b;
    }

    int i=0, j=69;
    do{
        i++;
        j--;
    }while(i<j);

    for(int i = 0; (i < 69 && i >= 0) || (i > 169 && i != 420); i++) {
    	continue;
    }

    if(i!=j){
        i ^= j;
    }
    else{
        j ^= i;
    }
}