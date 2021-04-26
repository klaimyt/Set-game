//
//  Card.swift
//  Set
//
//  Created by Иван Клименков on 26.3.2021.
//  Copyright © 2021 klaimyt. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    // Shape, color, gradient, count
    let possibilities: [Possibility]
    
    enum Possibility {
        case first, second, third
    }
    
    private static var id = 0
    
    private static func getUniqueIdentifier() -> Int {
        id += 1
        return (id - 1)
    }
    
    init() {
        let numberOfPossibilities = 4
        var buffer = [Possibility]()
        var value = Double(Card.getUniqueIdentifier())
        for _ in 0..<numberOfPossibilities {
            let number = value / Double(numberOfPossibilities - 1)
            let reminder = number.truncatingRemainder(dividingBy: 1)
            switch reminder {
            case 0.5...0.9:
                buffer.append(Possibility.third)
            case 0.1...0.49:
                buffer.append(Possibility.second)
            case 0:
                buffer.append(Possibility.first)
            default:
                print("Card init error")
            }
            value = number.rounded(.towardZero)
        }
        possibilities = buffer
    }
}


