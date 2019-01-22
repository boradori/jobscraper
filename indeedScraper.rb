require 'httparty'
require 'nokogiri'
require 'byebug'

def scraper # job_title, job_location
    title = ARGV[0].split(' ').join('+')
    location = ARGV[1].split(' ').join('+')
    
    # url = "https://www.indeed.com/jobs?q=#{title}&l=#{location}&start=00"
    # unparsed_page = HTTParty.get(url)
    # parsed_page = Nokogiri::HTML(unparsed_page)
    # job_listings = parsed_page.css('div.jobsearch-SerpJobCard')

    next_button = "Next »"
    page = 0
    jobs = []

    while next_button == "Next »"
        pagination_url = "https://www.indeed.com/jobs?q=#{title}&l=#{location}&start=#{page}0"

        pagination_unparsed_page = HTTParty.get(pagination_url)
        pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
        pagination_job_listings = pagination_parsed_page.css('div.jobsearch-SerpJobCard')

        pagination_job_listings.each do |job_listing|
            job = {
                title: job_listing.css('a')[0].attributes['title'].value,
                company: job_listing.css('span.company')[0].text.split(' ').join(' '),
                location: job_listing.css('div.location').text,
                url: "https://www.indeed.com" + job_listing.css('a')[0].attributes['href'].value
            }

            jobs << job
            puts "Added #{job[:title]}"
        end

        if pagination_parsed_page.css('span.np').last == nil
            break
        else
            next_button = pagination_parsed_page.css('span.np').last.text
            page += 1
        end
    end
    byebug

end

scraper
# scraper "associate software engineer", "Seattle, WA"