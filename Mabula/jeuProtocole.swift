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
    static let maxLength = 8
    private var board:[[Bille?]]
    private var playerBalls:[String:Set<Bille>]

    init() {
        /*var board = [[Bille?]](repeating: [Bille?](repeating: nil, count: Jeu.maxLength), count: Jeu.maxLength)
        let players = ["B", "N"]
        var balls:[String:Set<Bille>] = [players[0]:Set<Bille>(), players[1]:Set<Bille>()]

        //FONCTION RÉCURSIVE POUR INITIALISER LA PLATEAU*/
        self.board = [[Bille?]](repeating: [Bille?](repeating: nil, count: Jeu.maxLength), count: Jeu.maxLength)
        self.playerBalls = ["B":Set<Bille>(), "N":Set<Bille>()]
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 1, verticale: 0))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 3, verticale: 0))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 5, verticale: 0))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: Jeu.maxLength-1, verticale: 1))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: Jeu.maxLength-1, verticale: 3))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: Jeu.maxLength-1, verticale: 5))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 6, verticale: Jeu.maxLength-1))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 4, verticale: Jeu.maxLength-1))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 2, verticale: Jeu.maxLength-1))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 0, verticale: 6))
        self.playerBalls["B"]?.insert(Bille.init(couleur: "B", horizontale: 0, verticale: 4))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 0, verticale: 2))

        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 2, verticale: 0))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 4, verticale: 0))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 6, verticale: 0))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: Jeu.maxLength-1, verticale: 2))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: Jeu.maxLength-1, verticale: 4))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: Jeu.maxLength-1, verticale: 6))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 1, verticale: Jeu.maxLength-1))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 3, verticale: Jeu.maxLength-1))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 5, verticale: Jeu.maxLength-1))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 0, verticale: 1))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 0, verticale: 3))
        self.playerBalls["N"]?.insert(Bille.init(couleur: "N", horizontale: 0, verticale: 5))

        for billeB in self.playerBalls["B"]! {
            self.board[billeB.getPosVerticale()][billeB.getPosHorizontale()] = billeB
        }
        for billeN in self.playerBalls["N"]! {
            self.board[billeN.getPosVerticale()][billeN.getPosHorizontale()] = billeN
        }

        print(Jeu.checkAlignement(board: &self.board, couleur: "N", x: 1, y: 0))
    }

    static func canBeSetOnBorder(board:inout[[Bille?]], couleur: String, horizontale: Int, verticale: Int) -> Bool {
        return isOnBorder(x: horizontale, y: verticale) && checkAlignement(board:&board, couleur: couleur, x: horizontale, y: verticale)
    }

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

    //Vérifie qu'il n'y a pas plus de 2 balles alignées à côté du nouvel emplacement
    private static func checkAlignement(board:inout[[Bille?]], couleur:String, x:Int, y:Int) -> Bool {
        if x == 0 {
            return clockwiseAlignement(board:&board, couleur: couleur, x: x, y: y-1) && anticlockwiseAlignement(board:&board, couleur: couleur, x: x, y: y+1)
        }
        if y == 0 {
            return clockwiseAlignement(board:&board, couleur: couleur, x: x+1, y: y) && anticlockwiseAlignement(board:&board, couleur: couleur, x: x-1, y: y)
        }

        if x == Jeu.maxLength-1 {
            return clockwiseAlignement(board:&board, couleur: couleur, x: x, y: y+1) && anticlockwiseAlignement(board:&board, couleur: couleur, x: x, y: y-1)
        }
        if y == Jeu.maxLength-1 {
            return clockwiseAlignement(board:&board, couleur: couleur, x: x-1, y: y) && anticlockwiseAlignement(board:&board, couleur: couleur, x: x+1, y: y)
        }
        //Par défaut, si x,y != {0, Jeu.maxLength-1}, alors la bille ne serai pas sur le bord
        return false
    }

    //Vérifie l'alignement des billes dans le sens horaire
    //Pré : _
    //Post : _
    private static func clockwiseAlignement(board:inout[[Bille?]], couleur:String, x:Int, y:Int, nbSame:Int=0) -> Bool {
        guard nbSame < 2 else { return false }

        var x=x, y=y
        var nbSame=nbSame
        
        switch (x,y) { //On est sûr que board[y][x] est défini car 0 <= x,y < Jeu.maxLength
            case (_, 0):
                if x < Jeu.maxLength-1 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        x+=1; nbSame+=1
                    } else { return true }
                } else {
                    x=Jeu.maxLength-1; y=1
                }

            case (maxLength-1, _):
                if y < Jeu.maxLength-1 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        y+=1; nbSame+=1
                    } else { return true }
                } else {
                    x=maxLength-2; y=Jeu.maxLength-1
                }

            case (_, Jeu.maxLength-1):
                if x > 0 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        x-=1; nbSame+=1
                    } else { return true }
                } else {
                    x=0; y=maxLength-2
                }

            case (0, _):
                if y > 0 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        y-=1; nbSame+=1
                    } else { return true }
                } else {
                    x=1; y=0
                }
            default:
                return true //Les préconditions font qu'on ne passera jamais par là
        }

        return clockwiseAlignement(board: &board, couleur: couleur, x: x, y: y, nbSame: nbSame)
    }

    //Vérifie dans le sens anti-horaire
    private static func anticlockwiseAlignement(board:inout[[Bille?]], couleur:String, x:Int, y:Int, nbSame:Int=0) -> Bool {
        guard nbSame < 2 else { return false }

        var x=x, y=y
        var nbSame=nbSame
        
        switch (x,y) { //On est sûr que board[y][x] est défini car 0 <= x,y < Jeu.maxLength
            case (_, 0):
                if x > 0 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        x-=1; nbSame+=1
                    } else { return true }
                } else {
                    x=0; y=1
                }

            case (0, _):
                if y < Jeu.maxLength-1 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        y+=1; nbSame+=1
                    } else { return true }
                } else {
                    x=1; y=Jeu.maxLength-1
                }

            case (_, Jeu.maxLength-1):
                if x < Jeu.maxLength-1 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        x+=1; nbSame+=1
                    } else { return true }
                } else {
                    x=Jeu.maxLength-1; y=maxLength-2
                }

            case (Jeu.maxLength-1, _):
                if y > 0 {
                    if let color = board[y][x]?.getCouleur(), color==couleur {
                        y-=1; nbSame+=1
                    } else { return true }
                } else {
                    x=Jeu.maxLength-2; y=0
                }
            default:
                return true //Les préconditions font qu'on ne passera jamais par là
        }
        
        return anticlockwiseAlignement(board: &board, couleur: couleur, x: x, y: y, nbSame: nbSame)
    }

    mutating func placeBalls(player1:[Bille], player2:[Bille]) {

    }

    func canPlayerMove(couleur: String) -> Bool {
        guard playerBalls.keys.contains(couleur) else {
            print("Le joueur demandé n'existe pas")
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
            print("La bille n'est pas sur le bord du plateau !")
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
            print("Il n'y a pas de bille a cette position !")
            return false
        }
        return Jeu.isOnBorder(x: horizontale, y: verticale)
    }

    func canBilleMoveAtPos(bille: Bille, horizontale: Int, verticale: Int) -> Bool {
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
    }

    private func getRange(pos:Int, target:Int) -> ClosedRange<Int> {
        if pos-target > 0 { //Gère les cas où pos = Jeu.maxLength-1
            return 1...target
        } else { //Gère les cas où pos = 0
            return target...Jeu.maxLength-2
        }
    }

    mutating func moveBilleAtPos(bille: Bille, horizontale: Int, verticale: Int) {
        func moveBallTo(bille1:Bille, x:Int, y:Int) {
            guard let existingBall = self.board[y][x] else {
                var updatedBall = bille1
                updatedBall.setPosition(horizontale: x, verticale: y)
                self.board[y][x] = updatedBall
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

            self.board[y][x] = bille1
            moveBallTo(bille1: existingBall, x: billeX, y: billeY) //La condition d'arrêt est lorsque self.board[verticale][horizontale] est nil. Alors on place la bille 
        }

        guard canBilleMoveAtPos(bille: bille, horizontale: horizontale, verticale: verticale) else {
            print("La destination n'est pas valide !")
            return
        }

        self.board[bille.getPosVerticale()][bille.getPosHorizontale()] = nil
        moveBallTo(bille1: bille, x: horizontale, y: verticale)
    }

    func getBilleAtPos(horizontale: Int, verticale: Int) -> Bille? {
        return self.board[verticale][horizontale]
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

struct Bille:BilleProtocole, Hashable {
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

    mutating func setPosition(horizontale: Int, verticale: Int) {
        self.posH = horizontale
        self.posV = verticale
    }

    init(couleur: String, horizontale: Int, verticale: Int) {
        self.couleur = couleur
        self.posH = horizontale
        self.posV = verticale
    }
}
