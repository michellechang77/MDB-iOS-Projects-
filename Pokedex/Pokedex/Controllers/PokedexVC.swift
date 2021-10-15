//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit


class PokedexVC: UIViewController {
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    var inGridView: Bool = false
    let types: [String] = ["All", "Bug", "Grass","Dark","Ground", "Dragon", "Electric", "Normal", "Fairy", "Poison", "Fighting", "Psychic", "Fire", "Rock", "Flying", "Steel","Ghost","Water","Unknown"]

        var currTypes: [String]?
        
        var currSelectedType: String = "All"
        
        var currPokemons: [Pokemon]?
        
        var copyCurrPokemons: [Pokemon]?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    let titleLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = "POKEDEX"
            lbl.textAlignment = .center
            lbl.font = .systemFont(ofSize: 30)
            lbl.textColor = .black
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let toggleView: UIButton = {
            let b = UIButton()
            b.setImage(UIImage(systemName: "envelope"), for: .normal)
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
            b.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
            b.imageView?.tintColor = .black
            b.translatesAutoresizingMaskIntoConstraints = false
            return b
        }()
        
        var searchBar: UISearchBar!

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            view.addSubview(toggleView)
            view.addSubview(titleLabel)
            view.addSubview(collectionView)
            
            toggleView.addTarget(self, action: #selector(didTapToggle(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                toggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                toggleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                toggleView.widthAnchor.constraint(equalTo: toggleView.heightAnchor, constant: 10)
            ])
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
            
            collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 230, left: 30, bottom: 0, right: 30))
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = false
            
            
            searchBar = UISearchBar.init(frame: .zero)
            searchBar.setShowsCancelButton(true, animated: false)
            searchBar.delegate = self
            view.addSubview(searchBar)
            
            searchBar.tintColor = .blue
            searchBar.barTintColor = .white
            searchBar.showsCancelButton = true
            searchBar.showsScopeBar = true
            searchBar.isTranslucent = false
            currPokemons = pokemons
            copyCurrPokemons = currPokemons
            currTypes = types
            searchBar.scopeButtonTitles = currTypes
            
        }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeArea = view.safeAreaInsets
        //let searchBarSTF = searchBar.sizeThatFits(CGSize.init(width: view.bounds.width - 50, height: 30))
        searchBar.frame = CGRect.init(x: view.bounds.width/8, y: safeArea.top + 120, width: view.bounds.width / 3.5 * 3, height: 30)
    }
    
        
        @objc func didTapToggle(_ sender: UIButton) {
            if inGridView {
                inGridView = false
                toggleView.backgroundColor = .clear
                toggleView.imageView?.tintColor = .lightGray
                
            } else {
                inGridView = true
                toggleView.backgroundColor = .clear
                toggleView.imageView?.tintColor = .white
                toggleView.layer.cornerRadius = 10
            }
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }


    extension PokedexVC: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return currPokemons!.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let pokemon = currPokemons?[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
            cell.pokemon = pokemon
            return cell
        }
    }

    extension PokedexVC: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if inGridView {
                return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
            }
            return CGSize(width: view.frame.width, height: 120)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let pokemon = currPokemons?[indexPath.item]
            let details = DetailsVC()
            details.pokemon = pokemon
            present(details, animated: true, completion: nil)
        }
    }

    extension PokedexVC: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //filter pokemons based on string
            currPokemons = pokemons.filter({ p in
                p.name.contains(searchText)
            })
            if currPokemons?.count == 0 {
                currPokemons = PokemonGenerator.shared.getPokemonArray()
            }

            //if user selected a type, filter another layer for that type
            if (currSelectedType != "All") {
                currPokemons = currPokemons?.filter({ p in
                    for t in p.types {
                        if t.rawValue == currSelectedType {
                            return true
                        }
                    }
                    return false
                })
            }

            //update scope filters
            var newScopeArr: [String] = ["All"]
            for p in currPokemons! {
                for t in p.types {
                    newScopeArr.append(t.rawValue)
                }
            }
            let newScopeSet = Set(newScopeArr) //get rid of duplicates
            currTypes = Array(newScopeSet)
            searchBar.scopeButtonTitles = currTypes
            copyCurrPokemons = currPokemons
            collectionView.reloadData()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            //reset all filters by hitting cancel button
            currPokemons = pokemons
            currTypes = types
            searchBar.scopeButtonTitles = currTypes
            currSelectedType = "All"
            collectionView.reloadData()
            
        }
        
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            //filter even more based on original string
            currSelectedType = currTypes![selectedScope]
            if (currSelectedType == "All") {
                currPokemons = copyCurrPokemons
            } else {
                var newPokemons: [Pokemon] = []
                for i in 0..<(copyCurrPokemons!.count) {
                    let p: Pokemon = copyCurrPokemons![i]
                    for t in p.types {
                        if (t.rawValue == currSelectedType) {
                            newPokemons.append(p)
                        }
                    }
                }
                currPokemons = newPokemons
            }
            collectionView.reloadData()
        }
    }
