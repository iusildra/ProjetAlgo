//JeuProtocole est une collection qui représente un plateau de 8 par 8 de pièces, et agit sur cette collection pour suivre les régles du Mabula
protocol JeuProtocole {

    // init : -> Jeu
    // Initialise un Jeu avec une collection qui représente un plateau de 8 par 8 de pièces
    // Selon les régles du Mabula, les billes sont placées aléatoirement sur les 24 cases du
    // bord du plateau. Elles doivent respecter la condition suivante :  plus de deux billes de même couleur ne peuvent jamais être adjacentes
    // (même à travers les coins)
    init()

    // canBeSetOnBorder : String x Int x Int -> Bool
    // Vérifie qu'une Bille peut être placée sur le bord en vérifiant avec une couleur et une position, selon les règles du Mabula (précisé dans le commentaire du init)
    // Pré : couleur correspondant à celle du joueur à qui cette bille appartient
    // Pré : 0 < horizontale < maxLength && (verticale == 0 || verticale == maxLength) (les billes sont positionnées au départ sur la ligne du haut ou du bas
    // Pré : 0 < verticale < maxLength && (horizontale == 0 || horizontale == maxLength) (Sur la colonne de gauche ou de droite)
    // Post : renvoie True si une Bille peut être posée à cette position, False sinon
    static func canBeSetOnBorder(couleur:String, horizontale:Int, verticale:Int) -> Bool

    //Place les billes des joueurs sur le plateau
    mutating func placeBalls(player1:[Bille], player2:[Bille])

    // canPlayerMove : Jeu x String -> Bool
    // Vérifie qu'un joueur peut bouger au moins une bille située sur le bord du plateau
    // Pré : la couleur du joueur correspondant
    // Post : True si au moins une bille sur le bord peut être déplacée (c'est-à-dire que bouger une bille ne fera pas se décaler une autre sur le bord du plateau), False sinon
    func canPlayerMove(couleur:String) -> Bool

    // canBilleMove : Jeu x Bille -> Bool
    // Vérifie qu'une bille, située sur le bord, peut être déplacée sur le centre du plateau
    // Pré : Une Bille située sur le bord
    // Post : True si elle peut être déplacée, False sinon
    func canBilleMove(bille:Bille) -> Bool

    // isBorder : Jeu x Int x Int -> Bool
    // Vérifie qu'une Bille est à la position indiquée, et qu'elle est sur le bord
    // Pré : 0 <= horizontale <= maxLength,  0 <= verticale <= maxLength
    // Post : false si la case est vide, ou si la case indiqué n'est pas sur le bord (coins exclus), true sinon
    func isBorder(horizontale:Int, verticale:Int) -> Bool

    // canBilleMove : Jeu x Bille x Int x Int -> Bool
    // Vérifie qu'une bille, située sur le bord, peut être déplacée sur le centre du plateau à une position donnée sans décaler une autre Bille sur le bord
    // Pré : Une Bille située sur le bord
    // Pré : Une position horizontale et verticale sur le plateau, située sur la même ligne (si Bille.getPosHorizontale == 0 ou maxLength) ou colonne de la Bille (Si Bille.getPosVerticale == 0 ou maxLength)
    // Post : True si elle peut être déplacée, False sinon
    func canBilleMoveAtPos(bille:Bille, horizontale:Int, verticale:Int) -> Bool

    // moveBilleAtPos : Jeu x Bille x Int x Int -> Jeu
    // Déplace une bille vers sa case de destination
    // Pré : Une bille
    // Pré : Une position horizontale et verticale de destination
    mutating func moveBilleAtPos(bille:Bille, horizontale:Int, verticale:Int)

    // getBilleAtPos : Jeu x Int x Int -> (Bille || Vide)
    // Retourne ce que contient le plateau à la position indiquée
    // Pré : 0 <= horizontale <= maxLength,  0 <= verticale <= maxLength
    // Post : Bille si une Bille est présente, Vide sinon
    func getBilleAtPos(horizontale:Int, verticale:Int) -> Bille?

    // biggestGroup : Jeu x String -> Int
    // Renvoie le nombre de Bille du plus grand groupe de Bille du joueur de la couleur passée en paramètre
    // Pré : la couleur du joueur
    // Post : un entier 
    func biggestGroup(couleur: String) -> Int
    
    // multGroup : Jeu x String -> Int
    // Renvoie un entier égal au produit du nombre de bille de chaque groupe de bille du joueur dont la couleur est passée en paramètre
    // Exemple: si 2 groupes de 2 billes et un groupe de 3 billes, renvoie 2*2*3
    // Pré : la couleur du joueur
    // Post : un entier
    func multGroup(couleur: String) -> Int

    // getGroup: Bille -> Int
    // Renvoie le nombre de bille du groupe
    // Pré : une bille du centre du plateau
    // Post : le nombre de bille du groupe (de la bille passé en paramètre)
    func getGroup(bille: Bille) -> Int

}

struct Jeu:JeuProtocole {
    private var maxLength = 8
    private var board = [[Bille?](repeating:nil, count:maxLength)](repeating:[Piece?], count:maxLength)
    private var billeB = [Bille](repeating:nil, count:12)
    private var billeN = [Bille](repeating:nil, count:12)

    init() {
    
    }

    func canBeSetOnBorder(couleur: String, horizontale: Int, verticale: Int) -> Bool {
        return isOnBorder(x: Int, y: Int)
    }

    func isOnBorder(x:Int, y:Int) -> Bool {
        guard x == 0 || x = maxLength && (y > 0 && y < maxLength) else {
            return false
        }
        guard y == 0 || y = maxLength && (x > 0 && x < maxLength) else {
            return false
        }
        guard (x == 0 || horizontale == maxLength) && (y == 0 || y == maxLength) else {
            return false
        }
        return true
    }

    func ballChain(couleur:String, x:Int, y:Int) {
        var i = 2
        var sameNb = 0
        while i > 0 {
            if x==0 || x==maxLength {
                if x-i > 0 {

                }
                if x+i < maxLength {

                }
            }
        }
    }

    func ballChainX(couleur:String, x:Int, y:Int) {
        var i = 1
        var sameNb = 1
        while i <= 2 {
            if x-i > 0 {
                if board[y][x-i].getCouleur() == couleur { sameNb+=1 }
            } else {
                if board[-1*(x-i)+1][0].getCouleur() == couleur { same+=1 }
            }
            if y+i < maxLength-1 {
                if board[y][x+i].getCouleur() == couleur { sameNb+=1 }
            } else {
                if board[(x+i) - maxLength + 2][maxLength].getCouleur() == couleur { same+=1 }
            }
            i+=1
            return sameNb <= 2
        }
    }
    func ballChainY(couleur:String, x:Int, y:Int) {
        var i = 1
        var sameNb = 1
        while i <= 2 {
            if y-i > 0 {
                if board[y-i][x].getCouleur() == couleur { sameNb+=1 }
            } else {
                if board[0][-1*(y-i)+1].getCouleur() == couleur { same+=1 }
            }
            if y+i < maxLength-1 {
                if board[y+i][x].getCouleur() == couleur { sameNb+=1 }
            } else {
                if board[maxLength][(y+i) - maxLength + 2].getCouleur() == couleur { same+=1 }
            }
            i+=1
            return sameNb <= 2
        }
    }

    mutating func placeBalls(player1:[Bille], player2:[Bille]) {

    }

    func canPlayerMove(couleur: String) -> Bool {
    return true
    }

    func canBilleMove(bille: Bille) -> Bool {
    return true
    }

    func isBorder(horizontale: Int, verticale: Int) -> Bool {
    return true
    }

    func canBilleMoveAtPos(bille: Bille, horizontale: Int, verticale: Int) -> Bool {
    return true
    }

    mutating func moveBilleAtPos(bille: Bille, horizontale: Int, verticale: Int) {
    
    }

    func getBilleAtPos(horizontale: Int, verticale: Int) -> Bille? {
    return nil
    }

    func biggestGroup(couleur: String) -> Int {
    return 0
    }

    func multGroup(couleur: String) -> Int {
    return 0
    }

    func getGroup(bille: Bille) -> Int {
    return 0
    }

}