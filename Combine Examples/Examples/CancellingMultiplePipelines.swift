//
//  CancellingMultiplePipelines.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 1/8/22.
//

import SwiftUI
import Combine

class CancellingMultiplePipelinesVM: ObservableObject{
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    
    private var validationCancelable: Set<AnyCancellable> = []
    
    init() {
        $firstName
            .map {$0.isEmpty ? "❌" : "✅"}
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancelable)
        
        $lastName
            .map {$0.isEmpty ? "❌" : "✅"}
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancelable)
    }
    func cancelAllValidations() {
        validationCancelable.removeAll()
    }
}

struct CancellingMultiplePipelines: View {
    @StateObject private var vm = CancellingMultiplePipelinesVM()
    
    var body: some View {
        VStack(spacing: 20){
            DescView(desc: "You can use the store function at the end of a pipeline to add your pipeline's cancellable to a Set.")
            Group{
                HStack{
                    TextField("First Name", text: $vm.firstName)
                        .textFieldStyle(.roundedBorder)
                    Text(vm.firstNameValidation)
                }
                HStack{
                    TextField("Last name", text: $vm.lastName)
                        .textFieldStyle(.roundedBorder)
                    Text(vm.lastNameValidation)
                }
            }
            .padding()
            Button("Cancel All Validations"){
                vm.cancelAllValidations()
            }
        }
        .font(.title)
    }
}

struct CancellingMultiplePipelines_Previews: PreviewProvider {
    static var previews: some View {
        CancellingMultiplePipelines()
    }
}
