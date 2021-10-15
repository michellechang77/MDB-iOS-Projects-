//
//  ViewController.swift
//  Pokedex
//
//  Created by Michelle Chang on 8/10/21.
//

import UIKit

class DetailsVC: UIViewController {
    
    var pokemon:Pokemon!
    
    
    
    private let nameID: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let labels: [UILabel] = {
        let details: [String] = ["attack: ", "defense: ", "health: ", "special attack: ", "special defense: ", "speed: ", "total: "]
        return (0..<8).map { index in
            let label = UILabel()
            //label.text = details[index]
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let link = pokemon?.imageUrl
        let stringfied = link?.absoluteString
        if let url: URL = URL(string: (stringfied)!) {
            if let data = try? Data(contentsOf: url) {
                    imageView.image = UIImage(data: data)
                }
        }
        nameID.text = "\(pokemon.name) (\(pokemon.id))"
        labels[0].text = "Attack:\(pokemon.attack)"
        labels[1].text = "Defense:\(pokemon.attack)"
        labels[2].text = "Health:\(pokemon.health)"
        labels[3].text = "Special Attack:\(pokemon.specialAttack)"
        labels[4].text = "Special Defense:\(pokemon.specialDefense)"
        labels[5].text = "Speed:\(pokemon.speed)"
        labels[6].text = "Total:\(pokemon.total)"
        var types: [String] = []
        for type in pokemon.types {
            switch type {
            case .Bug:
                types.append("Bug")
            case .Grass:
                types.append("Grass")
            case .Dark:
                types.append("Dark")
            case .Ground:
                types.append("Ground")
            case .Dragon:
                types.append("Dragon")
            case .Ice:
                types.append("Ice")
            case .Electric:
                types.append("Electric")
            case .Normal:
                types.append("Normal")
            case .Fairy:
                types.append("Fairy")
            case .Poison:
                types.append("Poison")
            case .Fighting:
                types.append("Fighting")
            case .Psychic:
                types.append("Psychic")
            case .Fire:
                types.append("Fire")
            case .Rock:
                types.append("Rock")
            case .Flying:
                types.append("Flying")
            case .Steel:
                types.append("Steel")
            case .Ghost:
                types.append("Ghost")
            case .Water:
                types.append("Water")
            case .Unknown:
                types.append("Unknown")
            }
        }
        let typesStr: String = types.joined(separator: ", ")
        labels[7].text = "Types: \(typesStr)"
        
        for i in 0...7 {
            view.addSubview(labels[i])
            labels[i].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            labels[i].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        }
        
        view.addSubview(nameID)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            nameID.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            nameID.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameID.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: nameID.bottomAnchor, constant: 25),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            labels[0].topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            labels[1].topAnchor.constraint(equalTo: labels[0].bottomAnchor, constant: 10),
            labels[2].topAnchor.constraint(equalTo: labels[1].bottomAnchor, constant: 10),
            labels[3].topAnchor.constraint(equalTo: labels[2].bottomAnchor, constant: 10),
            labels[4].topAnchor.constraint(equalTo: labels[3].bottomAnchor, constant: 10),
            labels[5].topAnchor.constraint(equalTo: labels[4].bottomAnchor, constant: 10),
            labels[6].topAnchor.constraint(equalTo: labels[5].bottomAnchor, constant: 10),
            labels[7].topAnchor.constraint(equalTo: labels[6].bottomAnchor, constant: 10)
        ])
    }
}
