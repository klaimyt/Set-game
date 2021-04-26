//
//  ViewController.swift
//  Set
//
//  Created by Иван Клименков on 26.3.2021.
//  Copyright © 2021 klaimyt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet var scoreLabel: UILabel!
    
    private(set) var game = SetGame()
    
    var shapeToCard = [NSAttributedString: Card]()
    var shapesInView = [NSAttributedString?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        loadCardsFromModel(12)
        updateView()
    }
    
    @IBAction func cardButtonPressed(_ sender: UIButton) {
        if let attributedString = sender.attributedTitle(for: .normal),
            let card =  shapeToCard[attributedString] {
            game.chooseCard(card)
            updateView()
        }
    }
    

    @IBAction func newGameButtonPressed(_ sender: UIButton) {
    }
    

    @IBAction func deal3MoreCardsButtonPressed() {
        loadCardsFromModel(3)
    }
    
    
    private func loadCardsFromModel(_ count: Int = 12) {
        let modelCards = game.cards.subtracting(game.matchedCards)
        var viewCards = Set<Card>()
        for card in shapeToCard.values {
            viewCards.insert(card)
        }
        
        let unloadedCards = modelCards.subtracting(viewCards)
        if unloadedCards.count > 2 {
            let range = unloadedCards.startIndex..<unloadedCards.index(unloadedCards.startIndex, offsetBy: count)
            for card in unloadedCards[range] {
                getShapeForCard(card)
            }
        }
        loadCardsToView()
    }
    
    private func removeMatchedCardsFromView() {
        for shape in shapesInView {
            if shape != nil, shapeToCard[shape!] == nil {
                shapeToCard[shape!] = nil
            }
        }
    }
    
    private func initialLoad() {
        for index in 0..<24 {
            shapesInView.append(nil)
        }
    }
    
    private func loadCardsToView() {
        var shapesFromModel: Set<NSAttributedString?> = Set(shapeToCard.keys)
        let shapesFromView = Set(shapesInView)
        let matchedCards = game.matchedCards
        
        var newShapes = shapesFromModel.subtracting(shapesFromView)
        
        for index in 0..<newShapes.count {
            if shapesInView[index] == nil {
                shapesInView[index] = shapesFromModel.removeFirst()
            }
        }
        updateView()
    }
    
    private func getShapeForCard(_ card: Card) {
        let possibilities = card.possibilities
        var sign: String!
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.font] = UIFont.systemFont(ofSize: 26)
        
        switch (possibilities[0], possibilities[1], possibilities[2], possibilities[3]) {
        case (let color, let gradient, let shape, let count):
            switch color {
            case .first:
                attributes[.foregroundColor] = UIColor.red
            case .second:
                attributes[.foregroundColor] = UIColor.orange
            case .third:
                attributes[.foregroundColor] = UIColor.blue
            }
            switch gradient {
            case .first:
                attributes[.strokeWidth] = 5.0
            case .second:
                attributes[.strokeWidth] = 20.0
            case .third:
                break
            }
            switch shape {
            case .first:
                sign = "▲"
            case .second:
                sign = "●"
            case .third:
                sign = "■"
            }
            switch count {
            case .first:
                break
            case .second:
                sign += sign
            case .third:
                sign += sign + sign
            }
            if game.matchedCards.contains(card) == false {
                shapeToCard[NSAttributedString(string: sign, attributes: attributes)] = card
            }
        }
    }
    
//    private func removeMatchedCards() {
//        for index in cardButtons.indices {
//            if let card = shapeToCard[cardButtons[index].attributedTitle(for: .normal) ?? NSAttributedString(string: "")] {
//                if game.matchedCards.contains(card) {
//                    cardButtons[index].setAttributedTitle(nil, for: .normal)
//                }
//            }
//        }
//
//        for (key, value) in shapeToCard {
//            if game.matchedCards.contains(value) {
//                shapeToCard.removeValue(forKey: key)
//            }
//        }
//    }
    
    private func updateView() {
//        removeMatchedCards()
        for index in cardButtons.indices {
            if index < shapesInView.count {
                cardButtons[index].setAttributedTitle(shapesInView[index], for: .normal)
                
                if let shapeInView = shapesInView[index] {
                    if shapeToCard[shapeInView] != nil, game.chosenCards.contains(shapeToCard[shapeInView]!) {
                        if game.isMatched == true {
                            cardButtons[index].backgroundColor = UIColor.green.withAlphaComponent(0.5)
                        } else if game.isMatched == false {
                            cardButtons[index].backgroundColor = UIColor.orange.withAlphaComponent(0.5)
                        }
                        cardButtons[index].layer.borderWidth = 3.0
                    } else {
                        cardButtons[index].layer.borderWidth = 0
                        cardButtons[index].backgroundColor = .white
                    }
                }
            }
            
            if cardButtons[index].attributedTitle(for: .normal) == nil {
                cardButtons[index].isHidden = true
            } else {
                cardButtons[index].isHidden = false
            }
        }
    }
    
}

