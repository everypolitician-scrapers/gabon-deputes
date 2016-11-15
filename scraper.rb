#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
# require 'open-uri'
require 'pdf-reader'
require 'scraped_page_archive/open-uri'

# require 'colorize'
# require 'pry'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'

def scrape_list(url)
  warn "Getting #{url}"
  file = open(url)

  reader = PDF::Reader.new(file)
  reader.pages.each do |page|
    page.text.split("\n").each do |line|
      if got = line.match(/^\s*(\d+)\s{2,}(.*)\s{2,}(.*)$/)
        (id, name, party) = got.captures
        data = { 
          id: id.strip,
          name: name.strip,
          party: party.strip,
          area: '',
          term: 12,
          source: url,
        }
        ScraperWiki.save_sqlite([:id, :term], data)
        puts data
      end
    end
  end
end

term = {
  id: 12,
  name: '12 Législature',
  start_date: '2012',
}
ScraperWiki.save_sqlite([:id], term, 'terms')

scrape_list('http://www.assemblee-nationale.ga/object.getObject.do?id=190')
