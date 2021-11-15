//
//  Bundle+unitTest.swift
//  fozTests
//
//  Created by Ahmed Medhat on 15/11/2021.
//

import Foundation

extension Bundle {
    public class var unitTest: Bundle {
        return(Bundle(for: ClientServiceTest.self))
    }
}
