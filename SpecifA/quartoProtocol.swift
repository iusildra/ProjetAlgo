import Foundation

protocol QuartoProtocol {
	//Représentation des coordonnées
	associatedtype Coordinates = Numeric
	associatedtype User = UserProtocol
	associatedtype Piece = PieceProtocol

	//Sélectionne le premier joueur à poser une piece
	//Pré : _
	//Post : choisit un des deux utilisateurs enregistrés
	func choosePlayer() -> User
	
	//Place une pièce sur le plateau
	//Pré : coordonnées valide et pièce disponible
	//Post : place la pièce sur le plateau, ne fais rien sinon et redemande le placement d'une pièce
	mutating func place(user:User, coord: Coordinates) -> Self

	//Vérifie l'alignement de la pièce placée avec les autres
	//Pré : coordonnées valides
	//Post : false s'il n'y a pas d'alignement. S'il existe un alignement, renvoie true, termine le jeu
	func checkAlignement(coord: Coordinates) -> Bool

	init()
	
}