//
//  SymbolCategories.swift
//  SFSymbolCollection
//
//  Created by Michael Lin on 3/15/21.
//

import Foundation
import UIKit

enum SymbolCategories: String, CaseIterable {
    case weather = "Weather"
    case objectsAndTools = "Objects & Tools"
    case devices = "Devices"
    case connectivity = "Connectivity"
    case human = "Human"
    case nature = "Nature"
    case editing = "Editing"
    
    init?(index: Int) {
        guard index < SymbolCategories.allCases.count else { return nil }
        self = SymbolCategories.allCases[index]
    }
    
    func numberOfRows() -> Int {
        switch self {
        case .weather, .devices, .human, .connectivity:
            return 1
        case .objectsAndTools, .nature:
            return 2
        case .editing:
            return 3
        }
    }
    
    func getScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .weather :
            return .continuous
        case .devices:
            return .continuousGroupLeadingBoundary
        case .human:
            return .groupPaging
        case .connectivity:
            return .groupPagingCentered
        case .nature:
            return .paging
        case .editing:
            return .none
        case .objectsAndTools:
            return .groupPaging
        }
    }
}
