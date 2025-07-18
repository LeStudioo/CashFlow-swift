//
//  ReleaseNoteDetailView.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import SwiftUI
import DesignSystemModule

struct ReleaseNoteDetailView: View { // TODO: Apply Design Sytem for font
    
    var releaseNote: ReleaseNoteModel
    
    // MARK: -
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: Spacing.large) {
                    VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                        Text("\("release_note_title".localized) \(releaseNote.version)")
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(releaseNote.date)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color(UIColor.lightGray))
                    }
                    .fullWidth(.leading)
                    
                    if let newFeatures = releaseNote.newFeatures, newFeatures.isEmpty == false {
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_new_features".localized)
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
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_new_features_pro".localized)
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
                        VStack(alignment: .leading, spacing: Spacing.standard) {
                            Text("release_note_bugfixes".localized)
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
                .padding(Padding.large)
            }
        }
        .toolbar {
            ToolbarDismissPushButton()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    } // body
} // struct

// MARK: - Preview
#Preview {
    ReleaseNoteDetailView(releaseNote: .version2_0_4)
}
