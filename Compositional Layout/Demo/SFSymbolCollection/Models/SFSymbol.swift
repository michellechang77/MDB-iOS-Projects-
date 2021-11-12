//
//  SFSymbol.swift
//  SFSymbolCollection
//
//  Created by Michael Lin on 2/22/21.
//

import Foundation
import UIKit

struct SFSymbol: Hashable {
    var id = UUID().uuidString
    var name: String
    var image: UIImage
    
    init?(name: String) {
        self.name = name
        let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemBlue)
        guard let image = UIImage(systemName: name, withConfiguration: config) else { return nil }
//        image = image
//            .withTintColor(.label, renderingMode: .alwaysOriginal)
        self.image = image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
