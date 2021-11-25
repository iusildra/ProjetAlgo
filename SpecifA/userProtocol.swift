import Foundation

protocol UserProtocol {

	associatedtype PieceList = Sequence
	associatedtype Piece = PieceProtocol

	//Retourne le nom du joueur
	//Pré : _
	//Post : _
	func getName() -> String

	//Choisit la piece à donner à l'autre joueur
	//Pré : pieces non vide et non nil
	//Post : retourne la piece demandé
	func choosePiece(pieces:PieceList) -> Piece

	init()
}