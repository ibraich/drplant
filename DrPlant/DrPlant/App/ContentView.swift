//
//  ContentView.swift
//  DrPlant
//
//  Created by Adam Bokun on 30.05.24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedPage: Int = 1
    var body: some View {
        NavigationView {
            mainContent
        }
    }
    
    var mainContent: some View {
        VStack(spacing: 0) {
            appViews
            TabBar(selected: $selectedPage)
        }
    }
    
    @ViewBuilder
    var appViews: some View {
        switch selectedPage {
        case 0:
            SearchView()
        case 1:
            HomeView()
        case 2:
            EmptyView()
        default:
            EmptyView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
