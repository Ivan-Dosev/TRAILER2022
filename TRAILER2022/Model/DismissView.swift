//
//  DismissView.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 30.01.22.
//

import SwiftUI

struct DismissView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
    }
}

struct DismissView_Previews: PreviewProvider {
    static var previews: some View {
        DismissView()
    }
}
