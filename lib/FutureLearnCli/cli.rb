class FutureLearnCli::Cli

  BASE_URL = "https://www.futurelearn.com/"
  PROGRAMS_URL = "https://www.futurelearn.com/programs"

  def run #Program start
    system "clear"
    get_programs
    display_programs
    select_action
  end

  def get_programs
    programs = FutureLearnCli::Scraper.scrape_programs(PROGRAMS_URL)
    FutureLearnCli::Program.create_from_collection(programs)
  end

  def get_courses(prog_num)
    FutureLearnCli::Program.all[prog_num-1].courses ||= FutureLearnCli::Course.create_from_collection(FutureLearnCli::Scraper.scrape_courses(BASE_URL + FutureLearnCli::Program.all[prog_num-1].url))
  end

  def display_programs
    puts "Unfortunately, it seems that there are no upcoming programs on EdX." if FutureLearnCli::Program.all.count == 0
    FutureLearnCli::Program.all.each.with_index do |program, i|
      if i < 9
        puts "#{i+1}.  Title: #{program.title}"
      else
        puts "#{i+1}. Title: #{program.title}"
      end
      puts "    School: #{program.school}"
      puts "    Courses: #{program.num_of_courses}"
      puts "    Duration: #{program.duration}"
      puts
    end
  end

  def display_courses(courses)
    system "clear"
    puts "Apparently there are no courses for this program or an error occured." if courses.count == 0
    courses.each.with_index do |course, i|
      if i < 9
        puts "#{i+1}.  Title: #{course.title}"
      else
        puts "#{i+1}. Title: #{course.title}"
      end
      if course.duration && course.effort
        puts "    School: #{course.school}"
        puts "    Duration: #{course.duration}"
        puts "    Effort: #{course.effort}"
      end
      puts "    Description: #{course.description}"
      puts
    end
  end

  def select_action
    message = "Type program number for details, 'list' to relist programs or 'exit' to leave"
    loop do
      puts message
      input = gets.strip
      case input
      when "list"
        display_programs
        message = "Type program number for details, 'list' to relist programs or 'exit' to leave"
      when "exit"
        break
      else
        if message == "Type program number for details, 'list' to relist programs or 'exit' to leave" && (1..FutureLearnCli::Program.all.count).include?(input.to_i)
          courses = get_courses(input.to_i)
          display_courses(courses)
          message = "Type 'list' to relist programs or exit to leave the program"
        end
      end
    end
  end

end
