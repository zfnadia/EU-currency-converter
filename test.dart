

int square(int x){
  return x*x;
}

void main(){
  var li = [1, 4, 5];
  var newLi = li.map((x) => square(x));
  print(newLi);


}