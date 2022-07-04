//
//  PopupView.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/4/22.
//

import SwiftUI

struct PopupView: View {
    
    @State private var animate: Bool =  false
    @Binding var errorMessage: String
    
    var retryButtonPressed: ()->Void
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.primary)
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.theme.darkShadow.opacity(0.4), radius: 15, y: 15)
                .overlay {
                    VStack(spacing: 30) {
                        VStack(spacing: 10) {
                            Text("Something went wrong!")
                                .font(.title)
                                .foregroundColor(.red)
                            Text(errorMessage.capitalized)
                                .font(.title2)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color.theme.labelColor)
                        }
                        .frame(maxWidth: .infinity)
                        Button(action: {
                            retryButtonPressed()
                        }, label: {
                            Text("Retry".uppercased())
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        })
                        .padding(.horizontal, 50)
                        .offset(x: animate ? -7 : 0)
                    }
                    .frame(maxWidth: 400)
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .onAppear {
                       performAnimation()
                    }
                }
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func performAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 1.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            PopupView(errorMessage: .constant("Test Check internet connection"), retryButtonPressed: {})
        }
    }
}
