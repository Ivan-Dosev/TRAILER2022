//
//  LogoView.swift
//  TRAILER2022
//
//  Created by Dosi Dimitrov on 1.02.22.
//

import SwiftUI

struct LogoView: View {
    
    @State private var isActive  : Bool    = false
    @State private var sizeHight : CGFloat = 100
    @State private var opasity             = 0.5
    
    var body: some View {
        if isActive{
            
            WarkView()
            
        }else{
            
            VStack {
                VStack {
                    Image("BCRL")
                        .resizable()
                        .frame(width: 400, height: sizeHight)
                        .opacity(opasity)
                }
                .onAppear{
                    withAnimation(.easeIn(duration: 1.5)){
                        self.sizeHight = 200
                        self.opasity   = 1
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
            
            
        }
        
        

    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}

struct BlurView: UIViewRepresentable {
    
    var style : UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
    
 
    
  
    
}
