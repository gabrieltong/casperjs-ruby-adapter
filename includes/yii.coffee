_ = require('./includes/underscore.min.js')
root = 'http://localhost/~gabriel/yii-ks/index.php/';
root = 'http://localhost/~soft/yii-ks/index.php/';	
class Yii extends require('casper').Casper
	constructor:(option={})->
		super(_.extend(default_option,option))
	default_option = 
		verbose:       true
		stepTimeout:   500*1000
		timeout:       500*1000
		waitTimeout:	 500*1000
		logLevel:     'debug'	
		clientScripts: ['includes/underscore.min.js','includes/jquery-1.9.1-me.js']
		pageSettings:  
			loadImages:   false
		exitOnError:   false
		viewportSize:  
			width:        1280
			height:       720
		onError:       ()->console.log('errror happen')	
	admin:
		username:'gabrieltong'
		password:'123456'
	user:
		username:'towards.test@gmail.com'
		password:'123456'
	yiiurl : 
		root:               root
		login:              root+'user/login'
		iciba:	
			menus:              root+'icibamenu/creates'
			words:              root+'icibaword/creates'
			submenus:           root+'icibasubmenu/creates'
			edgemenus:          root+'icibaedgemenu/creates'
			details:            root+'icibadetail/creates'	
			choicequestions:    root+'icibachoicequestion/creates'	
			linequestions:      root+'icibalinequestion/creates'		
			lessions:           root+'icibalession/creates'				
			lession_list:       root+'icibalession/index?IcibaLession_page='				
			toefl_lession_list: root+'icibalession/toefl?IcibaLession_page='					
			word_list:          root+'icibaword/index?IcibaWord_page='
			toeflword_list:     root+'icibaword/toefl?IcibaWord_page='
		ks:
			menus:      root+'ksmenu/creates'
			submenus:   root+'kssubmenu/creates'
			edgemenus:  root+'ksedgemenu/creates'
			categories: root+'kscategory/creates'
			exams:      root+'ksexam/creates'
			questions:      root+'ksquestion/creates'			
			exams_list: root+'ksexam/index?KsExam_page='			
			edgemenus_list: root+'ksedgemenu/index?KsEdgeMenu_page='
			categories_list: root+'kscategory/index?KsCategory_page='			
	
	login_yii:->
		@thenOpen(@yiiurl.login)
		@then ->
			form = 
				'UserLogin[username]':@admin.username
				'UserLogin[password]':@admin.password
			@fill('form',form,true)
		@then ->
			@capture 'login.png'
	p:(obj,type='debug')-> @log JSON.stringify(obj),type
	logJson:(obj,type='debug')-> @log JSON.stringify(obj),type
	json:(array)->
		@log '[json>>]','info'
		@p array,'info'
		@log '[json<<]','info'
	_save:(url,key,objects)->
		@then ->
			data = 
				method:'post'
				data:{}
			data.data[key] = JSON.stringify objects
			@thenOpen url,data,->@capture key+'.png'
	_getFromYii:(url,key) -> 
		@thenOpen url,-> @[key] = @evaluate ->
			`items = []
			$('.view').each(function(){
				items.push({
					title:$.trim($(this).find('.title').text()),
					href: $.trim($(this).find('.href').text())
				})
			})`
			items		
exports.Yii = Yii
	