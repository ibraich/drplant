//
//  TabBar.swift
//  DrPlant
//
//  Created by Adam Bokun on 30.05.24.
//

import SwiftUI

struct TabBar: View {
    @Binding var selected : Int
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.selected = 0
            }) {
                VStack {
                    if selected == 0 {
                        Image("search")
                            .resizable()
                            .frame(width: 35,
                                   height: 35)
                    } else {
                        Image("search")
                            .resizable()
                            .frame(width: 25,
                                   height: 25)
                    }
                }
            }
            
            Button(action: {
                self.selected = 1
            }) {
                VStack {
                    if selected == 1 {
                        Image("home")
                            .resizable()
                            .frame(width: 35,
                                   height: 35)
                    } else {
                        Image("home")
                            .resizable()
                            .frame(width: 25,
                                   height: 25)
                    }
                }
            }
            .padding(.horizontal, 35)
            
            Button(action: {
                self.selected = 2
            }) {
                VStack {
                    if selected == 2 {
                        Image("history")
                            .resizable()
                            .frame(width: 35,
                                   height: 35)
                    } else {
                        Image("history")
                            .resizable()
                            .frame(width: 25,
                                   height: 25)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width)
    }
}
