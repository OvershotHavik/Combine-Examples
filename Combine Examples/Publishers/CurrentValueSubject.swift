//
//  CurrentValueSubject.swift
//  Combine Examples
//
//  Created by Steve Plavetzky on 1/8/22.
//

import SwiftUI
import Combine

class CurrentValueSubjectVM: ObservableObject{
    /*
     Sequence of Events for CurrentValueSubject
    1. Value is set
     2. The pipeline is run
     3. The UI is notified of changes(using ObjectWillChange.send
     
     Sequence of Events for @Published
     1. The pipeline is run
     2. The value is set
     3. The UI is automatically notified of change
     */
    var selection = CurrentValueSubject<String, Never>("No Name Selected")
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    var cancellable: [AnyCancellable] = []
    
    init() {
        selection
            .map{ [unowned self] newValue -> Bool in
                if newValue == selection.value { // This will not work with CurrentValueSubject setup
                    return true
                } else {
                    return false
                }
            }
            .sink{ [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
        
    }
}


struct CurrentValueSubjectView: View {
    @StateObject private var vm = CurrentValueSubjectVM()
    
    var body: some View {
        VStack(spacing: 20) {
            DescView(desc: "The CurrentValueSubject publisher will publish it's existing value and also new values when it gets them.")
            Button("Select Lorenzo"){
                vm.selection.send("Lorenzo")
            }
            //The selection can be set with either send or value as shown here. Will probably stick with send from now on
            Button("Select Ellen"){
                vm.selection.value = "Ellen"
            }
            Text(vm.selection.value)
                .foregroundColor(vm.selectionSame.value ? .red : .green)
        }
        .font(.title)
    }
}




















class CurrentValueSubjectCompareVM: ObservableObject{
    /*
     Sequence of Events for CurrentValueSubject
    1. Value is set
     2. The pipeline is run
     3. The UI is notified of changes(using ObjectWillChange.send
     
     Sequence of Events for @Published
     1. The pipeline is run
     2. The value is set
     3. The UI is automatically notified of change
     */
    @Published var selection = "No Name Selected"
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    var cancellable: [AnyCancellable] = []
    
    init() {
        $selection
            .map{ [unowned self] newValue -> Bool in
                if newValue == selection {
                    return true
                } else {
                    return false
                }
            }
            .sink{ [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
        
    }
}






struct CurrentValueSubjectViewCompare: View {
    @StateObject private var vm = CurrentValueSubjectCompareVM()
    
    var body: some View {
        VStack(spacing: 20) {
            DescView(desc: "Comparing with @Published. The map operator will work now because the @Published property's value doesn't actually change until AFTER the pipeline has finished.")
            Button("Select Lorenzo"){
                vm.selection = "Lorenzo"
            }
            Button("Select Ellen"){
                vm.selection = "Ellen"
            }
            Text(vm.selection)
                .foregroundColor(vm.selectionSame.value ? .red : .green)
        }
        .font(.title)
    }
}

struct CurrentValueSubject_Previews: PreviewProvider {
    static var previews: some View {
        CurrentValueSubjectView()
    }
}
