//
//  ViewModifiers.swift
//  Alarmania (iOS)
//
//  Created by start on 14/02/2021.
//

import SwiftUI

struct LogoTextModifier: ViewModifier {
    func body(content: Content) ->some View {
        content
            .font(Font.custom("NHaasGroteskTXPro-75Bd", size: 48))
            .foregroundColor(.white)
    }
}
struct LogoSubTextModifier: ViewModifier {
    func body(content: Content) ->some View {
        content
            .font(Font.custom("NHaasGroteskTXPro-55Rg", size:16))
            .foregroundColor(.gray)
    }
}
struct FloatingMiniMenuTextModifer: ViewModifier {
    func body(content: Content) ->some View {
        content
            .font(.custom("NHaasGroteskTXPro-65Md", size: 16))
           
    }
}
extension View {
    func logoTextStyle() ->some View {
        self.modifier(LogoTextModifier())
    }
    
    func logoSubTextStyle() ->some View {
        self.modifier(LogoSubTextModifier())
    }
    
    func miniMenuTextStyle() ->some View {
        self.modifier(FloatingMiniMenuTextModifer())
    }
}
