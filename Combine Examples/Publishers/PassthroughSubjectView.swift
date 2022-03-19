//
//  PassthroughSubjectView.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 3/19/22.
//

import SwiftUI
import Combine

enum CreditCardStatus {
    case ok, invalid, notEvaluated
}
class PassthroughSubjectVM: ObservableObject{
    @Published var creditCard = ""
    @Published var status = CreditCardStatus.notEvaluated
    let verifyCreditCard = PassthroughSubject<String, Never>()
    
    init() {
        verifyCreditCard
            .map{creditCard -> CreditCardStatus in
                if creditCard.count == 16{
                    return CreditCardStatus.ok
                } else {
                    return CreditCardStatus.invalid
                }
            }
            .assign(to: &$status)
    }
}


struct PassthroughSubjectView: View {
    @StateObject var vm = PassthroughSubjectVM()
    
    
    var body: some View {
        VStack{
            DescView(desc: "The PassthroughSubject publisher will send a value through a pipeline but not retain the value.")
            HStack{
                TextField("Credit card number", text: $vm.creditCard)
                Group{
                    switch(vm.status){
                    case .ok:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    case .invalid:
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                    default:
                        EmptyView()
                    }
                }
            }
            .padding()
            Button("Verify CC Number"){
                vm.verifyCreditCard.send(vm.creditCard)
            }
        }
        .font(.title)
    }
}

struct PassthroughSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        PassthroughSubjectView()
    }
}
