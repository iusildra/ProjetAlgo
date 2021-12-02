import Foundation
import Glibc

typealias Coordinates = (Int,Int)

func main() {
	var quarto = Quarto.init()
	var gameOver = false
	var selected:Int = -1 //Selection du joueur
	var pieces = initPieces() //Liste des pièces
	var positions = initPositions() //Liste des positions disponibles
	let players = initPlayer(select: &selected) //Liste des joueurs
	Glibc.system("clear")

	while pieces.count != 0 && !gameOver {
		print("##############################\nTour de \(players[selected])\n##############################")
		let piece = choosePiece(pieces: &pieces) //Selection de la pièce
		let coord = chooseCoordinate(coordList: &positions) //Selection de la position

		if !quarto.place(piece:piece, coord:coord) {
			//La pièce n'a pas pu être placée
			pieces.append(piece) //On remet la pièce choisie dans la liste
			positions.append(_: coord) //On remet la position dans dans le panier des possibilités
			continue //Empêche de changer de joueur
		}

		if quarto.checkAlignement(coord:coord) {
			//Il existe un alignement, c'est gagné !
			gameOver = true
			//On sort de la boucle sans changer de player
		} else {
			//Toujours pas d'alignement
			changePlayer(selected: &selected)
		}
		Glibc.system("clear")
	}

	if gameOver {
		changePlayer(selected: &selected) //Le joueur qui a gagné est celui qui n'a pas choisi la pièce, il faut donc changer de joueur
		print("\(players[selected]) a gagné !")
	} else {
		print("Égalité !")
	}
}


//Choisit une pièce parmis les pièces disponibles. Redemande la saisie tant que la saisie n'est pas correcte. Supprime de la liste des pièces la pièce selectionnée
func choosePiece(pieces: inout [Piece]) -> Piece {
	print("\n###############\nListe des pièces\n###############")
	for i in 0..<pieces.count {
		print("Piece \(i) : ", terminator: "")
		if pieces[i].tall { print("grande, ", terminator: "") }
		else { print("petite, ", terminator: "") }
		if pieces[i].dark { print("sombre, ", terminator: "")}
		else { print("claire, ", terminator: "") }
		if pieces[i].square { print("carré, ", terminator: "")}
		else { print("ronde, ", terminator: "") }
		if pieces[i].full { print("pleine") }
		else { print("vide") }
	}
	var num = -1
	repeat {
		print("Entrez un numéro de pièce (0->\(pieces.count-1)): ", terminator: "")
		num = Int(readLine()!) ?? -1
	} while num<0 || num>=pieces.count
	
	return pieces.remove(at: num)
}


//Choisit une position parmi les positions vides. Redemande la saisie tant que la saisie n'est pas correcte. SUpprime de la liste des positions la position selectionnée
func chooseCoordinate(coordList: inout [Coordinates]) -> Coordinates {
	print("\n###############\nListe des positions\n###############")
	for i in 0..<coordList.count {
		if i>0 && i%4==0 { print() }
		print("\(i). \(coordList[i])", terminator: "\t")
	}
	print()

	var num = -1
	repeat {
		print("Entrez un numéro de position (0->\(coordList.count-1)) : ", terminator: "")
		num = Int(readLine()!) ?? -1
	} while num<0 || num>=coordList.count

	return coordList.remove(at: num) //Renvoie la coordonnée et la supprime de la liste

}

//Permet d'effectuer le changement de joueur
func changePlayer(selected: inout Int) {
	selected = (selected+1)%2
}

//Ajout des pièces aux jeux (voir règle du quarto). Ici il s'agit du premier set possible (celui du gauche sur les règles)
func initPieces() -> [Piece] {
	var pcs = [Piece?](repeating: nil, count:16)
	//Set n°1.1
	pcs[0] = (Piece.init(tall:false, dark:false, full: true, square:true))
	pcs[1] = (Piece.init(tall:true, dark:false, full: true, square:false))
	pcs[2] = (Piece.init(tall:true, dark:false, full: true, square:true))
	pcs[3] = (Piece.init(tall:false, dark:false, full: false, square:false))
	//Set n°1.2
	pcs[4] = (Piece.init(tall:false, dark:true, full: false, square:false))
	pcs[5] = (Piece.init(tall:true, dark:false, full: false, square:false))
	pcs[6] = (Piece.init(tall:true, dark:true, full: true, square:false))
	pcs[7] = (Piece.init(tall:false, dark:false, full: true, square:false))
	//Set n°1.3
	pcs[8] = (Piece.init(tall:true, dark:false, full: true, square:false))
	pcs[9] = (Piece.init(tall:true, dark:true, full: false, square:true))
	pcs[10] = (Piece.init(tall:true, dark:true, full: false, square:false))
	pcs[11] = (Piece.init(tall:true, dark:false, full: true, square:true))
	//Set n°1.4
	pcs[12] = (Piece.init(tall:true, dark:false, full: false, square:false))
	pcs[13] = (Piece.init(tall:false, dark:true, full: false, square:true))
	pcs[14] = (Piece.init(tall:true, dark:true, full: false, square:true))
	pcs[15] = (Piece.init(tall:false, dark:false, full: false, square:false))

	return pcs.compactMap{ $0 }
}


//Initialisation de toutes les positions possibles
func initPositions() -> [(Int,Int)] {
	var positions = [(Int,Int)](repeating: (-1, -1), count: 16)
	for i in 0..<4 {
		for j in 0..<4 {
			positions[4*i+j] = (i, j)
		}
	}
	return positions
}

//Initialisation des joueurs, et selectionne le premier joueur
func initPlayer(select: inout Int) -> [String] {
	var players = [String](repeating: "", count: 2)
	for i in 0..<players.count {
			print("Entrez le nom du joueur \(i+1) : ", terminator: "")
			players[i] = readLine()!
		}

	select = Int.random(in: 0..<2) //Selectionne le premier joueur
	return (players)
}

main()