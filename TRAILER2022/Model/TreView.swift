//
//  TreView.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 12.02.22.
//

import SwiftUI

struct TreView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var number : Int = 0
    @State private var index : Int = 0
    @State private var showInfoData : Bool = false
    @StateObject var arda = Mara()
    @State private var isShow : Bool = false
    @State private var showFullDiscription : Bool = false
    @State private var mumber : Int = 0
    @State private var isLoading : Bool = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("⏎")
                            .padding()
                            .frame(width: 70, height: 30)
                            .modifier(CircleButton())
                        
                    }
                    
                    Spacer()
                }
                .padding(.top, 30)
                .offset(x: 30)
                
                Form{
                    Section{
                        Text("My account")
                    }
                    
                    ForEach(Array(zip( 1... ,arda.allTre )), id: \.1.id) { (  num , name) in
                        VStack {
                            HStack{
                                Text(name.modelTre)
                                Text(name.colorTre)
                                Spacer()
                                Text(name.dateTre)
                            }
                            .onTapGesture{
                                self.number = num
                                self.showInfoData = false
                            }
                            
                            .font(.system(size: 16))
                            .padding(.vertical, 4)

                            if self.number == num {
                             Text("")
                                    .overlay(isLoading ? ProgressView().toAnyView() : EmptyView().toAnyView())
                                QRCodeView(url: name.scanner)
                                    .padding(.top, 50)
                                    .onAppear{
                                        arda.loadURL(name: name.scanner)
                                        arda.trailerNumber = name.scanner
                                  
                                    }
                                    .onTapGesture{
                                       
                                        self.showInfoData.toggle()
                                    }
                                if showInfoData && self.number == num {
                                    infoData
                                }
                               

                            }
                        }
                    }
                }
            }
        }
    }
    
    var infoData : some View {
        ForEach(Array(zip( 1... ,arda.info )), id: \.1.id) { (  num , name) in
            VStack( alignment: .leading , spacing: 5) {
                Text(name.date)
                HStack( spacing: 2){
                    VStack( alignment: .leading , spacing: 5){
                    
                        Text(name.fromName!.authName)
                  //    Text(name.fromName!.authPhone)
                        Text(name.fromName!.serviceNote)
                            .fontWeight(.heavy)
                            .lineLimit(self.number == num ? nil : 1)
                            Button(action: {
                                withAnimation{
                                    self.showFullDiscription.toggle()
                                    if self.showFullDiscription {
                                        self.index = num
                                    }else{
                                        self.index = 0
                                    }
                                }
                            }) {
                                Text(self.index == num  ? "Less" : "Read more...")
                                   // .font(.caption)
                                    .fontWeight(.bold)
                                    .font(.system(size: 10))
                                    .padding(.vertical, 4)
                            }
                            .accentColor(.blue)
                        }
                  // .frame(width: UIScreen.main.bounds.width / 2.5)
               
                    Spacer()
                    VStack( alignment: .trailing , spacing: 5){
                 
                        Text(name.toName!.authName)
                  //    Text(name.toName!.authPhone)
                        Text(name.toName!.serviceNote)
                            .fontWeight(.heavy)
                        Spacer()
                    }
                  //  .frame(width: UIScreen.main.bounds.width / 2.5)

                }
            } .font(.system(size: 8))
                .onAppear(){
                    self.isLoading = false
                    if !arda.info.isEmpty {
                        arda.isInfo = true
                    }
                 
                }
        }
    }
    
}

struct TreView_Previews: PreviewProvider {
    static var previews: some View {
        TreView()
    }
}
