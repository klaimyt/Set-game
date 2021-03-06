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
    
    private var shapeToCard = [NSAttributedString: Card]()
    private var shapesInView = [NSAttributedString?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        updateView()
    }
    
    @IBAction func cardButtonPressed(_ sender: UIButton) {
        if let attributedString = sender.attributedTitle(for: .normal),
            let card =  shapeToCard[attributedString] {
            game.chooseCard(card)
            updateView()
        }
    }
    
    @IBAction func deal3MoreCardsButtonPressed() {
        loadCardsFromModel(3)
    }
    
    private func initialLoad() {
        for _ in cardButtons.indices {
            shapesInView.append(nil)
        }
        loadCardsFromModel()
    }
    
    private func loadCardsFromModel(_ count: Int = 12) {
        let modelCards = game.cards.subtracting(game.matchedCards)
        let viewCards = Set(shapeToCard.values)
        let unloadedCards = modelCards.subtracting(viewCards)
        
        if unloadedCards.count > 2 {
            let range = unloadedCards.startIndex..<unloadedCards.index(unloadedCards.startIndex, offsetBy: count)
            for card in unloadedCards[range] {
                getShapeForCard(card)
            }
        }
        loadCardsToView()
    }
    
    private func loadCardsToView() {
        let shapesFromModel: Set<NSAttributedString?> = Set(shapeToCard.keys)
        let shapesFromView = Set(shapesInView)
        
        var newShapes = shapesFromModel.subtracting(shapesFromView)
        
        for index in shapesInView.indices {
            if newShapes.count > 0, shapesInView[index] == nil {
                shapesInView[index] = newShapes.removeFirst()
            }
        }
        updateView()
    }
    
    private func removeMatchedCards() {
        for (key, value) in shapeToCard {
            if game.matchedCards.contains(value),
                game.isMatched == nil {
                
                shapeToCard.removeValue(forKey: key)
            }
        }
        
        for index in shapesInView.indices {
            if shapesInView[index] != nil,
                shapeToCard[shapesInView[index]!] == nil,
                game.isMatched == nil {
                
                shapesInView[index] = nil
            }
        }
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
    
    private func updateView() {
        removeMatchedCards()
        for index in cardButtons.indices {
            cardButtons[index].setAttributedTitle(shapesInView[index], for: .normal)
            
            if let shapeInView = shapesInView[index] {
                if shapeToCard[shapeInView] != nil,
                    game.chosenCards.contains(shapeToCard[shapeInView]!) {
                    
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
            
            if cardButtons[index].attributedTitle(for: .normal) == nil {
                cardButtons[index].backgroundColor = .clear
                cardButtons[index].layer.borderWidth = 0
            }
        }
    }
}

