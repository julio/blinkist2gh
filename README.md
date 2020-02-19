# blinkist2gh

Scrape your books' blinks from blinkist and convert them to markdown files

### Prep

- Have an `mds` folder
- copy `user.conf.example` to `user.conf` and enter your real credentials in this file

### Run

- $ `ruby scraper.rb`

### Limitations

- only grabs the first 21 books (not clicking on "more" yet)
- strips out `em` and `strong` markup
