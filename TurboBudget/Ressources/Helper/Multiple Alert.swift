//
//  Multiple Alert.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import Foundation

struct MultipleAlert: Identifiable {

    enum AlertType {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
    }
    
    let id: AlertType
    let title: String
    let message: String
    let action: () -> Void
}

//MARK: Example

//@State private var info: MultipleAlert?

//    .alert(item: $info, content: { info in
//        Alert(title: Text(info.title),
//              message: Text(info.message),
//              dismissButton: .cancel(Text("OK")) { return })
//    })
