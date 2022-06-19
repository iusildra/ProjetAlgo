//BilleProtocole représente une bille, avec une position horizontale et verticale, et une couleur pour savoir à quel joueur la bille appartient
protocol BilleProtocole {

    // init : String x Int x Int -> Bille
    // Initialise une Bille de couleur et à une position données
    // Pre : couleur correspondant à celle du joueur à qui cette bille appartient
    // Pre : 0 < horizontale < 7 && (verticale == 0 || verticale == 7) (les billes sont positionnées au départ sur la ligne du haut ou du bas
    // Pre : 0 < verticale < 7 && (horizontale == 0 || horizontale == 7) (Sur la colonne de gauche ou de droite)
    init(couleur:String, horizontale:Int, verticale:Int)

    // getCouleur : Bille -> String
    // Retourne la couleur de la bille {"B","N"} (B : Blanc, N : Noir)
    func getCouleur() -> String
    // getPosHorizontale : Bille -> Int
    // Retourne la position horizontale de la bille
    func getPosHorizontale() -> Int
    // getPosVerticale : Bille -> Int
    // Retourne la position verticale de la bille
    func getPosVerticale() -> Int

    // setPosition : Bille x Int x Int -> Bille
    // Modifie les positions horizontale et verticale d’une bille
    // Pré : 0 <= horizontale <= 7 et 0 <= verticale <= 7 (plateau de 8*8)
    // Pré : pas de combinaisons {0,0}, {0,7}, {7,0}, {7,7} car les billes ne peuvent pas être dans les coins
    mutating func setPosition(horizontale: Int, verticale: Int)
}

class Bille:BilleProtocole {
    private let couleur:String
    private var posH:Int
    private var posV:Int

    func getCouleur() -> String {
        return couleur
    }

    func getPosHorizontale() -> Int {
        return posH
    }

    func getPosVerticale() -> Int {
        return posV
    }

    func setPosition(horizontale: Int, verticale: Int) {
        self.posH = horizontale
        self.posV = verticale
    }

    required init(couleur: String, horizontale: Int, verticale: Int) {
        self.couleur = couleur
        self.posH = horizontale
        self.posV = verticale
    }
}