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
        if Int.random(in: 0...999)%2 == 0 {
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

        //Exemple de position proche de la fin regroupant toutes les éléments qui pourraient poser problème lors du calcul des scores. Simple branche et structure en "oeil"
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 3, verticale: 2))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 4, verticale: 2))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 2))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 2, verticale: 3))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 3, verticale: 3))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 3))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 2, verticale: 1))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 3, verticale: 4))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 4, verticale: 4))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 4))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 5, verticale: 5))
        self.playerBalls[Player.B.rawValue]?.append(Bille.init(couleur: Player.B.rawValue, horizontale: 2, verticale: 7))

        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 2, verticale: 6))
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
        self.playerBalls[Player.N.rawValue]?.append(Bille.init(couleur: Player.N.rawValue, horizontale: 4, verticale: 5))
        
        //_ = Jeu.fillBoard(board: &self.board, balls: &playerBalls, couleur: Player.random())

        for (_,balls) in self.playerBalls {
            for ball in balls {
                self.board[ball.getPosVerticale()][ball.getPosHorizontale()] = ball
            }
        }
    }


    //Fonction récursive pour remplir le plateau. Renvoie true s'il est possible de remplir le plateau à la position indiquée avec une bille appatenant au joueur
    private static func fillBoard(board:inout[[Bille?]], balls:inout[String:[Bille]], couleur:Player, x:Int=1, y:Int=0) -> Bool {
            var newX=x, newY=y

            //Détermination de la position de la case suivante en suivant un parcours anti-trigonométrique
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
                return fillBoard(board: &board, balls: &balls, couleur: couleur, x:newX, y:newY) //On est sur un coin, il faut donc poursuivre le remplissage sur la case suivante
            }
            guard balls[couleur.rawValue]!.count <= 12 && balls[couleur.next().rawValue]!.count <= 12 else {
                return false //Une joueur a plus de 12 billes, le placement est donc faux
            }
            guard board[y][x] == nil else {
                if balls[couleur.rawValue]?.count == 12 && balls[couleur.next().rawValue]?.count == 12 { //On est sûr d'être sur un bord et pas sur un coin. Si la case n'est pas vide, alors c'est qu'on a bouclé sur tout le plateau. On s'assure que chaque joueur ait 12 billes 
                    return true
                } else {
                    return false
                }
            }

            let bille = Bille.init(couleur: couleur.rawValue, horizontale: x, verticale: y)

            //Vérifie si le joueur peut poser sa bille ici
            if Jeu.canBeSetOnBorder(board: &board, couleur: couleur.rawValue, horizontale: x, verticale: y) {
                board[y][x] = bille
                balls[couleur.rawValue]?.append(bille)

                if fillBoard(board: &board, balls: &balls, couleur: Player.random(), x:newX, y:newY) { //On essaie de remplir le reste du plateau
                    return true //Toutes les billes après ont pu être placé, donc le placement est correct
                } else { //Les billes suivantes n'ont pas pu être placées, le placement est incorrect
                    board[y][x] = nil
                    balls[couleur.rawValue]?.removeLast()
                }
            }

            //Le joueur ne peut pas poser sa bille, on essaie avec l'autre joueur
            let billeOther = Bille.init(couleur: couleur.next().rawValue, horizontale: x, verticale: y)
            if Jeu.canBeSetOnBorder(board: &board, couleur: couleur.next().rawValue, horizontale: x, verticale: y) {
                board[y][x] = billeOther
                balls[couleur.next().rawValue]?.append(billeOther)
                if fillBoard(board: &board, balls: &balls, couleur: couleur.next(), x:newX, y:newY) { //Même si le premier joueur pouvait poser sa bille, le placement derrière n'est pas bon. On essaie donc avec une bille de l'autre joueur
                    return true
                } else {
                    board[y][x] = nil
                    balls[couleur.next().rawValue]?.removeLast()
                }
            }

            return false //Aucun joueur n'a pu poser sa bille, la placement est donc faux, il faut revenir en arrière
    }

    static func canBeSetOnBorder(board:inout[[Bille?]], couleur: String, horizontale: Int, verticale: Int) -> Bool {
        var balls = [Bille]()
        balls.reserveCapacity(24)
        var index = 0
        //Rajoute au tableau toutes les billes déjà posées pour pouvoir vérifier l'alignement dans checkAlignement(bille:[Bille],couleur:String)Bool
        for i in 1..<Jeu.maxLength-1 {//La première ligne
            if let ball = board[0][i] { balls.append(ball); index+=1 }
        }
        for i in 1..<Jeu.maxLength-1 {//La dernière colonne
            if let ball = board[i][Jeu.maxLength-1] { balls.append(ball); index+=1 }
        }

        for i in stride(from: Jeu.maxLength-2, through: 1, by: -1) {//La dernière ligne
            if let ball = board[Jeu.maxLength-1][i] { balls.append(ball); index+=1 }
        }
        for i in stride(from: Jeu.maxLength-2, through: 1, by: -1) {//La première colonne
            if let ball = board[i][0] { balls.append(ball); index+=1 }
        }

        return isOnBorder(x: horizontale, y: verticale) && checkAlignement(balls:balls, couleur: couleur)
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
    private static func checkAlignement(balls:[Bille], couleur:String) -> Bool {
        //Si on a posé moins de 2 billes, il ne sert à rien de faire la vérification, elle sera vrai dans tous les cas
        guard balls.count >= 2 else {
            return true
        }
        
        var nbSame=0 //nombre de bille de la même couleur que 'couleur'
        var index=0 //compteur pour les toutes premières billes. Utilisé pour vérifier le placement de la dernière bille.
        var i = 0
        while i < 2 {
            //On ne doit vérifier que 2 boules
            if balls[balls.count-1 - nbSame].getCouleur() == couleur { nbSame+=1 } //Vérifie les 2 dernières billes
            if balls.count == 23 && balls[index].getCouleur() == couleur { index+=1; nbSame+=1 }  //Vérifie si la dernière bille est bien placé (vérifie en plus les premières billes posées). count==23 car on vérifie avant de poser, donc la taille maximale de balls sera 23 et non 24
            i+=1
        }

        return nbSame < 2
    }

    func canPlayerMove(couleur: String) -> Bool {
        guard playerBalls.keys.contains(couleur) else {
            return false
        }

        var canMove = false
        //Un joueur peut se déplacer s'il existe au moins une bille qui peut se déplacer
        for bille in self.playerBalls[couleur]! {
            if canBilleMove(bille: bille) { canMove = true } //Un joueur peut bouger si au moins une de ses billes peut bouger
        }

        return canMove
    }

    func canBilleMove(bille: Bille) -> Bool {
        let x = bille.getPosHorizontale(), y = bille.getPosVerticale()
        guard Jeu.isOnBorder(x: x, y: y) else {
            return false
        }
        
        var canMove = false
        //Une bille peut bouger s'il existe au moins un emplacement vide
        for i in 1..<Jeu.maxLength-1 {
            //On itère sur ...
            if x==0 || x==Jeu.maxLength-1 { //... une ligne
                if self.board[y][i] == nil { canMove = true }
            } else { //... une colonne
                if self.board[i][x] == nil { canMove = true }
            }
        }

        return canMove //Une bille peut bouger s'il existe au moins une case vide
    }

    func isBorder(horizontale: Int, verticale: Int) -> Bool {
        guard Jeu.isOnBorder(x: horizontale, y: verticale) else {
            return false
        }
        guard self.board[verticale][horizontale] != nil else {
            return false
        }
        return true
    }

    //Une bille peut bouger si les billes qu'elle va déplacer ne sortent pas du centre du plateau (1<=x,y<=6)
    func canBilleMoveAtPos(bille: Bille, horizontale: Int, verticale: Int) -> Bool {
        let x = bille.getPosHorizontale(), y = bille.getPosVerticale()
        guard (x==horizontale || y==verticale) && Jeu.isOnBorder(x:x, y:y) else {
            return false
        }

        var nbBalls = 0
        //Compte le nombre de bille (sans compter celle à bouger) pour le comparer avec le nombre d'emplacement disponible après déplacement
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

    //Détermine le nombre de bille max qu'une bille peut décaler en se déplaçant
    private func getMaxNbBalls(pos:Int, target:Int) -> Int {
        if pos-target > 0 { //Gère les cas où pos = Jeu.maxLength-1
            return target-1 //Les billes poussés ne doivent pas aller plus loin que la case (_,1) ou (1,_). En excluant la case cible, il reste donc target - 1 cases
        } else { //Gère les cas où pos = 0
            return Jeu.maxLength-2-target //Les billes poussés ne doivent pas aller plus loin que la case (Jeu.maxLength-2,_) ou (_,Jeu.maxLength-2). En excluant la case cible, il reste donc Jeu.maxLength-2-target cases
        }
    }

    mutating func moveBilleAtPos(bille: Bille, horizontale: Int, verticale: Int) {
        func moveBallTo(bille1:Bille, x:Int, y:Int, initX:Int, initY:Int) {//initX et initY pour garder la position initiale de la bille (car bille type référence) et déterminer comment décaler la(les) bille(s) à déplacer
            guard let existingBall = self.board[y][x] else { //Si la case est vide, on peut poser directement la bille et mettre à jour ses attributs
                bille1.setPosition(horizontale: x, verticale: y)
                self.board[y][x] = bille1
                return
            }

            var billeX = existingBall.getPosHorizontale()
            var billeY = existingBall.getPosVerticale()

            //Détermine où poser la bille existant déjà sur cette position
            if initX == horizontale { //On déplace la bille sur une colonne
                if initY < billeY { billeY += 1 } //Détermine le sens de décalage
                else { billeY -= 1 }
            } else { //On déplace la bille sur une ligne
                if initX < billeX { billeX += 1 } //Détermine le sens de décalage
                else { billeX -= 1}
            }

            bille1.setPosition(horizontale: x, verticale: y)
            self.board[y][x] = bille1
            moveBallTo(bille1: existingBall, x: billeX, y: billeY, initX: initX, initY: initY) //La condition d'arrêt est lorsque self.board[verticale][horizontale] est nil. Alors on place la bille 
        }

        guard canBilleMoveAtPos(bille: bille, horizontale: horizontale, verticale: verticale) else { //Implique que x==horizontale ou y==verticale
            return
        }

        var count = 1
        let x = bille.getPosHorizontale() //Très important de les stocker avant, car type référence, 
        let y = bille.getPosVerticale() //x et y prennent leur nouvelle valeur, soit verticale ou horizontale...


        self.board[bille.getPosVerticale()][bille.getPosHorizontale()] = nil
        moveBallTo(bille1: bille, x: horizontale, y: verticale, initX: x, initY: y)


        if x==horizontale {
            let range = getRange(pos: y, target: verticale)
            
            for i in range.0 {
                if let newBille = self.board[i][x] {
                    self.board[i][x] = nil
                    moveBallTo(bille1: newBille, x: horizontale, y: verticale+(count*range.1), initX: x, initY: y) //Si (y||x)==Jeu.maxLength-1, alors on mettra la bille en target-count (count représente le nombre de billes déjà décalées (en comptant la première bille)). Si (y||x)==0, alors on mettra la bille en target+count. On décalle les billes en gardant l'ordre dans laquelle elles étaient.
                    count+=1
                }
            }
        } else {
            let range = getRange(pos: x, target: horizontale)

            for i in range.0 {
                if let newBille = self.board[y][i] {
                    self.board[y][i] = nil
                    moveBallTo(bille1: newBille, x: horizontale+(count*range.1), y: verticale, initX: x, initY: y)
                    count+=1
                }
            }
        }
    }

    //Renvoie la range sur laquelle vérifier s'il y a des boules et le step à suivre
    private func getRange(pos:Int, target:Int) -> (StrideTo<Int>, Int) {
        guard pos-target != 0 else {
            return (stride(from: 0, to: 0, by: 1), 0)
        }
        if pos-target > 0 { //Gère les cas où pos = Jeu.maxLength-1
            return (stride(from: Jeu.maxLength-2, to: target, by: -1), -1) //Les billes poussés ne doivent pas aller plus loin que la case (_,1) ou (1,_). En excluant la case cible, il reste donc target - 1 cases
        } else { //Gère les cas où pos = 0
            return (stride(from: 1, to: target, by: 1), 1) //Les billes poussés ne doivent pas aller plus loin que la case (Jeu.maxLength-2,_) ou (_,Jeu.maxLength-2). En excluant la case cible, il reste donc Jeu.maxLength-2-target cases
        }
    }

    func getBilleAtPos(horizontale: Int, verticale: Int) -> Bille? {
        guard horizontale >= 0 && horizontale < Jeu.maxLength && verticale >= 0 && verticale < Jeu.maxLength else {
            return nil
        }
        return self.board[verticale][horizontale]
    }

    func biggestGroup(couleur: String) -> Int {
        guard self.playerBalls.keys.contains(couleur) else {
            fatalError("La couleur demandé n'existe pas")
        }

        var max = 0
        var beenThere=[Bille]() //L'ensemble des billes déjà parcourues
        beenThere.reserveCapacity(12)

        for ball in self.playerBalls[couleur]! {
            //Invariant : chaque groupe parcouru est inférieur ou égal en taille au groupe auquel appartient la bille
            let count = group(bille: ball, beenThere: &beenThere) //Pour chaque bille sur laquelle on est pas passé (et par extension son groupe) on récupère la taille de son groupe
            if count > max {
                max = count
                //On rétablit l'invariant
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
            let count = group(bille: ball, beenThere: &beenThere)
            prod *= count //Pour chaque bille sur laquelle on est pas déjà passé (et par extension son groupe) on multiplie au produit la taille de son groupe
        }

        return prod
    }

    func getGroup(bille: Bille) -> Int { //Fonction non utilisé car ne permettait difficilement de faire la fonction multGroup. Il était moins complexe d'avoir une fonction avec en paramètre inout un tableau des billes déjà parcourues. Cela permettait d'éviter de parcourir plusieurs fois le même groupe de bille (pas un problème pour déterminer le groupe max, mais est un problème pour la régle de calcul avec la multiplication).
        return 0
    }

    //Le paramètre beenThere en inout permet d'éviter de parcourir plusieurs fois un même groupe (grâce au inout). Il permet aussi d'éviter de boucler à l'infini quand on tombe sur un enchaînement du type "oeil" (comme en go)
    private func group(bille:Bille, beenThere:inout [Bille]) -> Int {
        let x = bille.getPosHorizontale()
        let y = bille.getPosVerticale()
        beenThere.append(bille)

        var count = 1 //Il existe au moins une bille, on a donc une longueur de 1
        //Parcours du groupe dans les directions Nord, Sud, Est, Ouest. On ne parcourt dans la direction indiquée que si on ne dépasse pas du tableau, s'il existe une bille et qu'elle est de la même couleur que la bille actuelle
        if y>0, let newBranch = self.board[y-1][x], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                count += group(bille: newBranch, beenThere: &beenThere)
            }
        }
        if x<Jeu.maxLength-1, let newBranch = self.board[y][x+1], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                count += group(bille: newBranch, beenThere: &beenThere)
            }
        }
        if y<Jeu.maxLength-1, let newBranch = self.board[y+1][x], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                count += group(bille: newBranch, beenThere: &beenThere)
            }
        }
        if x>0, let newBranch = self.board[y][x-1], newBranch.getCouleur()==bille.getCouleur() {
            if !ballContained(bille: newBranch, beenThere: &beenThere) {
                count += group(bille: newBranch, beenThere: &beenThere)
            }
        }
        
        return count
    }

    private func ballContained(bille:Bille, beenThere:inout [Bille]) -> Bool {
        var contains=false
        for ball in beenThere {
            if ball===bille { contains = true }
        }
        return contains
    }
}