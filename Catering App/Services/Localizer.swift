//
//  Localizer.swift
//  Catering App
//
//  Created by ddavydov on 24.01.2022.
//

import Foundation

func LocalizedString(_ key: String) -> String {
    class BundleClass {}
    let bundle = Bundle(for: BundleClass.self)
    return NSLocalizedString(key,
                             tableName: bundle.infoDictionary!["CFBundleName"] as? String,
                             bundle: bundle,
                             value: "",
                             comment: "")
}
