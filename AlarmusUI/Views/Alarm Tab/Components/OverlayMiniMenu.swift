//
//  OverlayMiniMenu.swift
//  Alarmania (iOS)
//
//  Created by start on 14/02/2021.
//

import SwiftUI


    // MARK: - BODY

struct OverlayMiniMenu: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Button( action: {} ) {
                    Text("Edit alarm")
                        .miniMenuTextStyle()
                        Spacer()
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                    
                } // BUTTON
            } // HSTACK
            Button(action: {
                
            } ) {
                Text("Delete alarm")
                    .foregroundColor(.red)
                    .miniMenuTextStyle()
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(.red)
                   
            } // BUTTON
        } // VSTACK
        .background(Color.white)
        .frame(maxWidth: 200)
        .cornerRadius(8)
        
    }
}

// MARK: - PREVIEW
struct OverlayMiniMenu_Previews: PreviewProvider {
    static var previews: some View {
        OverlayMiniMenu()
            .previewLayout(.sizeThatFits)
    }
}
