//
//  WarkView.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 30.01.22.
//

import SwiftUI

struct WarkView: View {
    @StateObject var arda = Mara()
    @State private var isTre     : Bool = false
    @State private var isInfo    : Bool = false
    @State private var isService : Bool = false
    @State private var isSelding : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack ( alignment: .center , spacing: 50){

                QRCodeView(url: arda.auth)
                    .padding(.top, 50)
                Text("This is my QR code")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                 
                Spacer()
                VStack( alignment: .center , spacing: 20){
                    Button(action: {
                                       self.isTre = true
                    }) {
                        Text("My account")
                            .padding()
                            .foregroundColor(.gray)
                            .frame(width: 150, height: 70)
                            .modifier(CircleButton())
                    }
                    .sheet(isPresented: $isTre) {
                        TreView()
                    }
                    
                    Button(action: {
                                       self.isInfo = true
                    }) {
                        Text("Info")
                            .padding()
                            .foregroundColor(.gray)
                            .frame(width: 150, height: 70)
                            .modifier(CircleButton())
                    }
                    .sheet(isPresented: $isInfo) {
                        InfoView()
                    }
                    
                    Button(action: {
                                     self.isService = true
                    }) {
                        Text("Service")
                            .padding()
                            .foregroundColor(.gray)
                            .frame(width: 150, height: 70)
                            .modifier(CircleButton())
                    }
                    .sheet(isPresented: $isService) {
                        ServiceView()
                    }
                    
                    Button(action: {
                                      self.isSelding = true
                    }) {
                        Text("Re-Sell")
                            .padding()
                            .foregroundColor(.gray)
                            .frame(width: 150, height: 70)
                            .modifier(CircleButton())
                    }
                    .sheet(isPresented: $isSelding) {
                        SeldingView()
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct WarkView_Previews: PreviewProvider {
    static var previews: some View {
        WarkView()
    }
}
