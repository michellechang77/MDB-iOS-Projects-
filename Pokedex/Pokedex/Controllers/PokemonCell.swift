//
//  SymbolCollectionCell.swift
//  Pokedex
//
//  Created by Michelle Chang on 8/10/21.
//
import UIKit


class PokemonCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: PokemonCell.self)
        
    var pokemon: Pokemon? {
        didSet {
            let link = pokemon?.imageUrl
            if let stringfied = link?.absoluteString,
                let url = URL(string: stringfied) {
                if let data = try? Data(contentsOf: url) {
                        imageView.image = UIImage(data: data)
                    }
            } else {
                imageView.image = nil
            }
            
            let name: String = pokemon?.name ?? ""
            let id: Int = pokemon?.id ?? 0
            infoView.text = "\(id): \(name)"
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let infoView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
