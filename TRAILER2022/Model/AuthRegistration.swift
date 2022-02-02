//
//  AuthRegistration.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 29.01.22.
//

import SwiftUI
import CodeScanner

struct AuthRegistration: View {
    
    @State private var isPresentingScanner = false
    @State private var scannedCode : String = "scan a QR code"
    @StateObject var arda = Mara()
    
    var body: some View {
        VStack {
       //     Text(arda.auth)
       //         .padding()
            QRCodeView(url: arda.auth)
            Spacer()
        //    Text(scannedCode)
            
       //     Button(action: {
       //         self.isPresentingScanner = true
       //     }) {
       //         Text("Scanner")
       //             .padding()
       //     }
         //   .sheet(isPresented: $isPresentingScanner) {
         //       scannerSheet
         //   }
        }
    }
  //  var scannerSheet: some View {
  //      CodeScannerView(codeTypes: [.qr] , completion: { result in
  //          switch result {
  //          case .success(let res) :
  //              print("\(res)")
  //              self.scannedCode = res.string
  //              self.isPresentingScanner = false
  //          case .failure(let err):
  //              print("\(err)")
  //              self.isPresentingScanner = false
  //          }
  //      })
  //  }
}

struct AuthRegistration_Previews: PreviewProvider {
    static var previews: some View {
        AuthRegistration()
    }
}
