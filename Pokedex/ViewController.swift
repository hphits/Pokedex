//
//  ViewController.swift
//  Pokedex
//
//  Created by Hitesh Punjabi on 27.01.20.
//  Copyright © 2020 Hitesh Punjabi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon: [Pokemon] = []
    var searchPokemon = [Pokemon] ()
    
    func capitalize (text: String) -> String{
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                
                let pokemonList = try JSONDecoder().decode(Pokemonlist.self, from: data)
            
                self.pokemon = pokemonList.results
                self.searchPokemon = self.pokemon
                
                 DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print("\(error)")
            }
            
        }.resume()
    }
    
    //method is called whenever the app is loaded

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        // Number of sections like a in contacts
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return searchPokemon.count
        // number of rows in the table
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: searchPokemon[indexPath.row].name)
        return cell
        
        // creating cells on the screen. idetifier is the idetifier from the storyboard
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue",
            let destination = segue.destination as? PokemonViewController,
            let index = tableView.indexPathForSelectedRow?.row{
            destination.url = searchPokemon[index].url
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            searchPokemon = pokemon
            tableView.reloadData()
            return
        }
        searchPokemon.removeAll()
            
        for pokemon in pokemon {
            if pokemon.name.contains(searchText.lowercased()){
                searchPokemon.append(pokemon)
                tableView.reloadData()
            }
        }
        
        tableView.reloadData()
    }
}

