#!/usr/bin/env ruby

system("csv2md > /dev/null 2>&1")
error("csv2md is not intalled, Please run `bundle install` first") unless $?.exitstatus == 0

docs = {
    "Basics.csv" => "Basics",
    "CoreComponents.csv" => "Core Components",
    "Operators.csv" => "Operators"
}

output = "# RxSwift to Combine Cheatsheet\n" + 
         "This is a Cheatsheet for [RxSwift](https://github.com/ReactiveX/RxSwift) developers interested in Apple's new [Combine](https://developer.apple.com/documentation/combine) framework.\n\n" + 
         "It's based on the following blog post: [https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b](https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b)\n\n"
         
docs.each { |file, title| 
    output += "## [#{title}](Data/#{file})\n\n"
    output += `csv2md Data/#{file}`
    output += "\n\n"
}

output += "# Contributing\n"
output += "Add any data/operators to the appropriate CSV files in the **Data** folder, run `genreadme.rb` and commit the changes. Then, submit a Pull Request"


File.write('README.md', output)