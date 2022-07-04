//
//  ContentView.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 6/30/22.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    
    @EnvironmentObject var vm: ForecastListViewModel

    let rows: [GridItem] = [
        GridItem(.fixed(200))
    ]
    
    var body: some View {
        NavigationView {
            if vm.showError {
                PopupView(errorMessage: $vm.errorMessage, retryButtonPressed: {
                    vm.refreshData()
                })
            } else {
                ZStack {
                    ScrollView {
                        VStack {
                            SearchBarView(searchText: $vm.searchCityName)
                            currentTempSection
                                .padding()
                                .cornerRadius(10)
                                .onTapGesture {
                                    UIApplication.shared.endEditing()
                                }
                        }
                        
                        gridListTitle
                        
                        horizontalGrid
                    }
                    .background(Color.theme.bgColor)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }.zIndex(-1)
                //.banner(data: $vm.bannerData, show: $vm.showError)
                .overlay {
                    if vm.isLoading {
                        ZStack {
                            Color(.systemBackground)
                                .ignoresSafeArea()
                                .opacity(0.9)
                                .blur(radius: 10)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                                .scaleEffect(2)
                        }
                    }
                }
            }
        }
        
        .onAppear {
            //vm.refreshData()
        }
    }
}

extension MainView {
    var currentTempSection: some View {
        HStack(alignment: .bottom) {
            VStack(spacing: 25) {
                VStack(alignment: .center, spacing: 10) {
                    Text(vm.forecastViewModelItems.first?.currentTemp ?? "-")
                        .font(.system(size: 70))
                    Text(vm.forecastViewModelItems.first?.overview ?? "-")
                        .font(.title2)
                }
                
                VStack(spacing: 14) {
                    Text(vm.forecastViewModelItems.first?.humidity ?? "-")
                        .font(.body)
                    HStack(spacing: 15){
                        Text("L: \(vm.forecastViewModelItems.first?.low ?? "-")")
                            .opacity(0.7)
                        
                            Text("H: \(vm.forecastViewModelItems.first?.high ?? "-")")
                            .opacity(0.7)
                    }
                }
                .font(.body)
            }
            .foregroundColor(.white)
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            VStack {
                Text(vm.city)
                    .font(.system(size: 45))
                    .foregroundColor(.white)
                KFImage.url(vm.forecastViewModelItems.first?.currentIconURL)
                    .placeholder({
                        Image(systemName: "hourglass")
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipped()
            }.padding(.trailing, 25)
        }
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.theme.cardBgColor)
        }
    }
    
    var gridListTitle: some View {
        Text("Next 7 days")
            .foregroundColor(.primary)
            .font(.title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
    
    var horizontalGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows) {
                ForEach(vm.forecastViewModelItems, id: \.day) { item in
                    NavigationLink(destination: ForecastDetailView(forecastViewModel: item)) {
                        Rectangle()
                            .fill(Color.theme.cardBgColor)
                            .frame(width: 170)
                            .cornerRadius(20)
                            .padding(.horizontal, 8)
                            .shadow(color: .black.opacity(0.3),
                                    radius: 5,
                                    x: 0,
                                    y: 8)
                            .overlay {
                                VStack(spacing: 10) {
                                    Text(item.day)
                                        .fontWeight(.semibold)
                                        .font(.title2)
                                    KFImage.url(item.dailyIconURL)
                                        .placeholder({
                                            Image(systemName: "hourglass")
                                        })
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 50)
                                    HStack(spacing: 15) {
                                        VStack(spacing: 8) {
                                            Text("Min")
                                            Text(item.low)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            Text("Max")
                                            Text(item.high)
                                        }
                                    }
                                }
                                .foregroundColor(.white)
                            }
                    }
                    .buttonStyle(FlatLinkStyle())
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            MainView()
                .environmentObject(ForecastListViewModel())
        }
    }
}

struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
