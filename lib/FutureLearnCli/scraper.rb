class FutureLearnCli::Scraper

  def self.scrape_programs(url)
    doc = Nokogiri::HTML(open(url))
    program_list = doc.css(".m-card")
    #binding.pry
    program_list.collect do |program|
      {title: program.css(".m-card__title").text.strip,
       school: program.css("div .a-item-title").text.strip,
       description: program.css(".m-card__intro").text.strip,
       num_of_courses: program.css(".m-card__metadata-label").first.text.strip,
       duration: program.css(".m-card__metadata-label").last.text.strip,
       url: program.css("a").first["href"]}
     end
   end

  def self.scrape_courses(url)
    doc = Nokogiri::HTML(open(url))
    course_list = doc.css(".m-card")
    #binding.pry
    course_list.collect do |course|
      if course.css(".m-card__metadata-label").first
        {title: course.css(".m-card__title").text.strip,
         school: course.css("div .a-item-title").text.strip,
         description: course.css(".m-card__intro").text.strip,
         duration: course.css(".m-card__metadata-label").first.text.strip,
         effort: course.css(".m-card__metadata-label").last.text.strip}
       else
         {title: course.css(".m-card__title").text.strip,
          school: course.css("div .a-item-title").text.strip,
          description: course.css(".m-card__intro").text.strip}
        end
     end
  end

end
