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
    
    var shapesInView = [NSAttributedString]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCardsFromModel(12)
        shapesInView = shapeToCard.map {$0.key}
        updateView()
    }
    
    @IBAction func cardButtonPressed(_ sender: UIButton) {
        if let attributedString = sender.attributedTitle(for: .normal),
            let card =  shapeToCard[attributedString] {
            game.chooseCard(card)
            updateView(for: cardButtons.firstIndex(of: sender))
        }
    }
    

    @IBAction func newGameButtonPressed(_ sender: UIButton) {
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
    
    private func removeMatchedCards() {
        for (key, value) in shapeToCard {
            if game.matchedCards.contains(value) {
                shapeToCard.removeValue(forKey: key)
            }
        }
    }
    
    private func updateView(for buttonIndex: Int? = nil) {
        let chosenButtons = cardButtons.filter { $0.layer.borderWidth == 3 }
        for index in cardButtons.indices {
            if index < shapesInView.count {
                cardButtons[index].setAttributedTitle(shapesInView[index], for: .normal)
            } else {
                cardButtons[index].setAttributedTitle(nil, for: .normal)
            }
            
            if let buttonIndex = buttonIndex {
                if chosenButtons.count < 3 {
                    cardButtons[buttonIndex].layer.borderWidth = 3
                    if let isMatched = game.isMatched,
                        cardButtons[index].layer.borderWidth == 3  {
                        
                        cardButtons[index].backgroundColor = isMatched ? .green : .orange
                    }
                } else {
                    cardButtons[index].layer.borderWidth = 0
                    cardButtons[index].backgroundColor = .white
                }
            }
        }
//        for (index, dictionary) in shapeToCard.enumerated() {
//            if index < cardButtons.count {
//                cardButtons[index].layer.borderWidth = game.chosenCards.contains(dictionary.value) ? 3.0 : 0
//                if game.isMatched == true && game.chosenCards.contains(dictionary.value) {
//                    cardButtons[index].backgroundColor = UIColor.green.withAlphaComponent(0.5)
//                } else if game.isMatched == false && game.chosenCards.contains(dictionary.value) {
//                    cardButtons[index].backgroundColor = UIColor.orange.withAlphaComponent(0.5)
//                } else {
//                    cardButtons[index].backgroundColor = UIColor.white
//                }
//
//                if game.matchedCards.contains(dictionary.value) {
//                    shapeToCard.removeValue(forKey: dictionary.key)
//                } else {
//                    cardButtons[index].setAttributedTitle(dictionary.key, for: .normal)
//                }
//            }
//        }
    }
    
}

