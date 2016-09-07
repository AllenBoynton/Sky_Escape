//
//  Utilities.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/6/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import Foundation


extension Array {
    func randomElement() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}