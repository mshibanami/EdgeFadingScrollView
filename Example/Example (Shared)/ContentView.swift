//
//  ContentView.swift
//  Example
//
//  Created by Manabu Nakazawa on 28/8/2022.
//

import SwiftUI
import EdgeFadingScrollView

struct ContentView: View {
    static let contentText = """
        Hello
        Hello
        Hello
        Hello
        Hello
        Hello
        Hello
        Hello
        """
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Default")
                .font(.title3)
            EdgeFadingScrollView {
                Text(Self.contentText)
            }
            .frame(height: 100, alignment: .center)
            .padding(.bottom, 20)

            Text("Green Edges")
                .font(.title3)
            EdgeFadingScrollView(
                showsIndicators: true,
                fadingEdgeColor: .green,
                fadingEdgeShadowColor: .green) {
                    Text(Self.contentText)
                }
                .frame(height: 100, alignment: .center)
                .padding(.bottom, 20)

            Text("Edges with different colors")
                .font(.title3)
            EdgeFadingScrollView(showsIndicators: true) {
                Text(Self.contentText)
            }
            .fadingStartEdgeColor(.pink)
            .fadingStartEdgeShadowColor(.pink)
            .fadingEndEdgeColor(.blue)
            .fadingEndEdgeShadowColor(.blue)
            .frame(height: 100, alignment: .center)
        }
        .padding(.vertical, 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
