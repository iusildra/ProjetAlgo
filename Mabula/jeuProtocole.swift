import Foundation
import Glibc
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
    static func canBeSetOnBorder(board:inout[[Bille?]], couleur:String, horizontale:Int, verticale:Int) -> Bool

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

enum Player:String {
    case B="B", N="N"

    func next() -> Self {
        switch self {
            case .B:
                return .N
            case .N:
                return .B
        }
    }

    static func random() -> Self {
        if Int.random(in: 0...1)%2 == 0 {
            return .B
        } else {
            return .N
        }
    }
}
struct Jeu:JeuProtocole {
    static let maxLength = 8
    private var board = [[Bille?]](repeating: [Bille?](repeating: nil, count: Jeu.maxLength), count: Jeu.maxLength)
    var playerBalls:[String:[Bille]]

    init() {
        var ballsN = [Bille]()
        ballsN.reserveCapacity(12)
        var ballsB = [Bille]()
        ballsB.reserveCapacity(12)
        self.playerBalls = [Player.B.rawValue:ballsB, Player.N.rawValue:ballsN]

        /*self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 3, verticale: 2))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 4, verticale: 2))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 2))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 2, verticale: 3))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 3, verticale: 3))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 3))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 2, verticale: 1)) //ICI (2,4)
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 3, verticale: 4))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 4, verticale: 4))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 4))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 5))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 2, verticale: 7))

        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 2, verticale: 6)) //ICI (4,1)
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 2, verticale: 2))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 6, verticale: 2))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 1, verticale: 3))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 4, verticale: 3))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 6, verticale: 3))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 1, verticale: 4))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 6, verticale: 4))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 1, verticale: 5))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 6, verticale: 5))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 3, verticale: 5))
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 4, verticale: 5))*/
        
        Jeu.fillBoard(board: &self.board, balls: &playerBalls)

        for (_,balls) in self.playerBalls {
            for ball in balls {
                self.board[ball.getPosVerticale()][ball.getPosHorizontale()] = ball
            }
        }

    }


    //Fonction récursive pour remplir le plateau. Renvoie true s'il est possible de remplir le plateau avec une bille appatenant au joueur
    private static func fillBoard(board:inout[[Bille?]], balls:inout [String:[Bille]]) {
        func fill(board:inout[[Bille?]], balls:inout[String:[Bille]], couleur:Player, x:Int=1, y:Int=0) -> Bool {
            var newX=x, newY=y

            switch (x,y) {
                case (_, 0):
                    if x < Jeu.maxLength-1 { newX+=1 } //newY=0
                    else { newY = 1 } //newX = Jeu.maxLength-1
                    break
                case (Jeu.maxLength-1, _):
                    if y < Jeu.maxLength-1 { newY+=1 } //newX=Jeu.maxLength-1
                    else { newX = Jeu.maxLength-2 } //newY=Jeu.maxLength-1
                    break
                case (_, Jeu.maxLength-1):
                    if x > 0 { newX-=1 } //newY=Jeu.maxLength-1
                    else { newY = Jeu.maxLength-2} //newX=0
                    break
                case (0, _):
                    if y > 0 { newY-=1 } //newX=0
                    else { newX = 1 } //newY=0
                    break
                default:
                    break
            }

            guard Jeu.isOnBorder(x: x, y: y) else {
                return fill(board: &board, balls: &balls, couleur: couleur, x:newX, y:newY)
            }

            Glibc.system("clear")
            for l in board {
                for b in l {
                    if let b=b {
                        print(b.getCouleur(), terminator: " ")
                    } else { print("_", terminator: " ")}
                }
                print()
            }

            guard board[y][x] == nil else {
                if balls[couleur.rawValue]?.count == 12 && balls[couleur.next().rawValue]?.count == 12 {
                    return true
                } else {
                    return false
                }
            }

            let bille = Bille.init(couleur: couleur.rawValue, horizontale: x, verticale: y)
            let billeOther = Bille.init(couleur: couleur.next().rawValue, horizontale: x, verticale: y)
            if Jeu.canBeSetOnBorder(board: &board, couleur: couleur.rawValue, horizontale: x, verticale: y) { //Vérifie si le joueur peut poser sa bille ici
                board[y][x] = bille
                balls[couleur.rawValue]?.append(bille)

                if fill(board: &board, balls: &balls, couleur: Player.random(), x:newX, y:newY) {
                    return true //Toutes les billes après ont pu être placé, donc le placement est correct
                } else { //Les billes n'ont pas pu être placé, le placement est incorrect
                    board[y][x] = billeOther //On remplace la bille du joueur par celle de l'autre joueur
                    balls[couleur.rawValue]?.removeLast() //Et on la sort du set de bille du joueur
                    balls[couleur.next().rawValue]?.append(billeOther) //On mets la billeOther dans le set de l'autre joueur
                    if fill(board: &board, balls: &balls, couleur: couleur.next(), x:newX, y:newY) {
                        return true
                    } else {
                        board[y][x] = nil
                        balls[couleur.next().rawValue]?.removeLast()
                        return false 
                    }
                }
            } else {
                board[y][x] = billeOther
                balls[couleur.next().rawValue]?.append(billeOther)
                if fill(board: &board, balls: &balls, couleur: couleur.next(), x:x, y:y) { //Comme on est sur un bords et pas un coin, on essaie de placer une bille de l'autre joueur
                    return true
                } else { //On a pas pu placer la bille de l'autre joueur, le placement est donc faux.
                    board[y][x] = nil
                    balls[couleur.next().rawValue]?.removeLast() //On supprime donc la bille du set de l'autre joueur
                    return false 
                }
            }
        }

        _ = fill(board: &board, balls: &balls, couleur: Player.random())

    }

    static func canBeSetOnBorder(board:inout[[Bille?]], couleur: String, horizontale: Int, verticale: Int) -> Bool {
        return isOnBorder(x: horizontale, y: verticale) && checkAlignement(board:&board, couleur: couleur, x: horizontale, y: verticale)
    }

    //Pour déterminer si les coordonées sont bien des coordonnées du bord
    private static func isOnBorder(x:Int, y:Int) -> Bool {
        if (x == 0 || x == maxLength-1) && (y == 0 || y == maxLength-1) { // Vérifie les coins
            return false
        }

        var onBorder = false
        if (x == 0 || x == maxLength-1) && (y > 0 && y < maxLength-1) { //Vérifie sur une colonne
            onBorder = true
        }
        if (y == 0 || y == maxLength-1) && (x > 0 && x < maxLength-1) { // Vérifie sur une ligne
            onBorder = true
        }
        return onBorder
    }

    //Vérifie qu'il n'y a pas plus de 2 balles alignées à côté du nouvel emplacement (inout pour les fonctions récursives, pas de modification, évite <=2 copies)
    private static func checkAlignement(board:inout[[Bille?]], couleur:String, x:Int, y:Int) -> Bool {
        var nbSame=0
        if x == 0 {
            clockwiseAlignement(board:&board, couleur: couleur, x: x, y: y-1, nbSame: &nbSame)
                anticlockwiseAlignement(board:&board, couleur: couleur, x: x, y: y+1, nbSame: &nbSame)
        }
        if y == 0 {
            clockwiseAlignement(board:&board, couleur: couleur, x: x+1, y: y, nbSame: &nbSame)
            anticlockwiseAlignement(board:&board, couleur: couleur, x: x-1, y: y, nbSame: &nbSame)
        }

        if x == Jeu.maxLength-1 {
            clockwiseAlignement(board:&board, couleur: couleur, x: x, y: y+1, nbSame: &nbSame)
            anticlockwiseAlignement(board:&board, couleur: couleur, x: x, y: y-1, nbSame: &nbSame)
        }
        if y == Jeu.maxLength-1 {
            clockwiseAlignement(board:&board, couleur: couleur, x: x-1, y: y, nbSame: &nbSame)
            anticlockwiseAlignement(board:&board, couleur: couleur, x: x+1, y: y, nbSame: &nbSame)
        }
        //Par défaut, si x,y != {0, Jeu.maxLength-1}, alors la bille ne serai pas sur le bord
        return nbSame<2
    }

    //Vérifie l'alignement des billes dans le sens horaire (inout car récursif, pas de modification, évite 2 copies)
    private static func clockwiseAlignement(board:inout[[Bille?]], couleur:String, x:Int, y:Int, nbSame:inout Int) {
        guard nbSame < 2 else { return }

        var x=x, y=y
        guard let color = board[y][x]?.getCouleur() else {
            return
        }
        
        switch (x,y) { //On est sûr que board[y][x] est défini car 0 <= x,y < Jeu.maxLength
            case (1...Jeu.maxLength-1, 0):
                if x < Jeu.maxLength-1 {
                    if color==couleur { x+=1; nbSame+=1 }
                    else { return }
                } else { y=1 } //x=Jeu.maxLength-1
                break

            case (maxLength-1, 1...Jeu.maxLength-1):
                if y < Jeu.maxLength-1 {
                    if color==couleur { y+=1; nbSame+=1 }
                    else { return }
                } else { x=maxLength-2 } //y=Jeu.maxLength-1
                break

            case (0...Jeu.maxLength-2, Jeu.maxLength-1):
                if x > 0 {
                    if color==couleur { x-=1; nbSame+=1 }
                    else { return }
                } else { y=maxLength-2 } //x=0
                break

            case (0, 0...Jeu.maxLength-2):
                if y > 0 {
                    if color==couleur { y-=1; nbSame+=1 }
                    else { return }
                } else { x=1 } //y=0
                break

            default:
                return //Les préconditions font qu'on ne passera jamais par là
        }

        clockwiseAlignement(board: &board, couleur: couleur, x: x, y: y, nbSame: &nbSame)
    }

    //Vérifie dans le sens anti-horaire (inout car récursif, pas de modification, évite 2 copies)
    private static func anticlockwiseAlignement(board:inout[[Bille?]], couleur:String, x:Int, y:Int, nbSame:inout Int) {
        guard nbSame < 2 else { return }

        var x=x, y=y
        guard let color = board[y][x]?.getCouleur() else {
            return
        }
        
        switch (x,y) { //On est sûr que board[y][x] est défini car 0 <= x,y < Jeu.maxLength
            case (0...Jeu.maxLength-2, 0):
                if x > 0 {
                    if color==couleur { x-=1; nbSame+=1 }
                    else { return }
                } else { y=1 } //x=0
                break

            case (0, 1...Jeu.maxLength-1):
                if y < Jeu.maxLength-1 {
                    if color==couleur { y+=1; nbSame+=1 }
                    else { return }
                } else { x=1 } //y=Jeu.maxLength-1
                break

            case (1...Jeu.maxLength-1, Jeu.maxLength-1):
                if x < Jeu.maxLength-1 {
                    if color==couleur { x+=1; nbSame+=1 }
                    else { return }
                } else { y=maxLength-2 } //x=Jeu.maxLength-1
                break

            case (Jeu.maxLength-1, 0...Jeu.maxLength-2):
                if y > 0 {
                    if color==couleur { y-=1; nbSame+=1 }
                    else { return }
                } else { x=Jeu.maxLength-2 } //y=0
                break

            default:
                return //Les préconditions font qu'on ne passera jamais par là
        }
        
        anticlockwiseAlignement(board: &board, couleur: couleur, x: x, y: y, nbSame: &nbSame)
    }

    func canPlayerMove(couleur: String) -> Bool {
        guard playerBalls.keys.contains(couleur) else {
            return false
        }

        var canMove = false
        for bille in playerBalls[couleur]! {
            if canBilleMove(bille: bille) { canMove = true }
        }

        return canMove
    }

    func canBilleMove(bille: Bille) -> Bool {
        let x = bille.getPosHorizontale(), y = bille.getPosVerticale()
        guard Jeu.isOnBorder(x: x, y: y) else {
            return false
        }
        
        var canMove = false
        for i in 1..<Jeu.maxLength-1 {
            //On itère sur ...
            if x==0 || x==Jeu.maxLength-1 { //... une ligne
                if self.board[y][i] == nil { canMove = true }
            } else { //... une colonne
                if self.board[i][x] == nil { canMove = true }
            }
        }

        return canMove
    }

    func isBorder(horizontale: Int, verticale: Int) -> Bool { //Useless ?
        guard self.board[verticale][horizontale] != nil else {
            return false
        }
        return Jeu.isOnBorder(x: horizontale, y: verticale)
    }

    /*func canBilleMoveAtPos(bille: Bille, horizontale: Int, verticale: Int) -> Bool {
        let x = bille.getPosHorizontale(), y = bille.getPosVerticale()
        guard (x==horizontale || y==verticale) && Jeu.isOnBorder(x:x, y:y) else {
            return false
        }

        var canMove = false
        if x==horizontale { //On déplace la bille sur une colonne
            for i in getRange(pos: y, target: verticale) {
                if self.board[i][x] == nil { canMove = true }
            }
        } else { //On déplace la bille sur une ligne
            for i in getRange(pos: x, target: horizontale) {
                if self.board[y][i] == nil { canMove = true }
            }
        }

        return canMove
    }*/

    func canBilleMoveAtPos(bille: Bille, horizontale: Int, verticale: Int) -> Bool {
        let x = bille.getPosHorizontale(), y = bille.getPosVerticale()
        guard (x==horizontale || y==verticale) && Jeu.isOnBorder(x:x, y:y) else {
            return false
        }

        var nbBalls = 0
        if x==horizontale { //On déplace la bille sur une colonne
            for i in 1..<Jeu.maxLength-1 {
                if self.board[i][x] != nil { nbBalls += 1 }
            }
            return nbBalls <= getMaxNbBalls(pos:y, target: verticale)
        }else { //On déplace la bille sur une ligne
            for i in 1..<Jeu.maxLength-1 {
                if self.board[y][i] != nil { nbBalls += 1 }
            }
            return nbBalls <= getMaxNbBalls(pos:x, target: horizontale)
        }
    }

    //Donne une range sur laquelle vérifier s'il existe des cases vides
    private func getMaxNbBalls(pos:Int, target:Int) -> Int {
        if pos-target > 0 { //Gère les cas où pos = Jeu.maxLength-1
            return target-1 //Les billes poussés ne doivent pas aller plus loin que la case (x,y)=(_,1). En excluant la case ciblée de coordonnée (_, target), il reste donc target - 1 cases
        } else { //Gère les cas où pos = 0
            return Jeu.maxLength-2-target //Les billes poussés ne doivent pas aller plus loin que la case (x,y)=(_,Jeu.maxLength-2). En excluant la case ciblée de coordonnée (_, target), il reste donc Jeu.maxLength-2-target cases
        }
    }

    mutating func moveBilleAtPos(bille: Bille, horizontale: Int, verticale: Int) {
        func moveBallTo(bille1:Bille, x:Int, y:Int) {
            guard let existingBall = self.board[y][x] else {
                bille1.setPosition(horizontale: x, verticale: y)
                self.board[y][x] = bille1
                return
            }

            var billeX = existingBall.getPosHorizontale()
            var billeY = existingBall.getPosVerticale()

            if bille.getPosHorizontale() == horizontale {
                if bille1.getPosVerticale() < billeY { billeY += 1 }
                else { billeY -= 1 }
            } else {
                if bille1.getPosHorizontale() < billeX { billeX += 1 }
                else { billeX -= 1}
            }

            bille1.setPosition(horizontale: x, verticale: y)
            self.board[y][x] = bille1
            moveBallTo(bille1: existingBall, x: billeX, y: billeY) //La condition d'arrêt est lorsque self.board[verticale][horizontale] est nil. Alors on place la bille 
        }

        guard canBilleMoveAtPos(bille: bille, horizontale: horizontale, verticale: verticale) else { //Implique que x==horizontale ou y==verticale
            return
        }

        var count = 1
        let x = bille.getPosHorizontale() //Très important de les stocker avant
        let y = bille.getPosVerticale() //Sinon typé référence, x et y prennent leur nouvelle valeur, soit verticale ou horizontale...

        self.board[bille.getPosVerticale()][bille.getPosHorizontale()] = nil
        moveBallTo(bille1: bille, x: horizontale, y: verticale)


        if x==horizontale {
            let range = getRange(pos: y, target: verticale)
            
            for i in range.0 {
                if let newBille = self.board[i][x] {
                    self.board[i][x] = nil
                    moveBallTo(bille1: newBille, x: horizontale, y: verticale+(count*range.1)) //Si (y||x)==Jeu.maxLength-1, alors on mettra la bille en target-count. Si (y||x)==0, alors on mettra la bille en target+count
                    count+=1
                }
            }
        } else {
            let range = getRange(pos: x, target: verticale)

            for i in range.0 {
                if let newBille = self.board[y][i] {
                    self.board[y][i] = nil
                    moveBallTo(bille1: newBille, x: horizontale+(count*range.1), y: verticale)
                    count+=1
                }
            }
        }
    }

    //Renvoie la range sur laquelle vérifier s'il y a des boules et le step à suivre
    private func getRange(pos:Int, target:Int) -> (StrideTo<Int>, Int) {
        guard pos-target != 0 else {
            print("1")
            return (stride(from: 0, to: 0, by: 1), 0)
        }
        if pos-target > 0 { //Gère les cas où pos = Jeu.maxLength-1
            print("2")
            return (stride(from: Jeu.maxLength-2, to: target, by: -1), -1) //Les billes poussés ne doivent pas aller plus loin que la case (x,y)=(_,1). En excluant la case ciblée de coordonnée (_, target), il reste donc target - 1 cases
        } else { //Gère les cas où pos = 0
            print("3")
            return (stride(from: 1, to: target, by: 1), 1) //Les billes poussés ne doivent pas aller plus loin que la case (x,y)=(_,Jeu.maxLength-2). En excluant la case ciblée de coordonnée (_, target), il reste donc Jeu.maxLength-2-target cases
        }
    }

    func getBilleAtPos(horizontale: Int, verticale: Int) -> Bille? {
        return self.board[verticale][horizontale]
    }

    func biggestGroup(couleur: String) -> Int {
        guard self.playerBalls.keys.contains(couleur) else {
            fatalError("La couleur demandé n'existe pas")
        }

        var max = 0
        var beenThere=[Bille]()
        beenThere.reserveCapacity(12)

        for ball in playerBalls[couleur]! {
            var accN=0, accE=0, accS=0, accW=0
            group(bille: ball, beenThere: &beenThere, accN: &accN, accE: &accE, accS: &accS, accW: &accW)
            let count = 1+accN+accE+accS+accW
            if count > max {
                max = count
            }
        }
        return max
    }

    func multGroup(couleur: String) -> Int {
        guard self.playerBalls.keys.contains(couleur) else {
            fatalError("La couleur demandé n'existe pas")
        }

        var prod = 1
        var beenThere = [Bille]()
        beenThere.reserveCapacity(12)

        for ball in self.playerBalls[couleur]! {
            var accN=0, accE=0, accS=0, accW=0
            group(bille: ball, beenThere: &beenThere, accN: &accN, accE: &accE, accS: &accS, accW: &accW)
            prod *= 1+accN+accE+accS+accW
        }

        return prod
    }

    func getGroup(bille: Bille) -> Int { //Fonction non utilisé car ne permettait pas de faire la fonction multGroup
        return 0
    }

    private func group(bille:Bille, beenThere:inout [Bille], accN:inout Int, accE:inout Int, accS:inout Int, accW:inout Int) {
        let x = bille.getPosHorizontale()
        let y = bille.getPosVerticale()
        beenThere.append(bille)

        if y>0, let newBranch = self.board[y-1][x], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                accN+=1
                group(bille: newBranch, beenThere: &beenThere, accN: &accN, accE: &accE, accS: &accS, accW: &accW)
            }
        }
        if x<Jeu.maxLength-1, let newBranch = self.board[y][x+1], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                accE+=1
                group(bille: newBranch, beenThere: &beenThere, accN: &accN, accE: &accE, accS: &accS, accW: &accW)
            }
        }
        if y<Jeu.maxLength-1, let newBranch = self.board[y+1][x], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                accS+=1
                group(bille: newBranch, beenThere: &beenThere, accN: &accN, accE: &accE, accS: &accS, accW: &accW)
            }
        }
        if x>0, let newBranch = self.board[y][x-1], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                accW+=1
                group(bille: newBranch, beenThere: &beenThere, accN: &accN, accE: &accE, accS: &accS, accW: &accW)
            }
        }
    }

    private func ballContained(bille:Bille, beenThere:inout [Bille]) -> Bool {
        var contains=false
        for ball in beenThere {
            if ball===bille { contains = true }
        }
        return contains
    }
}














//BilleProtocole représente une bille, avec une position horizontale et verticale, et une couleur pour savoir à quel joueur la bille appartient
protocol BilleProtocole {

    // init : String x Int x Int -> Bille
    // Initialise une Bille de couleur et à une position données
    // Pre : couleur correspondant à celle du joueur à qui cette bille appartient
    // Pre : 0 < horizontale < 7 && (verticale == 0 || verticale == 7) (les billes sont positionnées au départ sur la ligne du haut ou du bas
    // Pre : 0 < verticale < 7 && (horizontale == 0 || horizontale == 7) (Sur la colonne de gauche ou de droite)
    init(couleur:String, horizontale:Int, verticale:Int)

    // getCouleur : Bille -> String
    // Retourne la couleur de la bille {Player.B.rawValue,Player.N.rawValue} (B : Blanc, N : Noir)
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
    var posH:Int
    var posV:Int

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