#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pdf-reader'
require 'pry'
require 'scraperwiki'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'
require 'scraped_page_archive/open-uri'

def scrape_list(url)
  warn "Getting #{url}"
  file = open(url)

  reader = PDF::Reader.new(file)
  reader.pages.each do |page|
    page.text.split("\n").each do |line|
      next unless got = line.match(/^\s*(\d+)\s{2,}(.*)\s{2,}(.*)$/)
      (id, name, party) = got.captures
      data = {
        id:     id.strip,
        name:   name.strip,
        party:  party.strip,
        area:   '',
        term:   12,
        source: url,
      }
      ScraperWiki.save_sqlite(%i(id term), data)
      puts data
    end
  end
end

scrape_list('http://www.assemblee-nationale.ga/object.getObject.do?id=190')

# archive some pages for later processing
open('http://www.assemblee-nationale.ga/34-deputes/168-bureaux-des-commissions/')
open('http://www.assemblee-nationale.ga/34-deputes/153-les-femmes-deputes/')
