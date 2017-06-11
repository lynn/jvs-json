#!/bin/ruby
require 'json'
require 'nokogiri'

entires = []
xml = File.open("en.xml") { |f| Nokogiri::XML(f) }
xml.xpath("/dictionary[1]/direction[1]/valsi").each do |v|
    entry = {word: v[:word], type: v[:type]}
    entry[:gloss] = v.xpath("glossword").map(&:attributes)
    entry[:def] = v.xpath("definition").text
    selmaho = v.xpath("selmaho").text
    entry[:selmaho] = selmaho unless selmaho.empty?
    entires << entry
end

puts JSON.generate(entires)
