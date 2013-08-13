require 'POpen4'
class K100
	def get_menus
		execute("#{command} --action=getMenus")
	end

	def get_sub_menus(href)
		execute("#{command} --action=getSubMenus --href=#{href}")
	end

	def get_edge_menus(href)
		execute("#{command} --action=getEdgeMenus --href=#{href}")
	end

	def get_categories_menus(href)
		execute("#{command} --action=getCategories --href=#{href}")
	end

	def get_exams(href)
		execute("#{command} --action=getExams --href=#{href}")
	end

	def get_questions(href)
		execute("#{command} --action=getQuestions --href=#{href}")
	end

	private

	def command
		"casperjs ./k100_command.coffee "
	end

	def execute(cmd)
		msg = []
		status = POpen4::popen4( cmd ) do |stdout, stderr, stdin|  
		  stdout.each do |line|  
		  	p line
		  	msg.push line
			end 
		end
		p msg
	end
end

K100.new.get_menus
# K100.new.get_sub_menus('http://www.kaoshi100.cn/kaoshi_85.html')