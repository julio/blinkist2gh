#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'parseconfig'
require 'pp'

def mech
  @mechanize ||= Mechanize.new
end

def prod?
  true
end

def login!
  return unless prod?

  config = ParseConfig.new('user.conf').params
  userid = config['userid']
  password = config['password']

  login_page = mech.get 'https://www.blinkist.com/nc/login'
  form = login_page.forms[0]
  form.field_with(id: 'login-form_login_email').value = userid
  form.field_with(id: 'login-form_login_password').value = password
  page = form.submit
end

def my_books
  return ['test.html'] unless prod?

  tkb_page = mech.get 'https://www.blinkist.com/en/nc/library/'
  books = []
  tkb_page.search('div[data-slug]').each do |l|
    books << l.attributes['data-slug'].to_s
  end
  books
end

def source_of_books
  return "https://www.blinkist.com/en/nc/reader" if prod?

  "file:///#{Dir.pwd}"
end

def make_markdowns!
  login!

  my_books.each do |book_name|
    book_url = "#{source_of_books}/#{book_name}"
    page = mech.get(book_url)
    open("mds/#{book_name}.md", 'w') do |f|
      page.search('div.chapter').each do |chapter|
        f.puts "# #{chapter.at('h1').child.text}"
        chapter.search('p').each do |p|
          f.puts p.text
          f.puts ""
        end
      end
    end
  end
end

make_markdowns!
