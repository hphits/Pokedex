//
//  pokemon.swift
//  Pokedex
//
//  Created by Hitesh Punjabi on 27.01.20.
//  Copyright © 2020 Hitesh Punjabi. All rights reserved.
//

import Foundation

struct Pokemonlist: Codable {
    let results: [Pokemon]
}


struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonData: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonSprite: Codable {
    let name: String
    let sprites: SpriteInfo
}

struct SpriteInfo: Codable {
    let front_default: String
    let front_shiny: String
}

struct PokemonSpecies: Codable{
    let flavor_text_entries: [FlavorText]
}

struct FlavorText: Codable {
    let flavor_text: String
    let language = "en"
}

//struct VersionName: Codable {
//    var name: String
//
//    enum CodingKeys: String, CodingKey  {
//        case name = "name"
//    }
//}
//
//struct English: Codable {
//    var name: String
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//    }
//}
//
//struct FlavorText: Codable {
//    var flavorText: String?
//    var language: English
//    var version: VersionName
//
//    enum Codingkeys: String, CodingKey {
//        case flavorText = "flavor_text"
//        case language = "language"
//        case version = "version"
//    }
//
//}
