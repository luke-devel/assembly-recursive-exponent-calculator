#include <iostream>

using namespace std;

int rexp(int, int);

int main(){
    int a, b;
    cout<<"Enter a: ";
    cin>>a;
    while(a < 1 || a > 21){
        cout<<"\nPlease re-enter 'a' so it matches >> 1 < a <= 21.\n";
        cout<<"Enter a: ";
        cin >> a;
    }
    cout<<"Enter b: ";
    cin>>b;

    while(b < 1 || b > 7){
        cout<<"\nPlease re-enter 'b' so it matches >> 1 < b <= 7.\n";
        cout<<"Enter b: ";
        cin >> b;
    }
    cout<<"\nrexp(a, b) = "<< rexp(a,b) << endl;
    return 0;
}

int rexp(int a, int b){
    if(b==1){
        return a;
    }
    int res = a*(rexp(a, --b));
    return res;
}
