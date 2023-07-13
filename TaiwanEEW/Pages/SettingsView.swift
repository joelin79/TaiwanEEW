//
//  SettingsView.swift
//  TaiwanEEW
//
//  Created by Joe Lin on 2022/7/8.
//

import SwiftUI

// TODO: information stuff

struct SettingsView: View {
    @AppStorage("locSelection") var locSelection: Location = .taipei
    @AppStorage("HRSelection") var HRSelection: TimeRange = .year
    @AppStorage("notifySelection") var notifySelection: NotifyThreshold = .eg3
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    var onHistoryRangeChanged: ((TimeRange) -> Void)?
    var onSubscribedLocChanged: ((Location) -> Void)?
    var onNotifyThresholdChanged: ((NotifyThreshold) -> Void)?
    /*
     1. Selection in menu triggers the onChange
     2. onChange passes the new val into the onHistoryRangeChanged closure
     3. The closure, defined in @main, updates the var accessable between views
     */
    
    
    public static let shared = SettingsView()

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    // Location Selection
                    Section(header: Text("alerts-pref-string"), footer: Text("notice1-string")){
                        List {
                            Picker("location-pref-string", selection: $locSelection){
                                ForEach(Location.allCases){ location in
                                    Text(location.getDisplayName())
                                }
                            }
                        }
                    }.onChange(of: locSelection) { value in
                        onSubscribedLocChanged?(value)
                    }
                    // Alert thres. Selection
                    Section(header: Text("notify-pref-string"), footer: Text("notify-force-string")){
                        List {
                            Picker("notify-threshold-string", selection: $notifySelection){
                                ForEach(NotifyThreshold.allCases){ notifyThreshold in
                                    Text(notifyThreshold.getDisplayName())
                                }
                            }
                        }
                    }.onChange(of: notifySelection) { value in
                        onNotifyThresholdChanged?(value)
                    }
                    
                    // TimeRange Selection
                    Section(header: Text("history-pref-string")){
                        List {
                            Picker("history-time-range-string", selection: $HRSelection){
                                ForEach(TimeRange.allCases){ timeRange in
                                    Text(timeRange.getDisplayName())
                                }
                            }
                        }
                        Link(destination: URL(string: "https://eew.earthquake.tw/?act=eew_list")!, label:{
                            Text("view-official-history-string")
                                .foregroundColor(.blue)
                        })
                    }.onChange(of: HRSelection) { value in
                        onHistoryRangeChanged?(value)
                    }
                    
                    Section(header: Text("about-title-string")) {
                        HStack() {
                            Text("version-string").frame(maxWidth: .infinity, alignment: .leading)
                            Text(appVersion ?? "unavaliable").frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(.gray)
                        }
                        NavigationLink {
                            InformationView()
                        } label: {
                            Text("information-title-string")
                        }
                        NavigationLink {
                            TermsOfUseView()
                        } label: {
                            Text("term-title-string")
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("reminder-title-string")
                            .font(.headline)
                            .padding(.bottom, 2)
                            .foregroundColor(.red)
                        Text("reminder-string")
                    }
                    
                }.navigationBarTitle("設定 Settings")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environment(\.locale, Locale.init(identifier: "zh-Hant"))
//        SettingsView().environment(\.locale, Locale.init(identifier: "en"))
//        SettingsView().environment(\.locale, Locale.init(identifier: "ja"))
    }
}
