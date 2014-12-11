//
//  Quotes.swift
//  Positifity
//
//  Created by Dan Isacson on 11/12/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import Foundation

class Quotes{
    class func randomQuote()->String{
        let quotes = ["Energy and persistence conquer all things.",
            "Strive for progress, not perfection.",
            "You miss 100% of the shots you don't take.",
            "If you don’t make mistakes, you aren’t really trying.",
            "You live longer once you realize that any time spent being unhappy is wasted.",
            "Strength does not come from physical capacity. It comes from an indomitable will.",
            "Motivation will almost always beat mere talent.",
            "Nothing great was ever achieved without enthusiasm.",
            "Insanity: doing the same thing over and over again and expecting different results.",
            "Ability is what you're capable of doing. Motivation determines what you do. Attitude determines how well you do it.",
            "Motivation is what gets you started. Habit is what keeps you going."
        ]
        
        var x = UInt32(quotes.count)
        var random = Int(arc4random_uniform(x))
        return quotes[random]
    }
}