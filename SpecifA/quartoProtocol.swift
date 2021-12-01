import Foundation

protocol QuartoProtocol {
	//coordonnées en (y,x)
	associatedtype Coordinates = (Int,Int)
	
	//Place une pièce sur le plateau
	//Pré : coordonnées valide et non occupée et pièce disponible
	//Post : renvoie false si la piece n'a pas pu être placé, true sinon
	mutating func place(piece:Piece, coord: Coordinates) -> Bool

	//Vérifie l'alignement de la pièce placée avec les autres
	//Pré : coordonnées valides  et occupée
	//Post : false s'il n'y a pas d'alignement. S'il existe un alignement, renvoie true, termine le jeu
	func checkAlignement(coord: Coordinates) -> Bool

	//Initialise le plateau avec le nom des joueurs et les pièces. Ne met aucune pièce qui a exactement les mêmes caractéristiques. Il doit exister 4 sets de 4 pièces différentes ayant au moins 1 caractéristiques différents
	//Pré : _
	//Post : _
	init()
	
}

struct Quarto:QuartoProtocol {
	typealias Coordinates = (Int,Int)

	mutating func place(piece: Piece, coord: Coordinates) -> Bool {
		return true
	}

	func checkAlignement(coord: Coordinates) -> Bool {
		return false
	}

	init() {
		
	}
	
}