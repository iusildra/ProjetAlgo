import Foundation

protocol QuartoProtocol {
	//Représentation des coordonnées
	associatedtype Coordinates = Numeric
	associatedtype Piece = PieceProtocol

	var player1:String { get }
	var player2:String { get }

	//Sélectionne le premier joueur à poser une piece
	//Pré : _
	//Post : choisit un des deux utilisateurs enregistrés
	func choosePlayer() -> String
	
	//Place une pièce sur le plateau
	//Pré : coordonnées valide et pièce disponible
	//Post : place la pièce sur le plateau, ne fais rien sinon et redemande le placement d'une pièce
	mutating func place(user:User, coord: Coordinates) -> Self

	//Choisit la piece à donner à l'autre joueur
	//Pré : pieces non vide et non nil
	//Post : retourne la piece demandé
	func choosePiece(pieces:PieceList) -> Piece

	//Vérifie l'alignement de la pièce placée avec les autres
	//Pré : coordonnées valides
	//Post : false s'il n'y a pas d'alignement. S'il existe un alignement, renvoie true, termine le jeu
	func checkAlignement(coord: Coordinates) -> Bool

	//Lancer la partie
	//Pré : _
	//Post : termine dès qu'un joueur a aligné 4 pièces partageant une même caractérisique et donne le nom du vainqueur, ou si toutes les pieces ont été placé et qu'il n'y a pas d'alignement et donne "égalité"
	func start()

	//Initialise le plateau avec le nom des joueurs
	init()
	
}