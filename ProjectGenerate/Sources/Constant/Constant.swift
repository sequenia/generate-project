//
//  Constant.swift
//  ProjectGenerate
//
//  Created by Ivan Mikhailovskii on 24.04.2021.
//

import Foundation

struct Constant {
    static let templateGenerambaPathScript = """
    #!/bin/bash

    USER=$(whoami)
    export PATH=:/Users/$USER/.rbenv/shims:$PATH

    echo "$(which generamba)"
    """
    
    static func rambaFileContent(companyName: String) -> String {
        
        return """
        ### Headers settings
        company: \(companyName)

        ### Xcode project settings
        project_name: ProjectTemplate

        ### Code generation settings section
        # The main project target name
        project_target: ProjectTemplate

        ### Dependencies settings section
        podfile_path: Podfile

        # The file path for new modules
        project_file_path: ./

        catalogs:
        - 'git@gitlab.sequenia.com:templates/TemplatesIOS.git'

        ### Templates
        templates:

        # App screens
        - {name: ProjectTemplate}
        """
    }
    
    static let gemFileContent = """
    source 'https://rubygems.org'
    gem 'generamba', git: 'https://github.com/sequenia/Generamba.git'
    """
}
