/* Test file */

extern int value;
auto V = 10;
static const long INF = 1e9;
volatile long y = 10;
_Bool x = 1;
enum week { Mon = 1, Tue, Wed, Thur, Fri, Sat, Sun };

// Solves the all-pairs shortest path
// problem using Floyd Warshall algorithm
void floydWarshall(int graph[][V])
{
    /* dist[][] will be the output matrix
      that will finally have the shortest
      distances between every pair of vertices */
    int dist[V][V], i, j, k;
 
    /* Initialize the solution matrix
      same as input graph matrix. Or
       we can say the initial values of
       shortest distances are based
       on shortest paths considering no
       intermediate vertex. */
    for (i = 0; i < V; i++)
        for (j = 0; j < V; j++)
            dist[i][j] = graph[i][j];
 
    /* Add all vertices one by one to
      the set of intermediate vertices.
      ---> Before start of an iteration, we
      have shortest distances between all
      pairs of vertices such that the shortest
      distances consider only the
      vertices in set {0, 1, 2, .. k-1} as
      intermediate vertices.
      ----> After the end of an iteration,
      vertex no. k is added to the set of
      intermediate vertices and the set
      becomes {0, 1, 2, .. k} */
    for (k = 0; k < V; k++) {
        // Pick all vertices as source one by one
        for (i = 0; i < V; i++) {
            // Pick all vertices as destination for the
            // above picked source
            for (j = 0; j < V; j++) {
                // If vertex k is on the shortest path from
                // i to j, then update the value of
                // dist[i][j]
                if (dist[i][k] + dist[k][j] < dist[i][j])
                    dist[i][j] = dist[i][k] + dist[k][j];
            }
        }
    }

    printf("The following matrix shows the shortest distances between every pair of vertices \n");
    for (int i = 0; i < V; i++) {
        for (int j = 0; j < V; j++) {
            if (dist[i][j] == INF)
                printf("%7s", "INF");
            else
                printf("%7d", dist[i][j]);
        }
        printf("\n");
    }
}

int main()
{
    // testing identifiers and constants
    short signed int number0 = 40;  // integer-constant
    enum week _day = Sun;           // enum- constant
    float f1_ = 23.56;              // floating-constant
    float f2_ = 23.E-2;
    float f3_ = 23.56e+3;
    float f4_ = .56E2;
    float f5_ = 232e3;
    char _1 = '$', _2 = '\b';                  // character-constant

    // testing string literals
    char s[2] = "";

    // testing punctuators
    int a = 1, b = 1;
    a++;
    a--;
    a = a&b;
    a = a*b;
    a = a+b;
    a = a-b;
    a = !b;
    a = ~b;
    a = a/b;
    a = a%b;
    a = a<<b;
    a = a>>b;
    a = a^b;
    a = a|b;
    a = (a) ? a : b;
    a *= b;
    a /= b;
    a %= b;
    a += b;
    a -= b;
    a <<= b;
    a >>= b;
    a &= b;
    a ^= b;
    a |= b, b = 0;

    switch (_day) {
        case 1:
            break;
        default:;
    }

    int n = 10, t = 20;
    do {
        n -= 1;
    } while (n > 1);

    for(int i = 0; (i < 3 && i >= 0) || (i > 100 && i != 101); i++) {
        continue;
    }
 
    if (t <= 30) {
        t = 31;
    } else {
        t = 30;
    }

    return 0;
}