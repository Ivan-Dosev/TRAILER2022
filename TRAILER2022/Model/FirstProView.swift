//
//  FirstProView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//


import SwiftUI

struct FirstProView: View {
    
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        VStack {
            if status {
                  // AuthRegistration()
                    // WarkView()
                      LogoView()
            }else{
                     Adress()
            }
            
           
        }.onAppear(){
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
            }
        }
    }
}

struct FirstProView_Previews: PreviewProvider {
    static var previews: some View {
        FirstProView()
    }
}
