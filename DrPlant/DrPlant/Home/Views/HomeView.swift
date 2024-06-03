//
//  HomeView.swift
//  DrPlant
//
//  Created by Adam Bokun on 1.06.24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("DrPlant")
            Spacer()
            Image("homeimage")
            HStack {
                VStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.up")
                            .frame(width: 119, height: 46)
                            .background(Color.black)
                            .cornerRadius(6)
                            .foregroundColor(Color.white)
                    }
                    Text("Upload")
                }
                .padding(20)
                
                VStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "camera")
                            .frame(width: 119, height: 46)
                            .background(Color.black)
                            .cornerRadius(6)
                            .foregroundColor(Color.white)
                    }
                    Text("Take a pic")
                }
                .padding(20)
            }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
