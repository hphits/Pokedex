//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Hitesh Punjabi on 28.01.20.
//  Copyright © 2020 Hitesh Punjabi. All rights reserved.
//

import UIKit

var pokedex = Pokedex.init(caught:[:])

class PokemonViewController: UIViewController {
    var url: String!
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var numberLabel : UILabel!
    @IBOutlet var type1label: UILabel!
    @IBOutlet var type2label: UILabel!
    @IBOutlet var Catch: UIButton!
    @IBOutlet weak var PokemonImg: UIImageView!
    @IBOutlet weak var pokeInfo: UILabel!
    
    var pokemon: Pokemon!
    var pokemondecrip: Pokemon!
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    @IBAction func toggleCatch() {
        
        if pokedex.caught[nameLabel.text!] == false || pokedex.caught[nameLabel.text!] == nil {
            Catch.setTitle("Release", for: .normal)
            pokedex.caught[nameLabel.text!] = true
            UserDefaults.standard.set(true, forKey: nameLabel.text!)
            
        }
        else {
            Catch.setTitle("Catch", for: .normal)
            pokedex.caught[nameLabel.text!] = false
            UserDefaults.standard.set(false, forKey: nameLabel.text!)
        }
    
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pokeLoad()
        loadSprite()
        nameLabel.text = ""
        numberLabel.text = ""
        pokeInfo.text = ""
        type1label.text = ""
        type2label.text = ""
    }
    
    func loadSprite() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(PokemonSprite.self, from: data)
                DispatchQueue.main.async {
                    let urlSprite = URL(string: result.sprites.front_default)
                    let pokeData = try? Data (contentsOf: urlSprite!)
                    self.PokemonImg.image = UIImage(data: pokeData!)
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
        
        
    func pokeLoad () {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                DispatchQueue.main.async {
                
                    self.nameLabel.text = self.capitalize(text: pokemonData.name)
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    //
                    let descriptionURLstring = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonData.id)"
                    guard let descriptionURL = URL(string: descriptionURLstring) else {return}
                    URLSession.shared.dataTask(with: descriptionURL) {(data, response, error) in
                      guard let data = data else {
                                      return
                        }
                        do {
                            let pokemondecrip = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                            DispatchQueue.main.async {
                                for version in pokemondecrip.flavor_text_entries{
                                    self.pokeInfo.text = version.flavor_text
                            }
                            }
                        }catch let error{
                            print("\(error)")}
                        
                    }.resume()
                    
                    
                    //
                    
                    if UserDefaults.standard.bool(forKey: self.nameLabel.text!) == true {
                        pokedex.caught[self.nameLabel.text!] = true
                              }

                    if pokedex.caught[self.nameLabel.text!] == false || pokedex.caught[self.nameLabel.text!] == nil  {
                        self.Catch.setTitle("Catch", for: .normal)
                                 }
                    else if pokedex.caught[self.nameLabel.text!] == true {
                        self.Catch.setTitle("Release", for: .normal)

                                 }
                    for typeEntry in pokemonData.types{
                        if typeEntry.slot == 1{
                            self.type1label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2{
                            self.type2label.text = typeEntry.type.name
                        }
                    }
                }
            } catch let error {
                print("\(error)")
            }
        }.resume()
    }
                       
                    
}
                    
   

