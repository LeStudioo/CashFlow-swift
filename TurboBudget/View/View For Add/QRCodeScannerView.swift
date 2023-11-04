//
//  QRCodeScannerView.swift
//  CashFlow
//
//  Created by KaayZenn on 25/07/2023.
//

import SwiftUI

struct QRCodeScannerView: View {

    //Custom type

    //Environnements
    @Environment(\.dismiss) private var dismiss

    //State or Binding String
    @Binding var jsonString: String

    //State or Binding Int, Float and Double

    //State or Binding Bool

	//Enum
	
	//Computed var

    //MARK: - Body
    var body: some View {
        ZStack {
            QRScanner(result: $jsonString)
                .foregroundColor(.black.opacity(0.5))
            
            qrCodeLimit()
                .foregroundColor(.blue)
        }
        .onChange(of: jsonString) { _ in
            dismiss()
        }
    }//END body

    //MARK: Fonctions
    
    @ViewBuilder
    func qrCodeLimit() -> some View {
        Rectangle()
            .frame(width: 200, height: 200)
            .foregroundColor(.clear)
            .overlay {
                CornerShape()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .frame(width: 200, height: 200)
            }
            .overlay {
                CornerShape()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(90))
            }
            .overlay {
                CornerShape()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(180))
            }
            .overlay {
                CornerShape()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(270))
            }
    }

}//END struct

//MARK: - Preview
struct QRCodeScannerView_Previews: PreviewProvider {
    
    @State static var jsonString: String = ""
    
    static var previews: some View {
        QRCodeScannerView(jsonString: $jsonString)
    }
}
struct Window: Shape {
    let size: CGSize
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)

        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
        path.addRect(CGRect(origin: origin, size: size))
        return path
    }
}

struct CornerShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: 60))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: 60, y: 0))


        return path
    }
}
