import Foundation

protocol QuartoProtocol: Sequence {
	//coordonnées en (y,x)
	associatedtype Coordinate = (Int,Int)
	associatedtype Iterator = IteratorProtocol
	
	//Place une pièce sur le plateau
	//Pré : coordonnée valide et non occupée et pièce disponible
	//Post : Si la pièce a pu être placé, supprimer de la liste des pièces et de la liste de coordonnées la pièce et coordonnée choisies et renvoie true. Sinon ne supprime pas la pièce et la position et renvoie false
	mutating func place(piece:Piece, coord: Coordinate) -> Bool

	//Vérifie l'alignement de la pièce placée avec les autres. Il y a alignement lorsque 4 pièces adjacente partage une même caractéristiques. L'alignement peut être horizontal, vertical ou en diagonale. Une variante consiste à avoir un carré de pièces adjacentes. Renvoie aussi les coordonnées de l'alignement
	//Pré : coordonnée valide et occupée
	//Post : false s'il n'y a pas d'alignement, les coordonnées sont alors nil. S'il existe un alignement, renvoie true et des coordonnées non nil
	func checkAlignement(coord: Coordinate) -> (Bool, (Coordinate, Coordinate)?)

	//Vérifie l'alignement horizontal. Renvoie aussi les coordonnées de l'alignement
	//Pré : coordonnée valide et occupée
	//Post : false s'il n'y a pas d'alignement, les coordonnées sont alors nil. S'il existe un alignement, renvoie true et des coordonnées non nil
	func horizontalAlign(coord: Coordinate) -> (Bool, (Coordinate, Coordinate)?)

	//Vérifie l'alignement vertical. Renvoie aussi les coordonnées de l'alignement
	//Pré : coordonnée valide et occupée
	//Post : false s'il n'y a pas d'alignement, les coordonnées sont alors nil. S'il existe un alignement, renvoie true et des coordonnées non nil
	func verticalAlign(coord: Coordinate) -> (Bool, (Coordinate, Coordinate)?)

	//Vérifie l'alignement diagonal. Renvoie aussi les coordonnées de l'alignement
	//Pré : coordonnée valide et occupée
	//Post : false s'il n'y a pas d'alignement, les coordonnées sont alors nil. S'il existe un alignement, renvoie true et des coordonnées non nil
	func diagonalAlign(coord: Coordinate) -> (Bool, (Coordinate, Coordinate)?)

	//Renvoie la liste des positions disponibles
	//Pré : _
	//Post : renvoie un tableau vide si pas de positions disponibles
	func getAvailablePositions() -> [Coordinate]

	//Renvoie la liste des pièces disponibles
	//Pré : _
	//Post : renvoie un tableau vide si pas de pièce disponible
	func getAvailablePieces() -> [Piece]

	//Renvoie un itérateur
	//Pré : _
	//Post : _
	func makeIterator() -> Iterator

	//Renvoie une string qui représente une ligne plateau de jeux
	//Pré : _
	//Post : _
	func printBoard(elt: [Piece]) -> String

	//Initialise le plateau, toutes les positions sont vides et initialise toutes les pièces disponibles
	//Pré : _
	//Post : _
	init()
	
}

//Ajout des pièces aux jeux (voir règle du quarto). Ici il s'agit du premier set possible (celui du gauche sur les règles)
/*func initPieces() -> [Piece] {
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
}*/