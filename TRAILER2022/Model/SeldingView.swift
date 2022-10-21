//
//  SeldingView.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 30.01.22.
//


import SwiftUI
import CodeScanner

struct SeldingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var arda = Mara()
    @State private var isPresentingScanner = false
    @State private var isNumberTrailerScanner = false
    @State private var scanner : String = ""
    @State private var alert   : Bool   = false
    @State private var isLoading : Bool = false
    
    @State private var modelTre : String = "111"
    @State private var colorTre : String = "222"
    @State private var dateTre  : String = "333"
 
   
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack( alignment: .center , spacing: 20) {
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
                    Section(header: Text("Seller ")) {
                        VStack( alignment: .leading , spacing: 15){
                            
                            Text(arda.taskTo?.authNumber ?? "Unknown")
                            Text(arda.taskTo?.authName ?? "Unknown")
                            Text(arda.taskTo?.authPhone ?? "Unknown")
                          
                            
                        } .font(.system(size: 14))
                    }
                    Section(header: HStack {
                        Text("Buyer ")
                        Spacer()
                        Button(action: {
                                         self.isPresentingScanner = true
                        }) {
                            Text("Scan ")
                                .padding()
                                .frame(width: 150, height: 40)
                                .modifier(CircleButton())
                                .offset(y: -10)
                            
                        }
                    }) {
                      
                            VStack( alignment: .leading , spacing: 15){
                                Text(arda.taskFrom?.authNumber ?? "Unknown")
                                Text(arda.taskFrom?.authName ?? "Unknown")
                                Text(arda.taskFrom?.authPhone ?? "Unknown")
                            } .font(.system(size: 14))
       
                    }
                    
                    Section(header: HStack {
                        Text("Trailer Number ")
                        Spacer()
                        Button(action: {
                                         self.isNumberTrailerScanner = true
                        }) {
                            Text("Scan ")
                                .padding()
                                .frame(width: 150, height: 40)
                                .modifier(CircleButton())
                                .offset(y: -10)
                            
                        }
                    }) {
                      
                            VStack( alignment: .leading , spacing: 15){
                                Text( arda.trailerNumber ?? "Unknown")

                            } .font(.system(size: 14))
       
                    }
                    
     
                }
                .background(Color.clear)
                .sheet(isPresented: $isNumberTrailerScanner)  {
                    scannerNumberSheet
                }
                Spacer()
                if !(arda.trailerNumber?.isEmpty ?? true) && !(arda.taskFrom?.authPhone.isEmpty ?? true){
                    Button(action: {
                              saveData()
                        self.isLoading = true
                    }) {
                        Text("Run and Save")
                            .padding()
                            .frame(width: 300, height: 70)
                            .modifier(CircleButton())
                    }
                    .padding(.bottom, 50)
                }
 
               
            }
            .overlay(isLoading ? ProgressView().toAnyView() : EmptyView().toAnyView())
            .onAppear{
                arda.loadData()
            }
            .sheet(isPresented: $isPresentingScanner){ scannerSheet }
            .alert(isPresented: $alert) {
                Alert(title: Text("Alert"), message: Text("Your data will be saved to the Blockchain"), dismissButton: .default(Text("Got it"), action: {
                    
                    saveBlockchane()
                    arda.isID = true
 
                    self.alert.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20){
                        presentationMode.wrappedValue.dismiss()
                    }
                  

                    
                }))
            }.onAppear{
                self.isLoading = false
            }
        }
    }
    
    func saveBlockchane(){
                          arda.dataCodable()
    }
    
    func saveData() {
        
        let infoTo = Names(authName: arda.taskTo?.authName ?? "Unknown" , authNumber: arda.taskTo?.authNumber ?? "Unknown", authPhone: arda.taskTo?.authPhone ?? "Unknown", treNumber: arda.trailerNumber ?? "Unknown", serviceNote: "Seller")
        
        let infoFrom = Names(authName: arda.taskFrom?.authName ?? "Unknown", authNumber: arda.taskFrom?.authNumber ?? "Unknown", authPhone: arda.taskFrom?.authPhone ?? "Unknown", treNumber:  arda.trailerNumber ?? "Unknown", serviceNote: "Buyer")
        
        let characteristic = Characteristic(authNumber: arda.taskFrom?.authNumber ?? "Unknown", modelTre: self.modelTre, colorTre: colorTre, dateTre: dateTre, scanner:  arda.trailerNumber ?? "Unknown")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            arda.addInfo(infoFrom: infoFrom, infoTo:    infoTo)
        
            arda.isCharacteristic(characteristic: characteristic)

            self.alert.toggle()
        }
        
    }
      var scannerSheet: some View {
          CodeScannerView(codeTypes: [.qr] , completion: { result in
              switch result {
              case .success(let res) :
                  print("\(res)")
                  self.scanner = res.string
              
                  self.isPresentingScanner = false
                  
                  DispatchQueue.main.async {
                      arda.loadDataFrom(name: self.scanner)
                  }
                  
              case .failure(let err):
                  print("\(err)")
                  self.isPresentingScanner = false
              }
          })
      }
    
    var scannerNumberSheet: some View {
        CodeScannerView(codeTypes: [.qr] , completion: { result in
            switch result {
            case .success(let res) :
                print("\(res)")
                
                let  separator = res.string.components(separatedBy: "/")
                if separator.count > 3 {
                    self.modelTre = separator[1]
                    self.colorTre = separator[2]
                    self.dateTre  = separator[3]
                }


                self.arda.trailerNumber = separator[0]
                self.isNumberTrailerScanner = false

              
            case .failure(let err):
                print("\(err)")
                self.isNumberTrailerScanner = false
            }
        })
    }
}


