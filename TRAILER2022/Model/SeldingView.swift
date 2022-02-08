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
                    Section(header: Text("I buy trailing")) {
                        VStack( alignment: .leading , spacing: 15){
                            
                            Text(arda.taskTo?.authNumber ?? "unknow")
                            Text(arda.taskTo?.authName ?? "unknow")
                            Text(arda.taskTo?.authPhone ?? "unknow")
                          
                            
                        } .font(.system(size: 14))
                    }
                    Section(header: HStack {
                        Text("From ")
                        Spacer()
                        Button(action: {
                                         self.isPresentingScanner = true
                        }) {
                            Text("Scan from")
                                .padding()
                                .frame(width: 150, height: 40)
                                .modifier(CircleButton())
                                .offset(y: -10)
                            
                        }
                    }) {
                      
                            VStack( alignment: .leading , spacing: 15){
                                Text(arda.taskFrom?.authNumber ?? "unknow")
                                Text(arda.taskFrom?.authName ?? "unknow")
                                Text(arda.taskFrom?.authPhone ?? "unknow")
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
                                Text( arda.trailerNumber ?? "unknow")

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
                Alert(title: Text("Blockchain"), message: Text("Do you want to save to Blockchain"), dismissButton: .default(Text("ok"), action: {
                    
                    saveBlockchane()
 
                    self.alert.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
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
        
        let infoTo = Names(authName: arda.taskTo?.authName ?? "unknow" , authNumber: arda.taskTo?.authNumber ?? "unknow", authPhone: arda.taskTo?.authPhone ?? "unknow", treNumber: arda.trailerNumber ?? "unknow", serviceNote: "BUYES")
        
        let infoFrom = Names(authName: arda.taskFrom?.authName ?? "unknow", authNumber: arda.taskFrom?.authNumber ?? "unknow", authPhone: arda.taskFrom?.authPhone ?? "unknow", treNumber:  arda.trailerNumber ?? "unknow", serviceNote: "SALED")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            arda.addInfo(infoFrom: infoFrom, infoTo: infoTo)
            self.alert.toggle()
        }
        
    }
      var scannerSheet: some View {
          CodeScannerView(codeTypes: [.qr] , completion: { result in
              switch result {
              case .success(let res) :
                  print("\(res)")
     //      self.scannedCode = res.string
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

                self.arda.trailerNumber = res.string
                self.isNumberTrailerScanner = false

              
            case .failure(let err):
                print("\(err)")
                self.isNumberTrailerScanner = false
            }
        })
    }
}


