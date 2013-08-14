require 'POpen4'
require 'json'
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
		i = 0
		json_index = 0
		status = POpen4::popen4( cmd ) do |stdout, stderr, stdin|  
		  stdout.each do |line|  
		  	# p line
		  	msg.push line
		  	i+=1
		  	json_index = i if line.include?'json>>'
			end 
		end
		# p json_index
		# p msg[json_index].split('[phantom]')[1].rstrip.gsub(/ /,'')
		p JSON.parse(msg[json_index].split('[phantom]')[1].rstrip.gsub(/ /,''))
	end

	# def execute(cmd)
	# 	system(cmd)
	# end
end

# K100.new.get_menus
# K100.new.get_sub_menus('http://www.kaoshi100.cn/kaoshi_85.html')