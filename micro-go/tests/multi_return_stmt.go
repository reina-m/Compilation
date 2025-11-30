package main;

// appel multi-retour utilisé comme instruction (valeurs ignorées)

func pair() (int, int) {
  return 7, 8,
};

func main() {
  // doit s'exécuter sans fuite de pile, même si les valeurs sont jetées
  pair()
  fmt.Print(0)
};
