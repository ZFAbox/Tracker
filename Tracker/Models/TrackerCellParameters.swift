//
//  TrackerCellParameters.swift
//  Tracker
//
//  Created by Fedor on 14.06.2024.
//

import Foundation


struct TrackerCellPrameters {
    
    var numberOfCellsInRow: Int
    var height: Int
    var horizontalSpacing: Int
    var verticalSpacing: Int
    
    init(numberOfCellsInRow: Int, height: Int, horizontalSpacing: Int, verticalSpacing: Int) {
        self.numberOfCellsInRow = numberOfCellsInRow
        self.height = height
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }
}
