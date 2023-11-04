//
//  Predefined Object.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//

import Foundation
import SwiftUI
import CoreData

// MARK: - All Category


//MARK: 00. A Categoriser

var categoryPredefined00 = PredefinedCategory(
    idUnique: "PREDEFCAT00",
    title: NSLocalizedString("category00_name", comment: ""),
    icon: "questionmark",
    color: Color.gray.lighter(by: 4),
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//MARK: 0. Income

var categoryPredefined0 = PredefinedCategory(
    idUnique: "PREDEFCAT0",
    title: NSLocalizedString("word_incomes", comment: ""),
    icon: "tray.and.arrow.down",
    color: Color.green,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//MARK: 1. Achats & Shopping

var categoryPredefined1 = PredefinedCategory(
    idUnique: "PREDEFCAT1",
    title: NSLocalizedString("category1_name", comment: ""),
    icon: "cart.fill",
    color: Color.red,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Articles de sport
var subCategory1Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT1",
    title: NSLocalizedString("category1_subcategory1_name", comment: ""),
    icon: "dumbbell.fill",
    category: categoryPredefined1,
    transactions: []
)

//2. Cadeaux
var subCategory2Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT1",
    title: NSLocalizedString("category1_subcategory2_name", comment: ""),
    icon: "gift.fill",
    category: categoryPredefined1,
    transactions: []
)

//3. Dons
var subCategory3Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT1",
    title: NSLocalizedString("category1_subcategory3_name", comment: ""),
    icon: "hands.sparkles.fill",
    category: categoryPredefined1,
    transactions: []
)

//4. High Tech, Jeux vidéos
var subCategory4Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT1",
    title: NSLocalizedString("category1_subcategory4_name", comment: ""),
    icon: "iphone.gen2",
    category: categoryPredefined1,
    transactions: []
)

//5. Livres, Musique
var subCategory5Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT1",
    title: NSLocalizedString("category1_subcategory5_name", comment: ""),
    icon: "book.fill",
    category: categoryPredefined1,
    transactions: []
)

//6. Mobilier décoration
var subCategory6Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT6CAT1",
    title: NSLocalizedString("category1_subcategory6_name", comment: ""),
    icon: "sofa.fill",
    category: categoryPredefined1,
    transactions: []
)

//7. Prêt consommation
var subCategory7Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT7CAT1",
    title: NSLocalizedString("category1_subcategory7_name", comment: ""),
    icon: "building.columns.fill",
    category: categoryPredefined1,
    transactions: []
)

//8. Tabac, Presse
var subCategory8Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT8CAT1",
    title: NSLocalizedString("category1_subcategory8_name", comment: ""),
    icon: "newspaper.fill",
    category: categoryPredefined1,
    transactions: []
)

//9. Vêtements, Chaussures, Accessoires
var subCategory9Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT9CAT1",
    title: NSLocalizedString("category1_subcategory9_name", comment: ""),
    icon: "tshirt.fill",
    category: categoryPredefined1,
    transactions: []
)

//10. Achats & Shopping - Autres
var subCategory10Category1 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT10CAT1",
    title: NSLocalizedString("category1_subcategory10_name", comment: ""),
    icon: "cart.fill",
    category: categoryPredefined1,
    transactions: []
)

//MARK: 2. Alimentation & Restaurants

var categoryPredefined2 = PredefinedCategory(
    idUnique: "PREDEFCAT2",
    title: NSLocalizedString("category2_name", comment: ""),
    icon: "fork.knife",
    color: Color.orange,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Marché
var subCategory1Category2 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT2",
    title: NSLocalizedString("category2_subcategory1_name", comment: ""),
    icon: "tree.fill",
    category: categoryPredefined2,
    transactions: []
)

//2. Restaurants, Snacks
var subCategory2Category2 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT2",
    title: NSLocalizedString("category2_subcategory2_name", comment: ""),
    icon: "fork.knife",
    category: categoryPredefined2,
    transactions: []
)

//3. Supermarché, Épicerie
var subCategory3Category2 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT2",
    title: NSLocalizedString("category2_subcategory3_name", comment: ""),
    icon: "cart.fill",
    category: categoryPredefined2,
    transactions: []
)

//4. Vins et spiritueux
var subCategory4Category2 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT2",
    title: NSLocalizedString("category2_subcategory4_name", comment: ""),
    icon: "wineglass.fill",
    category: categoryPredefined2,
    transactions: []
)

//5. Alimentation & Restaurants - Autres
var subCategory5Category2 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT2",
    title: NSLocalizedString("category2_subcategory5_name", comment: ""),
    icon: "cup.and.saucer.fill",
    category: categoryPredefined2,
    transactions: []
)

//MARK: 3. Animaux

var categoryPredefined3 = PredefinedCategory(
    idUnique: "PREDEFCAT3",
    title: NSLocalizedString("category3_name", comment: ""),
    icon: "pawprint.fill",
    color: Color.yellow,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Jouets
var subCategory1Category3 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT3",
    title: NSLocalizedString("category3_subcategory1_name", comment: ""),
    icon: "soccerball",
    category: categoryPredefined3,
    transactions: []
)

//2. Mutuelle
var subCategory2Category3 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT3",
    title: NSLocalizedString("category3_subcategory2_name", comment: ""),
    icon: "waveform.path.ecg",
    category: categoryPredefined3,
    transactions: []
)

//3. Nourriture
var subCategory3Category3 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT3",
    title: NSLocalizedString("category3_subcategory3_name", comment: ""),
    icon: "fork.knife",
    category: categoryPredefined3,
    transactions: []
)

//4. Santé, Soins
var subCategory4Category3 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT3",
    title: NSLocalizedString("category3_subcategory4_name", comment: ""),
    icon: "pills.fill",
    category: categoryPredefined3,
    transactions: []
)

//5. Animaux - Autres
var subCategory5Category3 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT3",
    title: NSLocalizedString("category3_subcategory5_name", comment: ""),
    icon: "pawprint.fill",
    category: categoryPredefined3,
    transactions: []
)

//MARK: 4. Crédits

var categoryPredefined4 = PredefinedCategory(
    idUnique: "PREDEFCAT4",
    title: NSLocalizedString("category4_name", comment: ""),
    icon: "creditcard.fill",
    color: Color.green,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//MARK: 5. Épargne & Placements

var categoryPredefined5 = PredefinedCategory(
    idUnique: "PREDEFCAT5",
    title: NSLocalizedString("category5_name", comment: ""),
    icon: "chart.bar.fill",
    color: Color.mint,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//MARK: 6. Impôts, Taxes & Frais

var categoryPredefined6 = PredefinedCategory(
    idUnique: "PREDEFCAT6",
    title: NSLocalizedString("category6_name", comment: ""),
    icon: "chart.line.downtrend.xyaxis",
    color: Color.teal,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Amendes
var subCategory1Category6 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT6",
    title: NSLocalizedString("category6_subcategory1_name", comment: ""),
    icon: "icons8-plaque-de-policier-96",
    category: categoryPredefined6,
    transactions: []
)

//2. Contributions sociales
var subCategory2Category6 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT6",
    title: NSLocalizedString("category6_subcategory2_name", comment: ""),
    icon: "puzzlepiece.fill",
    category: categoryPredefined6,
    transactions: []
)

//3. Frais bancaires
var subCategory3Category6 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT6",
    title: NSLocalizedString("category6_subcategory3_name", comment: ""),
    icon: "puzzlepiece.fill",
    category: categoryPredefined6,
    transactions: []
)

//4. Impôts sur la fortune
var subCategory4Category6 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT6",
    title: NSLocalizedString("category6_subcategory4_name", comment: ""),
    icon: "building.2.fill",
    category: categoryPredefined6,
    transactions: []
)

//5. Impôts sur le revenue
var subCategory5Category6 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT6",
    title: NSLocalizedString("category6_subcategory5_name", comment: ""),
    icon: "icons8-bribery-96",
    category: categoryPredefined6,
    transactions: []
)

//6. Taxes foncières
var subCategory6Category6 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT6CAT6",
    title: NSLocalizedString("category6_subcategory6_name", comment: ""),
    icon: "icons8-banque-96",
    category: categoryPredefined6,
    transactions: []
)

//7. Impôts, Taxes & Frais - Autres
var subCategory7Category6 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT7CAT6",
    title: NSLocalizedString("category6_subcategory7_name", comment: ""),
    icon: "chart.line.downtrend.xyaxis",
    category: categoryPredefined6,
    transactions: []
)

//MARK: 7. Logement & Charges

var categoryPredefined7 = PredefinedCategory(
    idUnique: "PREDEFCAT7",
    title: NSLocalizedString("category7_name", comment: ""),
    icon: "house.fill",
    color: Color.cyan,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Assurance logement
var subCategory1Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT7",
    title: NSLocalizedString("category7_subcategory1_name", comment: ""),
    icon: "umbrella.fill",
    category: categoryPredefined7,
    transactions: []
)

//2. Charges logement, Accessoires
var subCategory2Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT7",
    title: NSLocalizedString("category7_subcategory2_name", comment: ""),
    icon: "lamp.floor.fill",
    category: categoryPredefined7,
    transactions: []
)

//3. Eau, Électricité, Gaz
var subCategory3Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT7",
    title: NSLocalizedString("category7_subcategory3_name", comment: ""),
    icon: "bolt.fill",
    category: categoryPredefined7,
    transactions: []
)

//4. Internet, Téléphonie
var subCategory4Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT7",
    title: NSLocalizedString("category7_subcategory4_name", comment: ""),
    icon: "phone.fill",
    category: categoryPredefined7,
    transactions: []
)

//5. Loyer
var subCategory5Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT7",
    title: NSLocalizedString("category7_subcategory5_name", comment: ""),
    icon: "house.fill",
    category: categoryPredefined7,
    transactions: []
)

//6. Prêt immobilier
var subCategory6Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT6CAT7",
    title: NSLocalizedString("category7_subcategory6_name", comment: ""),
    icon: "building.columns.fill",
    category: categoryPredefined7,
    transactions: []
)

//7. Résidence secondaire
var subCategory7Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT7CAT7",
    title: NSLocalizedString("category7_subcategory7_name", comment: ""),
    icon: "house.lodge.fill",
    category: categoryPredefined7,
    transactions: []
)

//8. Travaux, Entretien
var subCategory8Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT8CAT7",
    title: NSLocalizedString("category7_subcategory8_name", comment: ""),
    icon: "paintbrush.fill",
    category: categoryPredefined7,
    transactions: []
)

//9. Logement & Charges - Autres
var subCategory9Category7 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT9CAT7",
    title: NSLocalizedString("category7_subcategory9_name", comment: ""),
    icon: "house.fill",
    category: categoryPredefined7,
    transactions: []
)

//MARK: 8. Loisirs & vacances

var categoryPredefined8 = PredefinedCategory(
    idUnique: "PREDEFCAT8",
    title: NSLocalizedString("category8_name", comment: ""),
    icon: "sun.max",
    color: Color.blue,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Abonnements multimédia
var subCategory1Category8 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT8",
    title: NSLocalizedString("category8_subcategory1_name", comment: ""),
    icon: "play.fill",
    category: categoryPredefined8,
    transactions: []
)

//2. Bars et clubs
var subCategory2Category8 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT8",
    title: NSLocalizedString("category8_subcategory2_name", comment: ""),
    icon: "wineglass.fill",
    category: categoryPredefined8,
    transactions: []
)

//3. Coiffeur, Esthétique
var subCategory3Category8 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT8",
    title: NSLocalizedString("category8_subcategory3_name", comment: ""),
    icon: "scissors",
    category: categoryPredefined8,
    transactions: []
)

//4. Sorties culturelles
var subCategory4Category8 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT8",
    title: NSLocalizedString("category8_subcategory4_name", comment: ""),
    icon: "popcorn.fill",
    category: categoryPredefined8,
    transactions: []
)

//5. Sport
var subCategory5Category8 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT8",
    title: NSLocalizedString("category8_subcategory5_name", comment: ""),
    icon: "dumbbell.fill",
    category: categoryPredefined8,
    transactions: []
)

//6. Vacances, Voyages
var subCategory6Category8 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT6CAT8",
    title: NSLocalizedString("category8_subcategory6_name", comment: ""),
    icon: "airplane.departure",
    category: categoryPredefined8,
    transactions: []
)

//7. Loisirs & vacances - Autres
var subCategory7Category8 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT7CAT8",
    title: NSLocalizedString("category8_subcategory7_name", comment: ""),
    icon: "sun.max",
    category: categoryPredefined8,
    transactions: []
)

//MARK: 9. Retraits

var categoryPredefined9 = PredefinedCategory(
    idUnique: "PREDEFCAT9",
    title: NSLocalizedString("category9_name", comment: ""),
    icon: "creditcard.and.123",
    color: Color.indigo,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//MARK: 10. Santé

var categoryPredefined10 = PredefinedCategory(
    idUnique: "PREDEFCAT10",
    title: NSLocalizedString("category10_name", comment: ""),
    icon: "cross",
    color: Color.purple,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Médecin
var subCategory1Category10 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT10",
    title: NSLocalizedString("category10_subcategory1_name", comment: ""),
    icon: "heart.fill",
    category: categoryPredefined10,
    transactions: []
)

//2. Mutuelle
var subCategory2Category10 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT10",
    title: NSLocalizedString("category10_subcategory2_name", comment: ""),
    icon: "waveform.path.ecg",
    category: categoryPredefined10,
    transactions: []
)

//3. Opique
var subCategory3Category10 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT10",
    title: NSLocalizedString("category10_subcategory3_name", comment: ""),
    icon: "eyeglasses",
    category: categoryPredefined10,
    transactions: []
)

//4. Pharmacie
var subCategory4Category10 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT10",
    title: NSLocalizedString("category10_subcategory4_name", comment: ""),
    icon: "pills.fill",
    category: categoryPredefined10,
    transactions: []
)

//5. Santé - Autres
var subCategory5Category10 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT10",
    title: NSLocalizedString("category10_subcategory5_name", comment: ""),
    icon: "cross",
    category: categoryPredefined10,
    transactions: []
)

//MARK: 11. Transport

var categoryPredefined11 = PredefinedCategory(
    idUnique: "PREDEF11",
    title: NSLocalizedString("category11_name", comment: ""),
    icon: "car.side.fill",
    color: Color.pink,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Assurance véhicule
var subCategory1Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT11",
    title: NSLocalizedString("category11_subcategory1_name", comment: ""),
    icon: "umbrella.fill",
    category: categoryPredefined11,
    transactions: []
)

//2. Avion, Train, Bateau
var subCategory2Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT11",
    title: NSLocalizedString("category11_subcategory2_name", comment: ""),
    icon: "sailboat.fill",
    category: categoryPredefined11,
    transactions: []
)

//3. Carburant
var subCategory3Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT11",
    title: NSLocalizedString("category11_subcategory3_name", comment: ""),
    icon: "fuelpump.fill",
    category: categoryPredefined11,
    transactions: []
)

//4. Entretien, Équipement véhicule
var subCategory4Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT11",
    title: NSLocalizedString("category11_subcategory4_name", comment: ""),
    icon: "wrench.and.screwdriver.fill",
    category: categoryPredefined11,
    transactions: []
)

//5. Location véhicule
var subCategory5Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT11",
    title: NSLocalizedString("category11_subcategory5_name", comment: ""),
    icon: "key.fill",
    category: categoryPredefined11,
    transactions: []
)

//6. Péage
var subCategory6Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT6CAT11",
    title: NSLocalizedString("category11_subcategory6_name", comment: ""),
    icon: "road.lanes",
    category: categoryPredefined11,
    transactions: []
)

//7. Prêt véhicule
var subCategory7Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT7CAT11",
    title: NSLocalizedString("category11_subcategory7_name", comment: ""),
    icon: "building.columns.fill",
    category: categoryPredefined11,
    transactions: []
)

//8. Stationnement
var subCategory8Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT8CAT11",
    title: NSLocalizedString("category11_subcategory8_name", comment: ""),
    icon: "parkingsign",
    category: categoryPredefined11,
    transactions: []
)

//9. Taxi, VTC
var subCategory9Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT9CAT11",
    title: NSLocalizedString("category11_subcategory9_name", comment: ""),
    icon: "car.front.waves.up",
    category: categoryPredefined11,
    transactions: []
)

//10. Transport en commun
var subCategory10Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT10CAT11",
    title: NSLocalizedString("category11_subcategory10_name", comment: ""),
    icon: "bus.fill",
    category: categoryPredefined11,
    transactions: []
)

//11. Transport - Autres
var subCategory11Category11 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT11CAT11",
    title: NSLocalizedString("category11_subcategory11_name", comment: ""),
    icon: "car.side.fill",
    category: categoryPredefined11,
    transactions: []
)

//MARK: 12. Travail & Études

var categoryPredefined12 = PredefinedCategory(
    idUnique: "PREDEF12",
    title: NSLocalizedString("category12_name", comment: ""),
    icon: "building.2.fill",
    color: Color.brown,
    subcategories: [],
    transactions: [],
    transactionsArchived: []
)

//1. Dépenses professionnelles
var subCategory1Category12 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT1CAT12",
    title: NSLocalizedString("category12_subcategory1_name", comment: ""),
    icon: "creditcard.fill",
    category: categoryPredefined12,
    transactions: []
)

//2. Notes de frais
var subCategory2Category12 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT2CAT12",
    title: NSLocalizedString("category12_subcategory2_name", comment: ""),
    icon: "icons8-facture-96",
    category: categoryPredefined12,
    transactions: []
)

//3. Prêt étudiant
var subCategory3Category12 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT3CAT12",
    title: NSLocalizedString("category12_subcategory3_name", comment: ""),
    icon: "building.columns.fill",
    category: categoryPredefined12,
    transactions: []
)

//4. Repas au travail
var subCategory4Category12 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT4CAT12",
    title: NSLocalizedString("category12_subcategory4_name", comment: ""),
    icon: "fork.knife",
    category: categoryPredefined12,
    transactions: []
)


//5. Travail & Études - Autres
var subCategory5Category12 = PredefinedSubcategory(
    idUnique: "PREDEFSUBCAT5CAT12",
    title: NSLocalizedString("category12_subcategory5_name", comment: ""),
    icon: "building.2.fill",
    category: categoryPredefined12,
    transactions: []
)

//1. Achats & Shopping
    //1. Articles de sport
    //2. Cadeaux
    //3. Dons
    //4. High Tech, Jeux vidéos
    //5. Livres, Musique
    //6. Mobilier décoation
    //7. Prêt consommation
    //8. Tabac, Presse
    //9. Vêtements, Chaussures, Accessoires
    //10. Achats & Shopping - Autres

//2. Alimentation & Restaurants
    //1. Marché
    //2. Restaurants, Snacks
    //3. Supermarché, Épicerie
    //4. Vins et spiritueux
    //5. Alimentation & Restaurants - Autres

//3. Animaux
    //1. Jouets
    //2. Mutuelle
    //3. Nourriture
    //4. Santé, Soins
    //5. Animaux - Autres

//4. Crédits

//5. Épargne & Placements

//6. Impôts, taxes & frais
    //1. Amendes
    //2. Contributions sociales
    //3. Frais bancaires
    //4. Impôts sur la fortune
    //5. Impôts sur le revenur
    //6. Taxes foncières
    //7. Impôts, Taxes & Frais - Autres

//7. Logement & Charges
    //1. Assurance logement
    //2. Charges logement, Accessoires
    //3. Eau, Électricité, Gaz
    //4. Internet, Téléphonie
    //5. Loyer
    //6. Prêt immobilier
    //7. Résidence secondaire
    //8. Travaux, Entretien
    //9. Logement & Charges - Autres

//8. Loisirs & vacances
    //1. Abonnements multimédia
    //2. Bars et clubs
    //3. Coiffeur, Esthétique
    //4. Sorties culturelles
    //5. Sport
    //6. Vacances, Voyages
    //7. Loisirs & vacances - Autres

//9. Retraits

//10. Santé
    //1. Médecin
    //2. Mutuelle
    //3. Opique
    //4. Pharmacie
    //5. Santé - Autres

//11. Transport
    //1. Assurance véhicule
    //2. Avion, Train, Bateau
    //3. Carburant
    //4. Entretien, Équipement véhicule
    //5. Location véhicule
    //6. Péage
    //7. Prêt véhicule
    //8. Stationnement
    //9. Taxi, VTC
    //10. Transport en commun
    //11. Transport - Autres

//12. Travail & Études
    //1. Dépenses professionnelles
    //2. Notes de frais
    //3. Prêt étudiant
    //4. Repas au travail
    //5. Travail & Études - Autres
