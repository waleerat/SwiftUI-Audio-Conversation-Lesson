//
//  CommonModifier.swift
//  SwiftUI-MVVM-and-Design-Pattern
//
//  Created by Waleerat Gottlieb on 2021-09-23.
//

import SwiftUI

struct NavigationBarHiddenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .modifier(ScreenModifier())
    }
}

struct ScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("background").ignoresSafeArea())
    }
}

struct IgnoreBottomAreaModifier : ViewModifier {
    func body(content: Content) -> some View {
    content
        .padding(.bottom, saveAreaBottom)
    }
}


struct TextInputModifier : ViewModifier {
    @State var foregroundColor = Color.accentColor
    
    func body(content: Content) -> some View {
    content
         .font(.system(size: getFontSize(fontStyle: .common) ,weight: .regular, design: .rounded))
        .foregroundColor(foregroundColor)
        .padding(7)
        .background(RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(foregroundColor, lineWidth: 1))
    }
}

struct TextBoldModifier : ViewModifier {
    @State var fontStyle: FontStyle
    @State var foregroundColor = Color.accentColor

    
    func body(content: Content) -> some View {
    content
        .font(.system(size: getFontSize(fontStyle: fontStyle) ,weight: .bold, design: .rounded))
        .foregroundColor(foregroundColor)
       
    }
}

struct TextRegularModifier : ViewModifier {
    @State var fontStyle: FontStyle
    @State var foregroundColor = Color.accentColor
    
    func body(content: Content) -> some View {
    content
        .font(.system(size: getFontSize(fontStyle: fontStyle) ,weight: .regular, design: .rounded))
        .foregroundColor(foregroundColor)
 
    }
}

struct TextBoldWithUnderLineModifier : ViewModifier {
    @State var fontStyle: FontStyle
    @State var foregroundColor = Color.accentColor
    
    func body(content: Content) -> some View {
    content
        .font(.system(size: getFontSize(fontStyle: fontStyle) ,weight: .bold, design: .rounded))
        .foregroundColor(foregroundColor)
        //.underline(true, color: Color.white)
    }
}

struct CommonIconModifier: ViewModifier {
    @State var foregroundColor = Color.accentColor
    
    func body(content: Content) -> some View {
        content
            .frame(width: 20, height: 20)
            .foregroundColor(foregroundColor)
    }
}


struct ImageModifier : ViewModifier {
   func body(content: Content) -> some View {
   content
    .aspectRatio(contentMode: .fit)
    .foregroundColor(.accentColor.opacity(0.5))
    .frame(height: screenSize.height * 0.2)
    .cornerRadius(10)
    .modifier(CustomShadowModifier())
   }
}

struct ThumbnailImageModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 60 , height: 70 )
            .aspectRatio(contentMode: .fit)
            .cornerRadius(5)
    }
}

struct ConversationModifier : ViewModifier {
    @State var backgroundColor: Color
   func body(content: Content) -> some View {
   content
           .padding()
           .font(.system(size: getFontSize(fontStyle: .description) ,weight: .regular, design: .rounded))
           .foregroundColor(Color(kForegroundColor))
           .background(backgroundColor)
           .cornerRadius(8)
   }
}

struct CustomShadowModifier : ViewModifier {
   func body(content: Content) -> some View {
   content
       .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
   }
}

