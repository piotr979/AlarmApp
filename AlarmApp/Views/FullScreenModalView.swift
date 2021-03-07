//
//  FullScreenModalView.swift
//  AlarmusUI
//
//  Created by Piotr Glaza on 11/12/2020.
//


import SwiftUI

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button( action: {
                presentationMode.wrappedValue.dismiss()
            }) {
            Text("This is a modal view")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    
            
    }
}

struct FullScreenModalView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenModalView()
    }
}
