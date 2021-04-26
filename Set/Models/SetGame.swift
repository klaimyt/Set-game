//
//  Set.swift
//  Set
//
//  Created by Иван Клименков on 26.3.2021.
//  Copyright © 2021 klaimyt. All rights reserved.
//

import Foundation

struct SetGame {
    
    let cards: Set<Card>
    
    var chosenCards = [Card]()
    var matchedCards = Set<Card>()
    
    var isMatched: Bool? 
    
    mutating func chooseCard(_ card: Card) {
        if !chosenCards.contains(card), chosenCards.count < 3 {
            isMatched = nil
            chosenCards.append(card)
        } else if chosenCards.count > 2 {
            if isMatched == true {
                for card in chosenCards {
                    matchedCards.insert(card)
                }
            }
            chosenCards.removeAll()
            chosenCards.append(card)
        }
        
        if chosenCards.count == 3 {
            let firstCard = chosenCards[0].possibilities
            let secondCard = chosenCards[1].possibilities
            let thirdCard = chosenCards[2].possibilities
            
            forinLoop: for i in firstCard.indices {
                switch (firstCard[i], secondCard[i], thirdCard[i]) {
                case(let a, let b , let c) where a != b && b != c && a != c:
                    break
                case(let a, let b, let c) where a == b && b == c:
                    break
                default:
                    isMatched = false
                    break forinLoop
                }
                if i + 1 == firstCard.count {
                    for choosenCard in chosenCards {
                        matchedCards.insert(choosenCard)
                    }
                    isMatched = true
                }
            }
        }
    }
    
    init() {
        let defaultNumberOfCards = 81
        var temp = Set<Card>()
        for _ in 1...defaultNumberOfCards {
            let card = Card()
            temp.insert(card)
        }
        cards = temp
    }
}
