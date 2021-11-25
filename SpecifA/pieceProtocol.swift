import Foundation

protocol PieceProtocol {

	associatedtype Size = EnumeratedSequence
	associatedtype Color = EnumeratedSequence
	associatedtype Shape = EnumeratedSequence
	associatedtype Content = EnumeratedSequence
	var size:Size { get }
	var color:Color { get }
	var shape:Shape { get }
	var content:Content { get }
	//Retourne la taille de la piece
	//Pré : _
	//Post : _
	func getSize() -> Size

	//Retourne la couleur de la piece
	//Pré : _
	//Post : _
	func getColor() -> Color

	//Retourne la forme de la piece
	//Pré : _
	//Post : _
	func getShape() -> Shape

	//Retourne le contennu de la piece
	//Pré : _
	//Post : _
	func getContent() -> Content

	init()
}
