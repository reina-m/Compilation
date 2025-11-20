package main;

func swap(a,b int) (int,int) {
  return b,a,
};

func main() {
  x,y := swap(1,2)
  x,y = y,x,
};
