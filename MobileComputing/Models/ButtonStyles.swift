/*
    These are custom ButtonStyles that were used during an earlier development stage
    Although most of them are not needed anymore at this point,
    we kept the structures to be able to reference them if needed.
*/

import Foundation
import SwiftUI

// Big Buttons, Medium Width
struct OrangeMed: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 25, weight: Font.Weight.bold))
            .foregroundColor(Color.accentColor)
            .frame(width: 150, height: 50)
            .background(
                Color.black
                    .opacity(0.3))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 5)
            )
            .padding(.all, 5)
    }
}

struct WhiteMed: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 25, weight: Font.Weight.bold))
            .foregroundColor(Color.white)
            .frame(width: 150, height: 50)
            .background(
                Color.black
                    .opacity(0.3))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 5)
            )
            .padding(.all, 5)
    }
}

struct ToggledMed: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 25, weight: Font.Weight.bold))
            .foregroundColor(Color.white)
            .frame(width: 150, height: 50)
            .background(
                Color.accentColor
                    .opacity(0.7))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 5)
            )
            .padding(.all, 5)
    }
}

// Big Buttons, Wider Width
struct OrangeWide: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 25, weight: Font.Weight.bold))
            .foregroundColor(Color.accentColor)
            .frame(width: 250, height: 50)
            .background(
                Color.black
                    .opacity(0.3))
            .cornerRadius(30)
            .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white, lineWidth: 5))
            .padding(.all, 5)
    }
}

struct WhiteWide: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 25, weight: Font.Weight.bold))
            .foregroundColor(Color.white)
            .frame(width: 250, height: 50)
            .background(
                Color.black
                    .opacity(0.3))
            .cornerRadius(30)
            .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white, lineWidth: 5))
            .padding(.all, 5)
    }
}

// Small Buttons
struct OrangeSmall: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: Font.Weight.bold))
            .foregroundColor(Color.accentColor)
            .frame(width: 110, height: 45)
            .background(
                Color.black
                    .opacity(0.3))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 5)
            )
            .padding(.all, 5)
    }
}

struct WhiteSmall: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: Font.Weight.bold))
            .foregroundColor(Color.white)
            .frame(width: 110, height: 45)
            .background(
                Color.black
                    .opacity(0.3))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white, lineWidth: 5)
            )
            .padding(.all, 5)
    }
}
