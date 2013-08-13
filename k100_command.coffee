
K100 = require('./includes/k100.coffee').K100
k100 = new K100
k100.start()
action = k100.cli.options['action']
href = k100.cli.options['href']
switch action
  when "getMenus" then k100.getMenus()
  when "getSubMenus" then k100.getSubMenus(href)
  when "getEdgeMenus" then k100.getEdgeMenus(href)
  when "getCategories" then k100.getCategories(href)
  when "getExams" then k100.getExams(href)
  when "getQuestions" 
  	k100.login()
  	k100.getQuestions(href)
  else 

# k100.getMenus()
# k100.getSubMenus('http://www.kaoshi100.cn/kaoshi_85.html')
# k100.getEdgeMenus('http://www.kaoshi100.cn/kaoshi/list_8520_0_1.html')
# k100.getCategories('http://www.kaoshi100.cn/kaoshi/list_852001_0_1.html')
# k100.getExams('http://www.kaoshi100.cn/kaoshi/list_200201_0_1.html')
# k100.login()
# k100.getQuestions('http://www.kaoshi100.cn/kaoshi/exam_201207031804467652500d1-7ca4a10544b9.html')
k100.run()


# create_instance(104,1000)