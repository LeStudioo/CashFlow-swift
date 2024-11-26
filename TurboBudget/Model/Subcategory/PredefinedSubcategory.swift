//
//  PredefinedSubcategory.swift
//  CustomPieChart
//
//  Created by KaayZenn on 11/08/2024.
//

import Foundation

//enum PredefinedSubcategory: String, CaseIterable, Identifiable {
//    
//    case PREDEFSUBCAT1CAT1, PREDEFSUBCAT2CAT1, PREDEFSUBCAT3CAT1, PREDEFSUBCAT4CAT1,
//         PREDEFSUBCAT5CAT1, PREDEFSUBCAT6CAT1, PREDEFSUBCAT7CAT1, PREDEFSUBCAT8CAT1,
//         PREDEFSUBCAT9CAT1, PREDEFSUBCAT10CAT1
//    
//    case PREDEFSUBCAT1CAT2, PREDEFSUBCAT2CAT2, PREDEFSUBCAT3CAT2, PREDEFSUBCAT4CAT2,
//         PREDEFSUBCAT5CAT2
//    
//    case PREDEFSUBCAT1CAT3, PREDEFSUBCAT2CAT3, PREDEFSUBCAT3CAT3,  PREDEFSUBCAT4CAT3,
//         PREDEFSUBCAT5CAT3
//    
//    case PREDEFSUBCAT1CAT6, PREDEFSUBCAT2CAT6, PREDEFSUBCAT3CAT6, PREDEFSUBCAT4CAT6,
//         PREDEFSUBCAT5CAT6, PREDEFSUBCAT6CAT6, PREDEFSUBCAT7CAT6
//    
//    case PREDEFSUBCAT1CAT7, PREDEFSUBCAT2CAT7, PREDEFSUBCAT3CAT7, PREDEFSUBCAT4CAT7,
//         PREDEFSUBCAT5CAT7, PREDEFSUBCAT6CAT7, PREDEFSUBCAT7CAT7, PREDEFSUBCAT8CAT7,
//         PREDEFSUBCAT9CAT7
//    
//    case PREDEFSUBCAT1CAT8, PREDEFSUBCAT2CAT8, PREDEFSUBCAT3CAT8, PREDEFSUBCAT4CAT8,
//         PREDEFSUBCAT5CAT8, PREDEFSUBCAT6CAT8, PREDEFSUBCAT7CAT8
//    
//    case PREDEFSUBCAT1CAT10, PREDEFSUBCAT2CAT10, PREDEFSUBCAT3CAT10, PREDEFSUBCAT4CAT10,
//         PREDEFSUBCAT5CAT10
//    
//    case PREDEFSUBCAT1CAT11, PREDEFSUBCAT2CAT11, PREDEFSUBCAT3CAT11, PREDEFSUBCAT4CAT11,
//         PREDEFSUBCAT5CAT11, PREDEFSUBCAT6CAT11, PREDEFSUBCAT7CAT11, PREDEFSUBCAT8CAT11,
//         PREDEFSUBCAT9CAT11, PREDEFSUBCAT10CAT11, PREDEFSUBCAT11CAT11
//
//    case PREDEFSUBCAT1CAT12, PREDEFSUBCAT2CAT12, PREDEFSUBCAT3CAT12, PREDEFSUBCAT4CAT12,
//         PREDEFSUBCAT5CAT12
//}

//extension PredefinedSubcategory {
//    
//    var id: String { return self.rawValue }
//    
//    var title: String {
//        switch self {
//        case .PREDEFSUBCAT1CAT1: return "category1_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT1: return "category1_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT1: return "category1_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT1: return "category1_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT1: return "category1_subcategory5_name".localized
//        case .PREDEFSUBCAT6CAT1: return "category1_subcategory6_name".localized
//        case .PREDEFSUBCAT7CAT1: return "category1_subcategory7_name".localized
//        case .PREDEFSUBCAT8CAT1: return "category1_subcategory8_name".localized
//        case .PREDEFSUBCAT9CAT1: return "category1_subcategory9_name".localized
//        case .PREDEFSUBCAT10CAT1: return "category1_subcategory10_name".localized
//            
//        case .PREDEFSUBCAT1CAT2: return "category2_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT2: return "category2_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT2: return "category2_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT2: return "category2_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT2: return "category2_subcategory5_name".localized
//            
//        case .PREDEFSUBCAT1CAT3: return "category3_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT3: return "category3_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT3: return "category3_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT3: return "category3_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT3: return "category3_subcategory5_name".localized
//            
//        case .PREDEFSUBCAT1CAT6: return "category6_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT6: return "category6_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT6: return "category6_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT6: return "category6_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT6: return "category6_subcategory5_name".localized
//        case .PREDEFSUBCAT6CAT6: return "category6_subcategory6_name".localized
//        case .PREDEFSUBCAT7CAT6: return "category6_subcategory7_name".localized
//            
//        case .PREDEFSUBCAT1CAT7: return "category7_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT7: return "category7_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT7: return "category7_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT7: return "category7_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT7: return "category7_subcategory5_name".localized
//        case .PREDEFSUBCAT6CAT7: return "category7_subcategory6_name".localized
//        case .PREDEFSUBCAT7CAT7: return "category7_subcategory7_name".localized
//        case .PREDEFSUBCAT8CAT7: return "category7_subcategory8_name".localized
//        case .PREDEFSUBCAT9CAT7: return "category7_subcategory9_name".localized
//            
//        case .PREDEFSUBCAT1CAT8: return "category8_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT8: return "category8_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT8: return "category8_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT8: return "category8_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT8: return "category8_subcategory5_name".localized
//        case .PREDEFSUBCAT6CAT8: return "category8_subcategory6_name".localized
//        case .PREDEFSUBCAT7CAT8: return "category8_subcategory7_name".localized
//            
//        case .PREDEFSUBCAT1CAT10: return "category10_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT10: return "category10_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT10: return "category10_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT10: return "category10_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT10: return "category10_subcategory5_name".localized
//            
//        case .PREDEFSUBCAT1CAT11: return "category11_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT11: return "category11_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT11: return "category11_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT11: return "category11_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT11: return "category11_subcategory5_name".localized
//        case .PREDEFSUBCAT6CAT11: return "category11_subcategory6_name".localized
//        case .PREDEFSUBCAT7CAT11: return "category11_subcategory7_name".localized
//        case .PREDEFSUBCAT8CAT11: return "category11_subcategory8_name".localized
//        case .PREDEFSUBCAT9CAT11: return "category11_subcategory9_name".localized
//        case .PREDEFSUBCAT10CAT11: return "category11_subcategory10_name".localized
//        case .PREDEFSUBCAT11CAT11: return "category11_subcategory11_name".localized
//            
//        case .PREDEFSUBCAT1CAT12: return "category12_subcategory1_name".localized
//        case .PREDEFSUBCAT2CAT12: return "category12_subcategory2_name".localized
//        case .PREDEFSUBCAT3CAT12: return "category12_subcategory3_name".localized
//        case .PREDEFSUBCAT4CAT12: return "category12_subcategory4_name".localized
//        case .PREDEFSUBCAT5CAT12: return "category12_subcategory5_name".localized
//        }
//    }
//    
//    var icon: String {
//        switch self {
//        case .PREDEFSUBCAT1CAT1: return "dumbbell.fill"
//        case .PREDEFSUBCAT2CAT1: return "gift.fill"
//        case .PREDEFSUBCAT3CAT1: return "hands.sparkles.fill"
//        case .PREDEFSUBCAT4CAT1: return "iphone.gen2"
//        case .PREDEFSUBCAT5CAT1: return "book.fill"
//        case .PREDEFSUBCAT6CAT1: return "sofa.fill"
//        case .PREDEFSUBCAT7CAT1: return "building.columns.fill"
//        case .PREDEFSUBCAT8CAT1: return "newspaper.fill"
//        case .PREDEFSUBCAT9CAT1: return "tshirt.fill"
//        case .PREDEFSUBCAT10CAT1: return "cart.fill"
//            
//        case .PREDEFSUBCAT1CAT2: return "tree.fill"
//        case .PREDEFSUBCAT2CAT2: return "fork.knife"
//        case .PREDEFSUBCAT3CAT2: return "cart.fill"
//        case .PREDEFSUBCAT4CAT2: return "wineglass.fill"
//        case .PREDEFSUBCAT5CAT2: return "cup.and.saucer.fill"
//            
//        case .PREDEFSUBCAT1CAT3: return "soccerball"
//        case .PREDEFSUBCAT2CAT3: return "waveform.path.ecg"
//        case .PREDEFSUBCAT3CAT3: return "fork.knife"
//        case .PREDEFSUBCAT4CAT3: return "pills.fill"
//        case .PREDEFSUBCAT5CAT3: return "pawprint.fill"
//            
//        case .PREDEFSUBCAT1CAT6: return "icons8-plaque-de-policier-96"
//        case .PREDEFSUBCAT2CAT6: return "puzzlepiece.fill"
//        case .PREDEFSUBCAT3CAT6: return "puzzlepiece.fill"
//        case .PREDEFSUBCAT4CAT6: return "building.2.fill"
//        case .PREDEFSUBCAT5CAT6: return "icons8-bribery-96"
//        case .PREDEFSUBCAT6CAT6: return "icons8-banque-96"
//        case .PREDEFSUBCAT7CAT6: return "chart.line.downtrend.xyaxis"
//            
//        case .PREDEFSUBCAT1CAT7: return "umbrella.fill"
//        case .PREDEFSUBCAT2CAT7: return "lamp.floor.fill"
//        case .PREDEFSUBCAT3CAT7: return "bolt.fill"
//        case .PREDEFSUBCAT4CAT7: return "phone.fill"
//        case .PREDEFSUBCAT5CAT7: return "house.fill"
//        case .PREDEFSUBCAT6CAT7: return "building.columns.fill"
//        case .PREDEFSUBCAT7CAT7: return "house.lodge.fill"
//        case .PREDEFSUBCAT8CAT7: return "paintbrush.fill"
//        case .PREDEFSUBCAT9CAT7: return "house.fill"
//            
//        case .PREDEFSUBCAT1CAT8: return "play.fill"
//        case .PREDEFSUBCAT2CAT8: return "wineglass.fill"
//        case .PREDEFSUBCAT3CAT8: return "scissors"
//        case .PREDEFSUBCAT4CAT8: return "popcorn.fill"
//        case .PREDEFSUBCAT5CAT8: return "dumbbell.fill"
//        case .PREDEFSUBCAT6CAT8: return "airplane.departure"
//        case .PREDEFSUBCAT7CAT8: return "sun.max"
//            
//        case .PREDEFSUBCAT1CAT10: return "heart.fill"
//        case .PREDEFSUBCAT2CAT10: return "waveform.path.ecg"
//        case .PREDEFSUBCAT3CAT10: return "eyeglasses"
//        case .PREDEFSUBCAT4CAT10: return "pills.fill"
//        case .PREDEFSUBCAT5CAT10: return "cross"
//            
//        case .PREDEFSUBCAT1CAT11: return "umbrella.fill"
//        case .PREDEFSUBCAT2CAT11: return "sailboat.fill"
//        case .PREDEFSUBCAT3CAT11: return "fuelpump.fill"
//        case .PREDEFSUBCAT4CAT11: return "wrench.and.screwdriver.fill"
//        case .PREDEFSUBCAT5CAT11: return "key.fill"
//        case .PREDEFSUBCAT6CAT11: return "road.lanes"
//        case .PREDEFSUBCAT7CAT11: return "building.columns.fill"
//        case .PREDEFSUBCAT8CAT11: return "parkingsign"
//        case .PREDEFSUBCAT9CAT11: return "car.front.waves.up"
//        case .PREDEFSUBCAT10CAT11: return "bus.fill"
//        case .PREDEFSUBCAT11CAT11: return "car.side.fill"
//            
//        case .PREDEFSUBCAT1CAT12: return "creditcard.fill"
//        case .PREDEFSUBCAT2CAT12: return "icons8-facture-96"
//        case .PREDEFSUBCAT3CAT12: return "building.columns.fill"
//        case .PREDEFSUBCAT4CAT12: return "fork.knife"
//        case .PREDEFSUBCAT5CAT12: return "building.2.fill"
//        }
//    }
//    
//    var category: PredefinedCategory {
//        switch self {
//        case .PREDEFSUBCAT1CAT1, .PREDEFSUBCAT2CAT1, .PREDEFSUBCAT3CAT1, .PREDEFSUBCAT4CAT1,
//                .PREDEFSUBCAT5CAT1, .PREDEFSUBCAT6CAT1, .PREDEFSUBCAT7CAT1, .PREDEFSUBCAT8CAT1,
//                .PREDEFSUBCAT9CAT1, .PREDEFSUBCAT10CAT1:
//            return .PREDEFCAT1
//        case .PREDEFSUBCAT1CAT2, .PREDEFSUBCAT2CAT2, .PREDEFSUBCAT3CAT2, .PREDEFSUBCAT4CAT2,
//                .PREDEFSUBCAT5CAT2:
//            return .PREDEFCAT2
//        case .PREDEFSUBCAT1CAT3, .PREDEFSUBCAT2CAT3, .PREDEFSUBCAT3CAT3, .PREDEFSUBCAT4CAT3,
//                .PREDEFSUBCAT5CAT3:
//            return .PREDEFCAT3
//        case .PREDEFSUBCAT1CAT6, .PREDEFSUBCAT2CAT6, .PREDEFSUBCAT3CAT6, .PREDEFSUBCAT4CAT6,
//                .PREDEFSUBCAT5CAT6, .PREDEFSUBCAT6CAT6, .PREDEFSUBCAT7CAT6:
//            return .PREDEFCAT6
//        case .PREDEFSUBCAT1CAT7, .PREDEFSUBCAT2CAT7, .PREDEFSUBCAT3CAT7, .PREDEFSUBCAT4CAT7,
//                .PREDEFSUBCAT5CAT7, .PREDEFSUBCAT6CAT7, .PREDEFSUBCAT7CAT7, .PREDEFSUBCAT8CAT7,
//                .PREDEFSUBCAT9CAT7:
//            return .PREDEFCAT7
//        case .PREDEFSUBCAT1CAT8, .PREDEFSUBCAT2CAT8, .PREDEFSUBCAT3CAT8, .PREDEFSUBCAT4CAT8,
//                .PREDEFSUBCAT5CAT8, .PREDEFSUBCAT6CAT8, .PREDEFSUBCAT7CAT8:
//            return .PREDEFCAT8
//        case .PREDEFSUBCAT1CAT10, .PREDEFSUBCAT2CAT10, .PREDEFSUBCAT3CAT10, .PREDEFSUBCAT4CAT10,
//                .PREDEFSUBCAT5CAT10:
//            return .PREDEFCAT10
//        case .PREDEFSUBCAT1CAT11, .PREDEFSUBCAT2CAT11, .PREDEFSUBCAT3CAT11, .PREDEFSUBCAT4CAT11,
//                .PREDEFSUBCAT5CAT11, .PREDEFSUBCAT6CAT11, .PREDEFSUBCAT7CAT11, .PREDEFSUBCAT8CAT11,
//                .PREDEFSUBCAT9CAT11, .PREDEFSUBCAT10CAT11, .PREDEFSUBCAT11CAT11:
//            return .PREDEFCAT11
//        case .PREDEFSUBCAT1CAT12, .PREDEFSUBCAT2CAT12, .PREDEFSUBCAT3CAT12, .PREDEFSUBCAT4CAT12,
//                .PREDEFSUBCAT5CAT12:
//            return .PREDEFCAT12
//        }
//    }
//    
//    var transactions: [TransactionModel] {
//        return []
////        return TransactionRepository.shared.transactionsBySubcategory(self.rawValue)
//    }
//    
//    /// Transactions of type expense in a Subategory
//    var expenses: [TransactionModel] {
//        return transactions.filter { $0.type == .expense }
//    }
//    
//    /// Transactions of type income in a Subategory
//    var incomes: [TransactionModel] {
//        return transactions.filter { $0.type == .income }
//    }
//    
//    /// Transactions from Subscription in a Subategory
//    var subscriptions: [TransactionModel] {
//        return transactions.filter { $0.isFromSubscription == true }
//    }
//    
////    var currentMonthTransactions: [TransactionModel] {
////        let calendar = Calendar.current
////        let now = Date()
////        
////        return transactions.filter { transaction in
////            let transactionMonth = calendar.dateComponents([.month, .year], from: transaction.date.withDefault)
////            let currentMonth = calendar.dateComponents([.month, .year], from: now)
////            return transactionMonth == currentMonth && transaction.subcategoryID == self.id
////        }
////    }
//    
//    var transactionsFiltered: [TransactionModel] {
//        return self.transactions
//            .filter { Calendar.current.isDate($0.date.withDefault, equalTo: FilterManager.shared.date, toGranularity: .month) }
//    }
//    
//    var budget: Budget? {
//        return BudgetRepositoryOld.shared.findBySubcategoryID(self.id)
//    }
//}
