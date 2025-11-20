package main;
import "fmt";

func incr(x int) int {
  x++
  return x
};

func main() {
  v := incr(1)
  for (v < 5) {
    v = v + 1
  }
  fmt.Print(v)
};
