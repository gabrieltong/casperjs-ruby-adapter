Yii = require('./includes/yii.coffee').Yii
_ = require('./includes/underscore.min.js')
root = 'http://www.kaoshi100.cn/'
class K100 extends Yii
	constructor:(option)->
		super(option)
	menus 		: [],
	subMenus  : [],
	edgeMenus : [],
	categories: [],
	exams 		: [],
	url:
		root:root
		login:root+'users/login'
		logout:root+'Users/Logout'
		list:root+'kaoshi'
		
	user:
		username:'towards.test@gmail.com'
		password:'123456'
	injectJQ:->
		@page.injectJs('./includes/jquery-1.9.1-me.js')
	login:-> 
		@then -> @open @url.root
		@then -> @injectJQ()
		@then ->
			@waitForSelector '#examlogin', -> @click('#examlogin')
		@then -> @waitForSelector '#ptxtUserName',->
			@evaluate -> 
				user =
					username:'towards.test@gmail.com'
					password:'123456'
				user
				jQ('#ptxtUserName').val(user.username)
				jQ('#ptxtPwd').val(user.password)
				jQ('#btnLogin').click()	
				user
			# @wait 3000,-> @capture 'after.png'
	logout:->
		@thenOpen ->
	# evaluate_login:(user)->
		# @p [1,2,3]
		# @waitForSelector '#ptxtUserName',->
		# 	jQ('#ptxtUserName').val(user.username)
		# 	jQ('#ptxtPwd').val(user.password)
		# 	jQ('#btnLogin').click()
		# @then ->
		# 	@capture 'login.png'
	getMenus:-> 
		@thenOpen @url.root,->
			@injectJQ()
			@waitForSelector '#menuhidelist a', ->
				@menus = @evaluate ->
					items = []
					jQ('#menuhidelist a').each ->
						item = 
							href:jQ(this).attr('href'),
							title:jQ(this).text()
						items.push(item)
					items
				@menus = _.map @menus,(item)=>
					item.href = (@url.root + item.href).replace('.cn//','.cn/')
					item
		@then -> 
			@json @menus
	getSubMenus:(href)-> @then ->
		@subMenus = []
		@thenOpen href,->
			@then -> @injectJQ()
			@then ->
				subMenus = @evaluate ->
					items = []
					jQ('.exams div').each ->
						item = 
							href:jQ(this).find('a').eq(0).attr('href')
							title:jQ(this).find('a').eq(1).text()
							img:jQ(this).find('a').eq(0).find('img').attr('src')
						items.push item
					items
				subMenus = _.map subMenus,(item)=>
					item.href = (@url.root + item.href).replace('.cn//','.cn/')
					item.parent_href = href
					item.img = (@url.root + item.img).replace('.cn//','.cn/')
					item
				@subMenus = _.union @subMenus , subMenus
		@then ->
			@json @subMenus
	getEdgeMenus:(href)-> @then ->
		@edgeMenus = []
		@thenOpen href
		@then -> @injectJQ()
		@then -> 
			edgeMenus = @evaluate ->
				items = []
				jQ('.subjects a').each ->
					item = 
						href:jQ(this).attr('href')
						title:jQ(this).attr('title')
					items.push item
				items
			edgeMenus = _.map edgeMenus,(item)=>
				item.href = (@url.root + item.href).replace('.cn//','.cn/')
				item.parent_href = href					
				item
			@edgeMenus = _.union @edgeMenus,edgeMenus
		@then ->	
			@json @edgeMenus
	getCategories:(href)-> @then ->
		@categories = []
		@thenOpen href
		@then -> @injectJQ()
		@then ->
			categories = @evaluate ->
				items = []
				jQ('#ulTabs li:not(:first)').each ->
					item = 
						title:jQ(this).text()
						href:jQ(this).attr('url')
					items.push item
				items
			categories = _.map categories,(item)=>
				item.href = (@url.root + item.href).replace('.cn//','.cn/')
				item.parent_href = href					
				item	
			@categories = _.union @categories,categories
		@then ->	
			@json @categories
	getExams:(href)-> @then ->
		@exams = []
		@thenOpen href
		@then -> @injectJQ()
		@then ->
			pager = @evaluate ->
				items = []
				jQ('.pager a').each ->
					attr = jQ(this).attr('href')
					if typeof attr isnt 'undefined' and attr isnt false
						items.push attr	
				items
			pager = _.map pager,(page)=>
				page = (@url.root + page).replace('.cn//','.cn/')
				page
			pager = _.union [href],pager
			_.each pager,(page)=>
				@thenOpen page
				@then -> @injectJQ()
				@then ->
					exams = @evaluate ->
						items = []
						jQ('table.rt_table').each ->
							item = 
								title:jQ(this).find('tr:first td:first a').text()
								href:jQ(this).find('tr:first td:first a').attr('href')
								total:jQ(this).find('tr:eq(1) td:first span').text()
							items.push item
						items
					exams = _.map exams,(exam)=>
						exam.href = (@url.root + exam.href).replace('.cn//','.cn/')
						exam.parent_href = href
						exam
					@exams = _.union @exams,exams
		@then ->	
			@json @exams
	getQuestions:(href)->@then ->
		@questions = []
		@then -> @open href
		@then -> @injectJQ()
		@waitForSelector '.btn_exercise',-> @click '.btn_exercise'
		# @then -> @capture 'aaa.png'
		@waitForSelector '.arNormal',->
			@then -> @injectJQ()				
			_.each [2..(@count('.arNormal')+1)],(index)=>
				@waitForSelector '#question_'+(index-1),-> @clickLabel(index, 'li')
		@waitForSelector '#question_'+(@count('.arNormal')+1),-> 
			questions = @evaluate -> 
				items = []
				jQ(".question div").each ->
					title = jQ(this).find('h4').text()
					item = 
						title:title
						choices:[]
						answer_text:jQ(this).find('h5:first').text()
						description:jQ(this).find('h5:last').text()							
					jQ(this).find("ul li").each ->
						item.choices.push jQ(this).text()
					items.push item
				items
			questions = _.map questions , (item)=>
				item.parent_href = href
				item
			@questions = _.union @questions,questions
		@then ->	
			@json @questions
	evaluate_count:(selector)-> __utils__.findAll(selector).length
	evaluate_click:(index)-> $(' li').eq(index).click()
	count:(selector)->@evaluate(@evaluate_count,selector)
	getQuestionsByExam:(url)-> @then ->
		@log 'get questions by exam'
	getExamsByCategory:(url)-> @then ->
		@log 'get exams by category'
	saveMenus:     ->@then ->@_save @yiiurl.ks.menus,'KsMenus',@menus
	saveSubMenus:  ->@then ->@_save @yiiurl.ks.submenus,'KsSubMenus',@subMenus	
	saveEdgeMenus: ->@then ->@_save @yiiurl.ks.edgemenus,'KsEdgeMenus',@edgeMenus		
	saveCategories:->@then ->@_save @yiiurl.ks.categories,'KsCategories',@categories			
	saveExams:     ->@then ->@_save @yiiurl.ks.exams,'KsExams',@exams
	saveQuestions:   ->@then ->@_save @yiiurl.ks.questions,'KsQuestions',@questions		
	getEdgeMenusFromYii:(index)-> @_getFromYii (@yiiurl.ks.edgemenus_list+index),'edgeMenus'
	getCategoriesFromYii:(index)-> @_getFromYii (@yiiurl.ks.categories_list+index),'categories'
	getExamsFromYii:(index)-> @_getFromYii (@yiiurl.ks.exams_list+index),'exams'	
	fetchAll:->
		@then -> @fetchAllMenus()
		@then -> @fetchCategories()
		@then -> @fetchExams()		
	fetchAllMenus:->
		@getMenus()
		@saveMenus()		
		@getSubMenus()
		@saveSubMenus()		
		@getEdgeMenus()
		@saveEdgeMenus()
	fetchCategories:->_.each [1..34],(index)=>@then ->
		@log 'fetchCategories index:'+index
		@getEdgeMenusFromYii(index)
		@getCategories()
		@saveCategories()
	fetchExams:->_.each [1..115],(index)=>@then ->
		@log 'fetchExams index:'+index		
		@getCategoriesFromYii(index)
		@getExams()
		@saveExams()
	fetchQuestions:(range)-> @then -> _.each range,(index)=>@then ->
		@getExamsFromYii(index)
		@getQuestions()
		@saveQuestions()
exports.K100 = K100