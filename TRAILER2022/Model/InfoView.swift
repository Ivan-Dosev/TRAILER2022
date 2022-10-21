//
//  InfoView.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 30.01.22.
//

import SwiftUI
import CodeScanner

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showFullDiscription : Bool = false
    @State private var number : Int = 0
    @StateObject var arda = Mara()
    @State private var isNumberTrailerScanner = false
    @State private var scanner : String = ""
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
                Section(header: HStack {
                    Text("Trailer Number ")
                    Spacer()
                    Button(action: {
                                     self.isNumberTrailerScanner = true
                                     self.isLoading = true
                                          arda.info = []
                                       
                    }) {
                        Text("Scan ")
                            .padding()
                            .frame(width: 120, height: 40)
                            .modifier(CircleButton())
                            .offset(y: -10)
                        
                    }
                }) {
                  
                        VStack( alignment: .leading , spacing: 15){
                            Text( arda.trailerNumber ?? "Unknown")
                               

                        } .font(.system(size: 14))
   
                }
                   
                        ForEach(Array(zip( 1... ,arda.info )), id: \.1.id) { (  num , name) in
                            VStack( alignment: .leading , spacing: 5) {
                                Text(name.date)
                                HStack( spacing: 2){
                                    VStack( alignment: .leading , spacing: 5){
                                    
                                   //   Text(name.fromName!.authName)
                                  //    Text(name.fromName!.authPhone)
                                        Text(name.fromName!.serviceNote)
                                            .fontWeight(.heavy)
                                            .lineLimit(self.number == num ? nil : 1)
                                            Button(action: {
                                                withAnimation{
                                                    self.showFullDiscription.toggle()
                                                    if self.showFullDiscription {
                                                        self.number = num
                                                    }else{
                                                        self.number = 0
                                                    }
                                                }
                                            }) {
                                                Text(self.number == num  ? "Less" : "Read more...")
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
                                 
                                    //  Text(name.toName!.authName)
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
           

            }.overlay(isLoading ? ProgressView().toAnyView() : EmptyView().toAnyView())
                .overlay(Text(arda.verifyString).foregroundColor(.red).rotationEffect(.init(degrees: -45)).font(.system(size: 50)))

        }
        .sheet(isPresented: $isNumberTrailerScanner){ scannerSheet }
        
    }
    var scannerSheet: some View {
        CodeScannerView(codeTypes: [.qr] , completion: { result in
            switch result {
            case .success(let res) :
                print("\(res)")
   //      self.scannedCode = res.string
                let separator = res.string.components(separatedBy: "/")
             
            //  self.scanner = res.string
                self.scanner = separator[0]
                self.arda.trailerNumber = self.scanner
                self.isNumberTrailerScanner = false
                DispatchQueue.main.async {
                    arda.loadURL(name: self.scanner)
                }
            case .failure(let err):
                print("\(err)")
                self.isNumberTrailerScanner = false
            }
        })
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
extension View {
    func toAnyView() -> AnyView {
                        AnyView(self)
    }
}
