###########################
#	Nodes
##########################

nodes = null
user = null

###########################
#	Functions
##########################
pathString = ""

drawPath = (i) ->
		parent = nodes[i].parent

		if parent != 0
			posParent = "#{nodes[parent-1].x}, #{nodes[parent-1].y}"
		else
			posParent = "#{nodes[i].x}, #{nodes[i].y}"
		path = paper
			.path ""
			.data 'pathid', nodes[i].id
			.attr
				stroke: "#717171"
				fill: "transparent"
				strokeWidth: 3
				d: "M #{posParent} L #{nodes[i].x},#{nodes[i].y}"
		renderNodes(i)
			

renderNodes = (i) ->

	node = paper.circle nodes[i].x, nodes[i].y, nodes[i].size
		.attr 
			fill: nodes[i].color
			stroke: '#fff'
			strokeWidth: 2
		.data 'id', nodes[i].id - 1
		.mouseover ->
			if nodes[i].status is 1
				@stop().animate {r: nodes[i].size + 10}, 1000, mina.elastic
		.mouseout ->
			@stop().animate {r: nodes[i].size}, 300, mina.easeinout
		.click (event) ->
			id = nodes[@data 'id'].id
			window.open "../parts.html?lesson_id=#{id}"
		.touchstart ->
			alert nodes[@data 'id'].id
		.drag (dx, dy, x, y) ->
			console.log "#{x}  #{y}"
	
	text = paper.text nodes[i].x - 15, nodes[i].y + nodes[i].size + nodes[i].size / 2, nodes[i].name
	iconName = nodes[i].icon

	icon = paper.svg nodes[i].x - 15, nodes[i].y - 16, 30, 32, 0, 0, 30, 32
	
	Snap.load "images/icons/#{iconName}.svg", (iconName) ->
		icon = icon.append iconName
	
	group = paper.g node, text, icon
	$('.add').fadeOut()
	

startOperations = ->
	nodes = nodes.slice(1)
	for i in [0..nodes.length - 1]
		nodes[i].dif = Number(nodes[i].dif)
		nodes[i].id = Number(nodes[i].id)
		nodes[i].parent = Number(nodes[i].parent)
		nodes[i].path = Number(nodes[i].path)
		nodes[i].size = Number(nodes[i].size)
		nodes[i].status = Number(nodes[i].status)
		nodes[i].x = Number(nodes[i].x)
		nodes[i].y = Number(nodes[i].y)
		drawPath(i)
	for i in [0..nodes.length - 1]
		renderNodes(i)
		
		
	
	
###########################
#	Snap SVG
##########################

paper = Snap 1920, 1080
	
paper.dblclick (event) ->
	
	$('.add').css
		top: event.offsetY + 9
		left: event.offsetX + 8
	.fadeIn()
	
	$('.add-pos__x').text "X: #{event.offsetX + 9}"
	$('.add-pos__y').text "Y: #{event.offsetY + 8}"
	
	vm.$data.nodeData.x = event.offsetX + 9
	vm.$data.nodeData.y = event.offsetY + 8
	
#i = 0
#while i < nodes.length
#	renderNodes(i)
#	i++

#pathArray = []

#updatePath = ->
#	first = pathArray[0]
#	pathString = "M #{first.x},#{first.y}"
#	for node in pathArray.slice 1
#		pathString += "L #{node.x},#{node.y}"
#	path.attr d: pathString

#paper.click (event) ->
#	if event.target.tagName is 'svg' or event.target.tagName is 'path'
#		circle = paper.circle event.offsetX, event.offsetY, 30
#			.attr style
#			.data 'i', pathArray.length
#			.mouseover ->
#				@stop().animate {r:40}, 1000, mina.elastic
#			.mouseout ->
#				@stop().animate {r:30}, 300, mina.easeiinout
#			.drag ((dx, dy, x, y) ->
#				@attr
#					cx: x
#					cy: y
#				currentNode = pathArray[@data 'i']
#				currentNode.x = x
#				currentNode.y = y
#				do updatePath),
#				-> path.stop().animate {opacity: .3}, 200, mina.easeinout,
#				-> path.stop().animate {opacity: 1}, 300, mina.easeinout,
#			
#		pathArray.push
#			x: event.offsetX
#			y: event.offsetY
#			
#		updatePath()	

###########################
#	Vue
##########################

Vue.use VueResource
	
vm = new Vue
	el: "#app"
	data:
		nodeData: {}
		nodes: []
		user: 
			login: 'Default'
			avatar: 'avater.png'
	methods:
		addNode: ->
			@$http.post("includes/addNode.php?node=", @nodeData).then((res) -> 
				modalWindow(res.data);
			(error) -> 
				modalWindow('300'))
		getNodes: ->
			@$http.post("includes/getNodes.php").then((res) -> 
				@nodes = res.data
				modalWindow('203')
				nodes = @nodes
				startOperations()
			(error) -> 
				modalWindow('300'))
		getUser: ->
			@$http.post("includes/getUser.php").then((res) -> 
				console.log res.data
				if res.data is '309'
					modalWindow('309')
				else
					@user.id = Number(res.data.id)
					@user.login = res.data.login
					@user.email = res.data.email
					@user.join_date = res.data.join_date
					user = res.date
					modalWindow('204')
			(error) -> 
				modalWindow('308'))
vm.getUser()
vm.getNodes()



###########################
#	Static elements
##########################

$('.left-slide').height($(window).height())

active = 0
$('.left-slide').hide()
$('.bar-circle').on 'click', ->
	if active == 0 
		$('.left-slide').animate {left: "0px"}, 600
		$('.left-slide').show()
		active = 1
	else 
		$('.left-slide').animate {left: "-300px"}, 600, ->
			$('.left-slide').hide()
		active = 0

profileActive = 0

$('.profile__avatar').on 'click', ->
	if profileActive is 0
		$('.profile-stats').animate
			width: '300px',
			500,
			->
				$('.profile-stats__money').fadeIn().css
					display: 'inline-block'
				$('.profile-stats__name').fadeIn().css
					display: 'inline-block'
				profileActive = 1
	else
		$('.profile-stats__money').fadeOut().css
			display: 'inline-block'
		$('.profile-stats__name').fadeOut().css
			display: 'inline-block'
		$('.profile-stats').animate
			width: '60px',
			500,
			->
				profileActive = 0

status = null			
				
$('.add-active__left').on 'click', ->
	$(this).addClass 'add-active__select'
	$('.add-active__right').removeClass 'add-active__select'
	status = true
	
$('.add-active__right').on 'click', ->
	$(this).addClass 'add-active__select'
	$('.add-active__left').removeClass 'add-active__select'
	status = false

$('.add__button').on 'click', ->
	
	if $('.add-name__input').val() is ''
		alert 'Введите имя'
		return
	
	if status is null 
		alert 'Выберите активность'
		return
	else if status is false 
			vm.nodeData.status = false
		else
			vm.nodeData.status = true
	
	if $('.add-parent__input').val() is ''
		alert 'Вы не указали родителя'
		return
	
	if $('.add-path__input').val() is ''
		alert 'Вы не указали какой урок будет загружаться.'
		return
	
	if $('.add-color__input').val() is ''
		alert 'Вы не ввели цвет ноды. Будет установлен чёрный цвет (по умолчанию)'
		vm.nodeData.color = '#000'
	
	if $('.add-size__input').val() is ''
		alert 'Вы не ввели размер ноды. Будет установлен размер 20 (по умолчанию)'
		vm.nodeData.size = 20

	if $('.add-dif__input').val() is ''
		alert 'Вы не указали сложность. Будет установлен 1 (по умолчанию)'
		vm.nodeData.dif = 1
	
	vm.addNode()

$('.add__exit').on 'click', ->
	$('.add').fadeOut()
	

	
modalWindow = (value) ->
	switch value
				
		when '200'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text("Пользователь: #{vm.$data.register.login} успешно зарегистрирован!");
			$('.modal-window').css
				background: 'rgba(187, 255, 179, 0.95)'
				
		when '201'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text("Пользователь: #{vm.$data.login.login} успешно авторизирован!");
			$('.modal-window').css
				background: 'rgba(187, 255, 179, 0.95)'
			
		when '202'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text("Нода с именем: #{vm.$data.nodeData.name} успешно добавлена.");
			$('.modal-window').css
				background: 'rgba(187, 255, 179, 0.95)'
			
		when '203'
			nodes = vm.nodes
			$('.modal-window').fadeIn();
			$('.modal-window__text').text("Все ноды успешно загружены.");
			$('.modal-window').css
				background: 'rgba(187, 255, 179, 0.95)'
			
		when '204'
			nodes = vm.nodes
			$('.modal-window').fadeIn();
			$('.modal-window__text').text("Данные пользователя успешно получены.");
			$('.modal-window').css
				background: 'rgba(187, 255, 179, 0.95)'
			console.log vm.user
				
		when '300'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Возникла ошибка при отправке запроса на регистрацию! Проверьте соединение с интернетом или повторите попытку позже.');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '301'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Возникла ошибка при регистрации пользователя! Пользователь с таким логином или почтой уже зарегистрирован!');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '302'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Возникла ошибка при отправке запроса на авторизацию пользователя! Проверьте соединение с интернетом или повторите попытку позже.');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '303'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Пользователь с таким логином не найден!');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '304'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Пароль введён не верно!');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'	
			
		when '305'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Нода с таким именем уже существует.');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '306'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Урок указанный на ноду уже используется.');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '307'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Возникла ошибка при отправке запроса на добавление ноды! Проверьте соединение с интернетом или повторите попытку позже.');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '308'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Возникла ошибка при отправке запроса на получения данных пользователя! Проверьте соединение с интернетом или повторите попытку позже.');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
				
		when '309'
			$('.modal-window').fadeIn();
			$('.modal-window__text').text('Сессия не найдена. Авторизируйтесь повторно.');
			$('.modal-window').css
				background: 'rgba(255, 130, 130, 0.95)'
	
	setTimeout( -> 
			   $('.modal-window').fadeOut();
		, 3000);


