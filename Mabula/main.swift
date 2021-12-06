// Affiche le plateau, avec les index des lignes et colonnes, avec la position des billes, en indiquant leur couleur
// Pré : une instance de Jeu
func affichePlateau(jeu: Jeu){
  print("  0 1 2 3 4 5 6 7")
  for l in 0..<8 {
    var texte = "\(l)"
    for c in 0..<8 {
      texte += " "
      if let b = jeu.getBilleAtPos(horizontale:l, verticale:c) { texte += b.getCouleur() }
      else { texte += "_" }
    }
    print(texte)
  }
}

//Fonction principale
func main() {
  var jeu = Jeu()
  var methode : Int = 0

  repeat {
    print("Veuillez choisir la méthode de calcul \n0 pour la méthode du plus gros groupe de bille \n1 pour la méthode de la multiplication des groupes de bille")
    methode = Int(readLine()!) ?? 0 //0 par défaut
  } while (methode != 1 && methode != 0)


  var joueurActuel : String
  if Int.random(in: 0..<2) % 2 == 0 { joueurActuel = "Blanc"}
  else { joueurActuel = "Noir"}


  affichePlateau(jeu: jeu)
  //Tant que les joueurs peuvent jouer
  while jeu.canPlayerMove(couleur:"Blanc") || jeu.canPlayerMove(couleur:"Noir") {
    print("Tour de \(joueurActuel)")

    if jeu.canPlayerMove(couleur:joueurActuel) {
      var Position_X : Int
      var Position_Y : Int

      repeat {
        print("Entrez la coordonnée x : ", terminator: "")
        Position_X = Int(readLine() ?? "") ?? -1
        print("Entrez la coordonnée y : ", terminator: "")
        Position_Y = Int(readLine() ?? "") ?? -1
      } while !checkSelectCoordinates(jeu: jeu, x: Position_X, y: Position_Y, joueur: joueurActuel) //On sait que Position_X et Position_Y sont des entiers compris entre 0 et 7, qu'il représente une case situé sur un bord mais pas dans un coin, sur laquelle il y a un bille appartenant au joueur actuel qui peut être déplacée vers le centre

      let bille = jeu.getBilleAtPos(horizontale:Position_X, verticale:Position_Y)! //On peut force-unwrap car on a vérifié dans le repeat/while ci-dessus qu'il y avait une bille aux coordonnées indiquées

      var target_X : Int
      var target_Y : Int

      repeat {
        print("Entrez la coordonnée x de la destination : ", terminator: "")
        target_X = Int(readLine() ?? "") ?? -1
        print("Entrez la coordonnée y de la destination : ", terminator: "")
        target_Y = Int(readLine() ?? "") ?? -1
      } while !checkTargetCoordinates(jeu: jeu, billeToMove:jeu.getBilleAtPos(horizontal:Position_X, vertical:Position_Y), x: target_X, y: target_Y) //On sait que la destination est dans le plateau et pas sur un bord, et que soit il y a déjà une bille dessus qu'on peut déplacer sans sortir une autre bille du plateau, soit qu'il n'y a pas de bille, alors la case est libre.

      jeu.moveBilleAtPos(bille: bille, horizontale: target_X, verticale: target_Y)

      affichePlateau(jeu: jeu)

    } else { print("\(joueurActuel) ne peut pas jouer") }

    // Changement de joueur
    if joueurActuel == "Blanc" { joueurActuel = "Noir" }
    else{ joueurActuel = "Blanc" }
  }

  // La partie est fini, on compte les points selon le mode sélectionné
  var scoreBlanc : Int
  var scoreNoir : Int
  if(methode == 0) {
    scoreBlanc = jeu.biggestGroup(couleur: "Blanc")
    scoreNoir = jeu.biggestGroup(couleur: "Noir")
  } else {
    scoreBlanc = jeu.multGroup(couleur: "Blanc")
    scoreNoir = jeu.multGroup(couleur: "Noir")
  }

  print("Joueur Blanc : \(scoreBlanc) points / Joueur Noir : \(scoreNoir) points")
  if (scoreBlanc > scoreNoir){ print("Le gagnant est le joueur Blanc") }
  else {
    if(scoreBlanc < scoreNoir){ print("Le gagnant est le joueur Noir") }
    else{ print("Match Nul !") }
  }
}

// Vérifie si le joueur peut sélectionner une bille à la destination donnée
// Pré : une instance de Jeu, les coordonnées x et y de la case choisie, et la couleur du joueur
// Post : true si l'emplacement contient une bille jouable par le joueur, false sinon
func checkSelectCoordinates(jeu: Jeu, x:Int, y:Int, joueur:String) -> Bool {
  var res : Bool = false
  if x < 0 || y < 0 {
    print("Les coordonnées ne peuvent pas être négatives !")
  }
  else if !jeu.isBorder(horizontale:x, verticale:y) { 
    print("La position n'est pas sur le bord du plateau !")
  }
  else if let bille = jeu.getBilleAtPos(horizontale:x, verticale:y) {
    if bille.getCouleur() != joueur {
      print("La bille ne vous appartient pas !")
    }
    else if !jeu.canBilleMove(bille: bille) {
      print("La bille ne peut pas être déplacée !")
    }
    else { //Si la bille est de la bonne couleur et peut-être déplacée
      res = true
    }
  }
  else {
    print("Il n'y a pas de bille à cet emplacement !")
  }
  return res
}

// Vérifie si le joueur a choisit des bonnes coordonnées pour bouger sa bille
// Pré : une instance de Jeu, la bille précédemment sélectionnée, et les coordonnées x et y de destination
// Post : true si la bille peut être déplacée à cette destination, false sinon
func checkTargetCoordinates(jeu: Jeu, billeToMove: Bille, x:Int, y:Int) -> Bool {
  var res : Bool = false
  if x < 1 || x > 6 || y < 1 || y > 6 { 
    print("Sélectionner une destination au centre du plateau !")
  }
  else if jeu.canBilleMoveAtPos(bille:bille, horizontale:x, verticale:y) { //On peut déplacer la bille sans sortir une autre du plateau
    res = true
  }
  else { 
    print("La bille ne peut pas être déplacée à cet endroit !")
  }
  return true
}

main()