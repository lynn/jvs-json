#!/bin/ruby
require 'json'
require 'nokogiri'

entries = []
gismus = []
xml = File.open("en.xml") { |f| Nokogiri::XML(f) }
xml.xpath("/dictionary[1]/direction[1]/valsi").each do |v|
  entry = {word: v[:word], type: v[:type]}
  entry[:gloss] = v.xpath("glossword").map(&:attributes)
  entry[:def] = v.xpath("definition").text
  selmaho = v.xpath("selmaho").text
  entry[:selmaho] = selmaho unless selmaho.empty?
  entry[:rafsi] = v.xpath("rafsi").map(&:text)
  entries << entry
  if v[:type] == "gismu" then
    entry = entry.dup
    entry.delete(:type)
    gismus << entry
  end
end

File.open("en.json", "w") { |f| JSON.dump(entries, f) }
File.open("en-gismu.json", "w") { |f| JSON.dump(gismus, f) }
