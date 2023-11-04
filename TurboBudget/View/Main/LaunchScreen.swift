//
//  LaunchScreen.swift
//  CashFlow
//
//  Created by Théo Sementa on 11/07/2023.
//

import SwiftUI
import Charts

struct LaunchScreen: View {
    
    //Custom type
    
    //Environnements
    @Environment(\.scenePhase) private var scenePhase
    
    //State or Binding String
    @State private var text: String = ""
    
    //State or Binding Int, Float and Double
    @State private var offsetY: CGFloat = 1000
    
    //State or Binding Bool
    @Binding var launchScreenEnd: Bool
    
    //State or Binding Date
    
    //Enum
    
    //Computed var
    
    //Other
    
    //MARK: - Body
    var body: some View {
        Image(isIPad ? "LaunchScreenIPad" : "LaunchScreen")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea([.bottom, .top])
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { withAnimation { launchScreenEnd = true } }
            }
    }//END body
    
    //MARK: Fonctions

}//END struct

//MARK: - Preview
struct LaunchScreen_Previews: PreviewProvider {
    
    @State static var previewLaunch: Bool = false
    
    static var previews: some View {
        LaunchScreen(launchScreenEnd: $previewLaunch)
    }
}
