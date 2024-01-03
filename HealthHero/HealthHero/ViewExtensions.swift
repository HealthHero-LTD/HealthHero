//
//  ViewExtensions.swift
//  HealthHero
//
//  Created by soroush kami on 2024-01-02.
//

import SwiftUI

enum FrameAlignment {
    case top, bottom, leading, trailing, center
}

extension View {
    
    @ViewBuilder
    func alignmentInfinity(_ alignment: FrameAlignment) -> some View {
        switch alignment {
        case .top:
            self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
        case .bottom:
            self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .bottom)
        case .leading:
            self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        case .trailing:
            self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
        case .center:
            self.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        }
    }
}
