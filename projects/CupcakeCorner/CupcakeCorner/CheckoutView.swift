//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Derek on 12/9/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationTitle = "Thank you!"
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var placingOrder = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                           scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                VStack {
                
                    Text("Order summary")
                        .font(.title2)
                        .foregroundColor(.brown)
                    
                    HStack {
                        Text("\(order.quantity)")
                            .bold()
                        Text("x")
                        Text("\(Order.types[order.type]) cupcakes")
                    }
                    
                    if order.extraFrosting {
                        Text("with extra frosting")
                    }
                    
                    if order.addSprinkes {
                        Text("with sprinkles")
                    }
                }
                
                Spacer()
                Spacer()
                
                VStack {
                    Spacer()
                    Text("Delivery details")
                        .font(.title2)
                        .foregroundColor(.brown)
                    
                    VStack {
                        Text(order.name)
                            .font(.headline)
                        Text(order.streetAddress)
                        Text("\(order.city), \(order.zip)")
                    }
                }
                
                Spacer()
                Spacer()
                
                VStack {
                    Spacer()
                    Text("Your total")
                        .font(.title2)
                    
                    Text("\(order.cost, format: .currency(code: "USD"))")
                        .font(.title.bold())
                }
                
                Button(placingOrder ? "Placing order..." : "Place Order") {
                    Task {
                      await placeOrder()
                    }
                }
                .buttonStyle(.bordered)
                .font(.headline)
                .padding()
                .disabled(placingOrder == true)
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .alert(confirmationTitle, isPresented: $showingConfirmation){
            Button("Ok") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        placingOrder = true
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationTitle = "Thank you!"
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            placingOrder = false
        } catch {
            confirmationTitle = "Oops..!"
            confirmationMessage = "Unable to place order at this time. Try again later."
            print("Checkout failed.")
            showingConfirmation = true
            placingOrder = false
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
