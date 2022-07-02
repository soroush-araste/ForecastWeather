//
//  SearchBarView.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/1/22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.primary)
            TextField("Search City", text: $searchText)
                .foregroundColor(.primary)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(.primary)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                    , alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.searchBarColor)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
        }
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
        }
    }
}
