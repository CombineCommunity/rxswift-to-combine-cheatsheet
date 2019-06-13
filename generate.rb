#!/usr/bin/env ruby

system("csv2md > /dev/null 2>&1")
error("csv2md is not intalled, Please run `bundle install` first") unless $?.exitstatus == 0

require 'commonmarker'
require 'imgkit'
require 'colorize'

docs = {
    "basics.csv" => "Basics",
    "core_components.csv" => "Core Components",
    "operators.csv" => "Operators"
}

output = "# RxSwift to Combine Cheatsheet\n" + 
         "This is a Cheatsheet for [RxSwift](https://github.com/ReactiveX/RxSwift) developers interested in Apple's new [Combine](https://developer.apple.com/documentation/combine) framework.\n\n" + 
         "It's based on the following blog post: [https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b](https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b)\n\n"
     
puts "Rebuilding README.md ...".purple

docs.each { |file, title|
    ## Generate markdown for the specific section
    output += "## [#{title}](Data/#{file})\n\n"
    table = `csv2md Data/#{file}`
    output += table
    output += "\n\n"

    image_file = file.sub(".csv", ".jpg")

    puts "Generating image: #{image_file}".light_blue

    ## Convert markdown to HTML
    tableHTML = CommonMarker.render_html(table, :DEFAULT, %i[table])

    html = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HTML5 Doctor | Element Index</title>
    <style type="text/css">
        * { 
            font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
            font-size: 16px;
            line-height: 1.5;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-spacing: 0;
        }

        tr:nth-child(2n) {
            background-color: #f6f8fa;
        }

        tr {
            background-color: #fff;
        }

        td {
            padding: 6px 13px;
            border: 1px solid #dfe2e5;
            display: table-cell;
        }

        th {
            border: 1px solid #dfe2e5;
            padding: 6px 13px;
            font-weight: bold;
        }
    </style>
</head>
<body>
#{tableHTML}</body>
</html>
    HTML

    ## Convert HTML to Image 🤯
    kit = IMGKit.new(html, :quality => 100)
    file = kit.to_file("Resources/#{image_file}")
}

output += "# Contributing\n"
output += "Add any data/operators to the appropriate CSV files in the **Data** folder, run `bundle install` and `generate.rb`.\n\nFinally, commit the changes and submit a Pull Request."

puts "Writing README.md ...".purple
File.write('README.md', output)

puts "🎉 All done! 🎉".green