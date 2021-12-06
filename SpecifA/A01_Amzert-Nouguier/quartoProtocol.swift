import Foundation

protocol QuartoProtocol: Sequence {
	//coordonnées en (y,x)
	associatedtype Coordinate = (Int,Int)
	associatedtype Iterator = QuartoIteratorProtocol

	//Initialise le plateau, toutes les positions sont vides et initialise toutes les pièces disponibles
	//Pré : _
	//Post : _
	init()
	
	//Place une pièce sur le plateau
	//Pré : coordonnée valide et non occupée et pièce disponible
	//Post : Supprime de la liste des pièces et de la liste de coordonnées la pièce et coordonnée choisies
	mutating func place(piece:Piece, coord: Coordinate)

	//S'assure de la conformité des coordonnées
	//Pré : _
	//Post : renvoie true si les coordonnées sont valides (0<=x,y<4 et (x,y) non occupé), false sinon
	func checkCoordinates(coord:Coordinate) -> Bool

	//S'assure de la conformité du choix de la pièce
	//Pré : _
	//Post : renvoie true si la pièce est disponible, false sinon
	func checkPiece(coord:Coordinate) -> Bool

	//Vérifie l'alignement de la pièce placée avec les autres. Il y a alignement lorsque 4 pièces adjacente partage une même caractéristiques. L'alignement peut être horizontal, vertical ou en diagonale. Une variante consiste à avoir un carré de pièces adjacentes. Renvoie aussi les coordonnées de l'alignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func checkAlignement(coord: Coordinate) -> (Coordinate, Coordinate)?

	//Vérifie l'alignement horizontal. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func horizontalAlign(coord: Coordinate) -> (Coordinate, Coordinate)?

	//Vérifie l'alignement vertical. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func verticalAlign(coord: Coordinate) -> (Coordinate, Coordinate)?

	//Vérifie l'alignement diagonal. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le début et la fin de l'alignement
	func diagonalAlign(coord: Coordinate) -> (Coordinate, Coordinate)?

	//OPTIONNEL
	//Vérifie l'alignement en carré. Renvoie aussi les coordonnées de l'alignement. Appelé dans checkAlignement
	//Pré : coordonnée valide et occupée
	//Post : nil s'il n'y a pas d'alignement. S'il existe un alignement, renvoie un tuple de coordonnée qui symbolise le coin supérieur gauche et le coin inférieur droit
	//func squareAlign(coord: Coordinate) -> (Coordinate, Coordinate)?

	//Renvoie la liste des positions disponibles
	//Pré : _
	//Post : renvoie un tableau vide si pas de positions disponibles
	func getAvailablePositions() -> [Coordinate]

	//Renvoie la liste des pièces disponibles
	//Pré : _
	//Post : renvoie un tableau vide si pas de pièces disponibles
	func getAvailablePieces() -> [Piece]

	//Renvoie un itérateur sur le plateau
	//Pré : _
	//Post : _
	func makeIterator() -> Iterator

	//Renvoie une string qui représente une ligne du plateau de jeux
	//Pré : _
	//Post : _
	func printBoard(elt: [Piece?]) -> String
}

//Itère sur une ligne de quarto
protocol QuartoIteratorProtocol:IteratorProtocol, Sequence {
	
	init()

	//Renvoie une ligne du plateau de jeu
	//Pré : _
	//Post : _
	mutating func next() -> [Piece?]
}