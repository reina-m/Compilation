package main;

// exercice multi-retours / multi-assignations : s'appuie sur swap pour vérifier la
// simultanéité et la convention de buffer caché côté appelant.

func swap(a, b int) (int, int) {
  return b, a,
};

func three() (int, int, int) {
  return 1, 2, 3,
};

func main() {
  x, y := swap(10, 20);   // buffer de 2 valeurs
  fmt.Print(x);           // 20
  fmt.Print(y);           // 10

  // test de simultanéité : x,y = y,x doit échanger
  x, y = y, x,
  fmt.Print(x);           // 10
  fmt.Print(y);           // 20

  // mix avec appel multi-retour de longueur 3
  a, b, c := three()
  fmt.Print(a);           // 1
  fmt.Print(b);           // 2
  fmt.Print(c);           // 3

  // réaffectation en combinant une constante et un appel multi-retour
  a, b, c = 99, swap(a, b),
  fmt.Print(a);           // 99
  fmt.Print(b);           // 2 (ex-swap)
  fmt.Print(c);           // 1 (ex-swap)
};
