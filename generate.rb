#!/usr/bin/env ruby

system("csv2md > /dev/null 2>&1")
error("csv2md is not intalled, Please run `bundle install` first") unless $?.exitstatus == 0

require 'commonmarker'
require 'imgkit'
require 'colorize'
require 'csv'

docs = {
    "basics.csv" => "Basics",
    "core_components.csv" => "Core Components",
    "operators.csv" => "Operators"
}

output = "# RxSwift to Combine Cheatsheet\n" + 
         "This is a Cheatsheet for [RxSwift](https://github.com/ReactiveX/RxSwift) developers interested in Apple's new [Combine](https://developer.apple.com/documentation/combine) framework.\n\n" + 
         "It's based on the following blog post: [https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b](https://medium.com/gett-engineering/rxswift-to-apples-combine-cheat-sheet-e9ce32b14c5b)\n\n"
     
puts "Rebuilding README.md ...".magenta

docs.each { |file, title|
    csv_path = "Data/#{file}"

    ## Sort CSVs (aside for basics)
    unless file == "basics.csv" then
        csv = CSV.read(csv_path)
        body = csv.drop(1).sort! { |a, b| a[0].to_s <=> b[0].to_s }
        rows = body

        csvOutput = CSV.generate_line(csv[0])
        csvOutput += rows.inject([]) { |csv, row| csv << CSV.generate_line(row) }
                         .join()
        
        File.write(csv_path, csvOutput)
    end
    
    ## Generate markdown for the specific section
    output += "## [#{title}](#{csv_path})\n\n"
    table = `csv2md #{csv_path}`
    output += table
    output += "\n\n"

    image_file = file.sub(".csv", ".jpg")

    puts "Generating image: #{image_file}".light_blue

    ## Convert markdown to HTML
    ## We also have to replace emoji manually with images, due to a bug in wkhtmltoimage.
    ## See: https://github.com/wkhtmltopdf/wkhtmltopdf/issues/2913
    tableHTML = CommonMarker.render_html(table, :DEFAULT, %i[table])
                            .gsub('❌', '<img src="https://github.com/freak4pc/rxswift-to-combine-cheatsheet/raw/master/Resources/Icons/x.png" style="width: 22px; height: auto;" />')

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
    kit = IMGKit.new(html, :quality => 100, :encoding => 'UTF-8')
    file = kit.to_file("Resources/#{image_file}")
}

output += "# Contributing\n"
output += "Add any data/operators to the appropriate CSV files in the **Data** folder, run `bundle install` and `generate.rb`.\n\nFinally, commit the changes and submit a Pull Request."

puts "Writing README.md ...".magenta
File.write('README.md', output)

puts "🎉 All done! 🎉".green
