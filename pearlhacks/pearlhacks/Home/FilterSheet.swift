//
//  FilterView.swift
//  pearlhacks
//
//  Created by Alexandra Marum on 2/15/25.
//

import SwiftUI



struct FilterSheet: View {
    @Binding var vm: ListingViewModel

    var body: some View {
        VStack {
            Spacer()
            Toggle(isOn: $vm.filterOn) {
                Text(vm.filterOn ? "Deactivate Filter" : "Activate Filter")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(vm.filterOn ? Color.accentColor : Color.gray.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .toggleStyle(.button)
            .padding()
                
            Form {
                Section {
                    Toggle("Eligible listings only", isOn: $vm.filterSettings.eligibleListings)
                    Toggle("Saved listings only", isOn: $vm.filterSettings.savedListings)
                }
                Section {
                    HStack {
                        Text("Minimum Price:")
                        TextField("", value: $vm.filterSettings.min, format: .number)
                    }
                    HStack {
                        Text("Maximum Price:")
                        TextField("", value: $vm.filterSettings.max, format: .number)
                    }
                }
            }
            .foregroundStyle(vm.filterOn ? .primary :.secondary)
            .disabled(!vm.filterOn)
        }
        .onDisappear {
            vm.applyFilters()
        }
//        .onChange(of: vm.filterSettings) {
//            vm.applyFilters()
//        }
    }
}

#Preview {
    FilterSheet(vm: .constant(ListingViewModel()))
}
