import Foundation

protocol PieceProtocol {

	var tall:Bool { get }
	var dark:Bool { get }
	var full:Bool { get }
	var square:Bool { get }

	init(tall:Bool, dark:Bool, full:Bool, square:Bool)
}


struct Piece:PieceProtocol {
	let tall:Bool
	let dark:Bool
	let full:Bool
	let square:Bool

	
	init(tall:Bool, dark:Bool, full:Bool, square:Bool) {
		self.tall = tall
		self.dark = dark
		self.full = full
		self.square = square
	}
	
}
