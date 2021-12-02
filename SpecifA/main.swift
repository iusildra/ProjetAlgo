import Foundation
import Glibc

typealias Coordinate = (Int,Int)



func main() {
	var quarto = Quarto.init()
	var selected:Int = -1 //Selection du joueur
	let players = initPlayer(select: &selected) //Liste des joueurs
	var alignement:(Coordinate, Coordinate)? = nil
	Glibc.system("clear")

	var i = 0
	while i < 16 && alignement == nil {
		print("##############################\nTour de \(players[selected])\n##############################")
		display(game: quarto)

		let piece = choosePiece(pieces: quarto.getAvailablePieces()) //Selection de la pièce
		let coord = chooseCoordinate(coordList: quarto.getAvailablePositions()) //Selection de la position

		if !quarto.place(piece:piece, coord:coord) {
			//La pièce n'a pas pu être placée
			continue //Empêche de changer de joueur
		}
		let aligned = quarto.checkAlignement(coord:coord)
		if aligned.0 {
			//Il existe un alignement, c'est gagné !
			alignement = aligned.1
			//On sort de la boucle sans changer de player
		} else {
			//Toujours pas d'alignement
			changePlayer(selected: &selected)
		}
		Glibc.system("clear")
	}

	if let align = alignement { //Permet de s'assurer que align n'est pas nil et de pouvoir faire appel à ses éléments.
		changePlayer(selected: &selected) //Le joueur qui a gagné est celui qui n'a pas choisi la pièce, il faut donc changer de joueur
		print("\(players[selected]) a gagné !")
		print("Coordonnées de l'alignment : (\(align.0), \(align.1))")
	} else {
		print("Égalité !")
	}

	i+=1
}


func display(game: Quarto) {
	for elt in game.makeIterator() {
		game.printBoard(elt)
	}
}


//Choisit une pièce parmis les pièces disponibles. Redemande la saisie tant que la saisie n'est pas correcte. Supprime de la liste des pièces la pièce selectionnée
func choosePiece(pieces: [Piece]) -> Piece {
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
	
	return pieces[num]
}


//Choisit une position parmi les positions vides. Redemande la saisie tant que la saisie n'est pas correcte. SUpprime de la liste des positions la position selectionnée
func chooseCoordinate(coordList: [Coordinate]) -> Coordinate {
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

	return coordList[num] //Renvoie la coordonnée et la supprime de la liste

}

//Permet d'effectuer le changement de joueur
func changePlayer(selected: inout Int) {
	selected = (selected+1)%2
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