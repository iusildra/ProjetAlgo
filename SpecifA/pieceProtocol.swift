import Foundation

protocol PieceProtocol {

	var tall:Bool { get }
	var dark:Bool { get }
	var full:Bool { get }
	var square:Bool { get }

	//Initialise la pièce avec les caractéristiques fournies
	init(tall:Bool, dark:Bool, full:Bool, square:Bool)
}