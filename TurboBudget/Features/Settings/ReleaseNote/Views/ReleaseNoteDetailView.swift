//
//  ReleaseNoteDetailView.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import SwiftUI

struct ReleaseNoteDetailView: View { // TODO: Apply Design Sytem for font
    
    var releaseNote: ReleaseNoteModel
    
    // MARK: -
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraSmall) {
                        Text("Note de mise à jour - \(releaseNote.version)")
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(releaseNote.date)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color(UIColor.lightGray))
                    }
                    .fullWidth(.leading)
                    
                    if let newFeatures = releaseNote.newFeatures, newFeatures.isEmpty == false {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
                            Text("Nouvelles fonctionnalités")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(newFeatures, id: \.self) { feature in
                                Text("- \(feature)")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                    }
                    
                    if let newFeaturesPro = releaseNote.newFeaturesPro, newFeaturesPro.isEmpty == false {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
                            Text("Nouvelles fonctionnalités premium")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(newFeaturesPro, id: \.self) { feature in
                                Text("- \(feature)")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                    }
                    
                    if let bugfixes = releaseNote.bugfixes, bugfixes.isEmpty == false {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.standard) {
                            Text("Résolution de bugs")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color.primary500)
                                .fullWidth(.leading)
                            
                            ForEach(bugfixes, id: \.self) { bug in
                                Text("- \(bug)")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                    }
                }
                .padding(DesignSystem.Padding.large)
            }
        }
        .toolbar {
            ToolbarDismissPushButton()
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    ReleaseNoteDetailView(releaseNote: .version2_0_4)
}
