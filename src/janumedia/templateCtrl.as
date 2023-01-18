import flash.filters.DropShadowFilter;
import janumedia.fms.BandwithManager;
class janumedia.templateCtrl extends MovieClip {
	var mainLeft, mainRight, bgLeft, bgRight, bgActive, spliterLeft, spliterRight, addSpace, recordingStatus, lastMC:MovieClip;
	var meeting_menu, present_menu, layout_menu, pods_menu, con_menu, cam_menu, help_menu:MovieClip;
	var meeting_data, meeting_data2:Array;
	var activeBtn:MovieClip;
	var templateList, templateBtnList:Array;
	var podList, currentActiveTemplate:Object;
	var intervalID:Number;
	var owner, data:Object;
	var so;
	//:SharedObject;
	var nc:NetConnection;
	var ns:NetStream;
	var ns_r:NetStream;
	var cam:Camera;
	var mic:Microphone;
	var bwManager:BandwithManager;
	function templateCtrl () {
		_global.templateCtrl = this;
		bwManager = new BandwithManager ();
		bwManager.setRates (10000, 10000);
		Stage.addListener (this);
		lastMC = spliterLeft;
		// menubar
		_global.tt ("[Template] my mode is : " + _global.userMode);
		if (_global.userMode > 1) {
			//this.attachMovie("Menu", "meeting_menu", 50);
			this.attachMovie ("Menu", "con_menu", 52);
			this.attachMovie ("Menu", "cam_menu", 53);
			this.attachMovie ("Menu", "help_menu", 54);
		} else {
			this.attachMovie ("Menu", "meeting_menu", 50);
			//this.attachMovie("Menu", "present_menu", 51);
			this.attachMovie ("Menu", "con_menu", 52);
			this.attachMovie ("Menu", "cam_menu", 53);
			this.attachMovie ("Menu", "layout_menu", 54);
			this.attachMovie ("Menu", "pods_menu", 55);
			this.attachMovie ("Menu", "help_menu", 56);
		}
		// menubar
		var menuBarList:Array = new Array();
		if(_global.userMode > 1){
			menuBarList	 = [
							//{label:"Meetings",target:meeting_menu},
							{label:"Bandwidth",target:con_menu},
							{label:"Camera & Voice",target:cam_menu},
							{label:"Help",target:help_menu}
						];
		} else {
			menuBarList = [
							{label:"Meetings",target:meeting_menu},
							//{label:"Present",target:present_menu},
							{label:"Bandwidth",target:con_menu},
							{label:"Camera & Voice",target:cam_menu},
							{label:"Layout",target:layout_menu},
							{label:"Pods",target:pods_menu},
							{label:"Help",target:help_menu}
						];
		}
		// pods
		_global.podList = podList = {sharedWindow:{id:0, title:"Share Window"}, videoAudio:{id:1, title:"Video and Voice"}, peopleList:{id:2, title:"People List"}, chatBox:{id:3, title:"Chat Box"}, files:{id:4, title:"File Share"}, poll:{id:5, title:"Polling"}, note:{id:6, title:"note"}, discussionNote:{id:7, title:"Discussion Note"}};
		// begin menu
		for (var i = 0; i < menuBarList.length; i++) {
			var mc:MovieClip = this.createEmptyMovieClip (menuBarList[i].label, 30 + i);
			mc.createTextField ("label", 1, 0, 0, 2, 2);
			var fmt:TextFormat = new TextFormat ();
			fmt.font = "Verdana";
			fmt.size = 10;
			mc.label.setNewTextFormat (fmt);
			mc.label.autoSize = true;
			mc.selectable = false;
			mc.label.text = menuBarList[i].label;
			drawBox (mc, mc._width, mc._height);
			mc._y = this._x - spliterLeft._height + 2;
			mc._x = i > 0 ? this[menuBarList[i - 1].label]._x + this[menuBarList[i - 1].label]._width + 10 : spliterLeft._x + 10;
			mc.menuname = menuBarList[i].target;
			mc.onPress = function () {
				this.menuname.show (this._x, this._parent.height);
			};
			lastMC = mc;
		}
		var hasDriver:Boolean = false;
		for (var i = 0; i < Camera.names.length; i++) {
			if (Camera.names[i] == "VHScrCap") {
				hasDriver = true;
				break;
			}
		}
		// menu data
		meeting_data = [
						{label:"Invite Participant", data:{type:"url", link:"administrators.php?&p=usergroup&do=newuser"}, type:"check", selected:false},
						{label:"Record Meeting", data:{type:"function", data:"recordMeeting"}, type:"check", selected:false, enabled:hasDriver ? true : false},
						{label:"End Meeting", data:{type:"function", data:"endMeeting"}, type:"check", selected:false}, {label:"spacer"},
						{label:"Fullscreen", data:{type:"function", data:"onFullScreen"}, type:"check", selected:false}];
		meeting_data2 = [
						 {label:"Invite Participant", data:{type:"url", link:"administrators.php?&p=usergroup&do=newuser"}, type:"check", selected:false},
						 {label:"Stop Record Meeting", data:{type:"function", data:"stopRecording"}, type:"check", selected:false, enabled:hasDriver ? true : false},
						 {label:"End Meeting", data:{type:"function", data:"endMeeting"}, type:"check", selected:false}, {label:"spacer"},
						 {label:"Fullscreen", data:{type:"function", data:"onFullScreen"}, type:"check", selected:false}];
		/*var present_data:Array = [
		{label:"My Meetings", data:{type:"url",link:"administrators.php?navid=meetings&p=mm"}, type:"check", selected:false},
		{label:"My Events", data:{type:"url",data:"administrators.php?navid=events&p=mm"}, type:"check", selected:false},
		{label:"My Contents", data:{type:"function",data:"showContentBrowser"}, type:"check", selected:false},
		{label:"My Presentations", data:{type:"function",data:"showPresentationBrowser"}, type:"check", selected:false}
		];*/
		if (_global.userMode < 2) {
			var con_data:Array = [
								  {label:"Modem", data:{type:"function", data:"onBandwidthOption", value:0}, type:"check", selected:false},
								  {label:"DSL", data:{type:"function", data:"onBandwidthOption", value:1}, type:"check", selected:false},
								  {label:"LAN", data:{type:"function", data:"onBandwidthOption", value:2}, type:"check", selected:true},
								  {label:"spacer"},
								  {label:"Room Bandwidth Statistics", data:{type:"function", data:"onRoomBWStatistics"}, type:"check", selected:false},
								  {label:"My Bandwidth Statistics", data:{type:"function", data:"onMyBWStatistics"}, type:"check", selected:false}
								  ];
		}else {
			var con_data:Array = [
								  {label:"Modem", data:{type:"function", data:"onBandwidthOption", value:0}, type:"check", selected:false},
								  {label:"DSL", data:{type:"function", data:"onBandwidthOption", value:1}, type:"check", selected:false},
								  {label:"LAN", data:{type:"function", data:"onBandwidthOption", value:2}, type:"check", selected:true},
								  {label:"spacer"},
								  {label:"My Bandwidth Statistics", data:{type:"function", data:"onMyBWStatistics"}, type:"check", selected:false}
								  ];
		}
		var cam_data:Array = [
							  {label:"Select Camera", data:{type:"function", data:"showCameraOption"}, type:"check", selected:false},
							  {label:"Force on Quality", data:{type:"function", data:"onCameraQuality", value:true, id:1}, type:"check", selected:false},
							  {label:"Force on Performance", data:{type:"function", data:"onCameraQuality", value:false, id:2}, type:"check", selected:true},
							  {label:"spacer"},
							  {label:"11 Khz", data:{type:"function", data:"onVoiceRate", value:11, id:4}, type:"check", selected:false}, 
							  {label:"22 Khz", data:{type:"function", data:"onVoiceRate", value:22, id:5}, type:"check", selected:true},
							  {label:"44 Khz", data:{type:"function", data:"onVoiceRate", value:44, id:6}, type:"check", selected:false}];
		var layout_data:Array = [
								 {label:"Sharing", data:{type:"function", data:"onSelectTemplate", id:0}, type:"check", selected:false},
								 {label:"Discussion", data:{type:"function", data:"onSelectTemplate", id:1}, type:"check", selected:false},
								 {label:"Collaboration", data:{type:"function", data:"onSelectTemplate", id:2}, type:"check", selected:false},
								 {label:"Presentation", data:{type:"function", data:"onSelectTemplate", id:3}, type:"check", selected:false}];
		var pods_data:Array = [
							   {label:"Share Window", data:{type:"function", data:"onPodOption", podname:"sharedWindow"}, type:"check", selected:false},
							   {label:"Camera and Voice", data:{type:"function", data:"onPodOption", podname:"videoAudio"}, type:"check", selected:false},
							   {label:"Participants", data:{type:"function", data:"onPodOption", podname:"peopleList"}, type:"check", selected:false},
							   {label:"Chat Box", data:{type:"function", data:"onPodOption", podname:"chatBox"}, type:"check", selected:false},
							   {label:"File Share", data:{type:"function", data:"onPodOption", podname:"files"}, type:"check", selected:false},
							   {label:"Polling", data:{type:"function", data:"onPodOption", podname:"poll"}, type:"check", selected:false},
							   {label:"Note", data:{type:"function", data:"onPodOption", podname:"note"}, type:"check", selected:false},
							   {label:"Discussion Note", data:{type:"function", data:"onPodOption", podname:"discussionNote"}, type:"check", selected:false}];
		var help_data:Array = [
							   {label:"Help", data:"meeting", type:"check", selected:false},
							   {label:"About", data:{type:"url", data:""}, type:"check", selected:false}];
		meeting_menu.headerLabel = "Meetings Preference";
		//present_menu.headerLabel = "Presentations Setup";
		con_menu.headerLabel = "Bandwidth Option";
		cam_menu.headerLabel = "Camera and Voice Settings";
		layout_menu.headerLabel = "Layout Template";
		pods_menu.headerLabel = "Pods Library";
		help_menu.headerLabel = "Help / Documentation";
		meeting_menu.dataProvider = meeting_data;
		//present_menu.dataProvider = present_data;
		con_menu.dataProvider = con_data;
		cam_menu.dataProvider = cam_data;
		layout_menu.dataProvider = layout_data;
		pods_menu.dataProvider = pods_data;
		help_menu.dataProvider = help_data;
		meeting_menu.addListener ("click", onMenu, this);
		//present_menu.addListener("click", onMenu, this);
		con_menu.addListener ("click", onMenu, this);
		cam_menu.addListener ("click", onMenu, this);
		layout_menu.addListener ("click", onMenu, this);
		pods_menu.addListener ("click", onMenu, this);
		help_menu.addListener ("click", onMenu, this);
		// template data
		var template1:Object = {title:"Sharing", data:[[{type:"videoAudio", title:"Camera and Voice", w:160, h:170}, {type:"peopleList", title:"Participants", w:160, h:235}, {type:"chatBox", title:"Chat Box", w:160, h:150}], [{type:"sharedWindow", title:"Share Window", w:585, h:410}, {type:"files", title:"Files Shared", w:385, h:150}, {type:"note", title:"Note", w:195, h:150, child:true}]]};
		var template2:Object = {title:"Discussion", data:[[{type:"peopleList", title:"Participants", w:160, h:415}, {type:"note", title:"Note", w:160, h:150}], [{type:"videoAudio", title:"Camera and Voice", w:300, h:300}, {type:"chatBox", title:"Chat Box", w:300, h:265}], [{type:"poll", title:"Polling", w:280, h:260}, {type:"discussionNote", title:"Discussion Note", w:280, h:305}]]};
		var template3:Object = {title:"Collaboration", data:[[{type:"videoAudio", title:"Camera and Voice", w:160, h:170}, {type:"peopleList", title:"Participants", w:160, h:235}, {type:"note", title:"Note", w:160, h:150}], [{type:"sharedWindow", title:"Share Window", w:585, h:395}, {type:"chatBox", title:"Chat Box", w:290, h:165}, {type:"files", title:"Files Shared", w:290, h:165, child:true}]]};
		var template4:Object = {title:"Presentation", data:[[{type:"videoAudio", title:"Camera and Voice", w:160, h:170}, {type:"peopleList", title:"Participants", w:160, h:235}, {type:"chatBox", title:"Chat Box", w:160, h:140}], [{type:"sharedWindow", title:"Share Window", w:586, h:555}]]};
		templateList = new Array (template1, template2, template3, template4);
		//"Sharing","Discussion","Colaboration Session");
		templateBtnList = new Array ();
		addItem (templateList);
		//this._x = 4;
		this._y = mainLeft._height;
		onResize ();
		// fms
		var owner = this;
		nc = _global.nc;
		nc.initTemplate = function () {
			var i:templateCtrl = owner;
			i.initTemplate ();
		};
		nc.loadTemplate = function (id:Number, data:Object) {
			var i:templateCtrl = owner;
			i.applyTemplate (id, data);
			//loadTemplate;
		};
		so = _global.layout_so;
		so.applyTemplate = function (id:Number, data:Object) {
			var a:templateCtrl = owner;
			a.applyTemplate (id, data);
		};
		so.openPod = function (o:Object) {
			var p:templateCtrl = owner;
			p.openPod (o);
		};
		so.closePod = function (id:Number) {
			var c:templateCtrl = owner;
			c.closePod (id);
		};
	}
	// menu
	function onMenu (evt) {
		switch (evt.data.type) {
		case "function" :
			this[evt.data.data] (evt, evt.target.selected ? false : true);
			break;
		case "url" :
			evt.target.selected = false;
			this.getURL (_global.host + evt.data.link, "_blank");
			break;
		}
	}
	function recordMeeting (record:Boolean) {
		_global.tt("[Template] recordMeeting");
		var getStreamDuration_callback:Function = function (owner:MovieClip) {
			this.owner = owner;
			this.onResult = function (recstreamname:String) {
				this.owner.startRecording (recstreamname);
				_global.application.startRecording (recstreamname);
			};
		};
		nc.call ("startRecording", new getStreamDuration_callback (this));
	}
	function startRecording (s:String) {
		_global.tt("[Template] startRecording");

		/*
		mic = new Microphone();
		mic = Microphone.get();
		//mic.setSilenceLevel(30, 1000);
		cam = new Camera();
		cam = Camera.get(getScreenCaptureDriver());
		//_global.tt(cam.name);
		//cam.setMotionLevel(30, 2000);
		cam.setMode(System.capabilities.screenResolutionX*0.90,System.capabilities.screenResolutionY*0.90,12,true);
		cam.setQuality(120000, 0);
		ns.close();
		ns = new NetStream(nc);
		ns.attachVideo(cam);
		ns.attachAudio(mic);
		ns.publish(s, "record");
		
		ns.onStatus = function(info){
		_global.tt(info.code);
		}
		//_global.tt("___record to : "+nc.uri);
		/*ns_r.close();
		ns_r = new NetStream(nc);
		ns_r.play(s,0);
		*/
		//_global.application.startRecording(s);
		this.attachMovie ("recordingStatus", "recordingStatus", 10);
		recordingStatus._x = addSpace._x + addSpace._width;
		meeting_menu.dataProvider = meeting_data2;
	}
	function stopRecording () {
		_global.tt("[Template] stopRecording");
		recordingStatus.removeMovieClip ();
		meeting_menu.dataProvider = meeting_data;
		_global.application.stopRecording ();
		nc.call ("stopRecording", null);
	}
	function endMeeting () {
		_global.tt("[Template] endMeeting");
		nc.call ("endMeeting", null);
	}
	function onRoomBWStatistics (o:Object, showStats:Boolean) {
		_global.tt("[Template] onRoomBWStatistics");
		o.target.selected = false;
		if (showStats) {
			_global.bwMonitor.hide ();
		} else {
			_global.bwMonitor.show ("room");
		}
	}
	function onMyBWStatistics (o:Object, showStats:Boolean) {
		_global.tt("[Template] onMyBWStatistics");
		o.target.selected = false;
		if (showStats) {
			_global.bwMonitor.hide ();
		} else {
			_global.bwMonitor.show ("mine");
		}
	}
	function onFullScreen (o:Object, fullscreen:Boolean) {
		_global.tt("[Template] onFullScreen");
		if (fullscreen) {
			// browser based
			this.getURL ("javascript:setFullscreen(false)");
			// projector based
			fscommand ("fullscreen", false);
		} else {
			// browser based
			this.getURL ("javascript:setFullscreen(true)");
			// projector based
			fscommand ("fullscreen", true);
		}
	}
	function onBandwidthOption (o:Object) {
		_global.tt("[Template] onBandwidthOption",o.data.value);
		for (var i = 0; i < 3; i++) {
			con_menu.UISpace.rowSpace["label" + i].selected = false;
		}
		con_menu.UISpace.rowSpace["label" + o.data.value].selected = true;
		switch (o.data.value) {
			// modem
		case 0 :
			bwManager.setRates (33, 33);
			break;
			// dsl
		case 1 :
			bwManager.setRates (128, 512);
			break;
			// lan
		case 2 :
			bwManager.setRates (10000, 10000);
			break;
		}
	}
	function showCameraOption () {
		System.showSettings (3);
	}
	function onCameraQuality (o:Object) {
		_global.tt("[Template] onCameraQuality");
		for (var i = 1; i <= 2; i++) {
			cam_menu.UISpace.rowSpace["label" + i].selected = false;
		}
		cam_menu.UISpace.rowSpace["label" + o.data.id].selected = true;
		bwManager.setCameraQuality (o.data.value);
	}
	function onVoiceRate (o:Object) {
		_global.tt("[Template] onVoiceRate");
		for (var i = 4; i <= 6; i++) {
			cam_menu.UISpace.rowSpace["label" + i].selected = false;
		}
		cam_menu.UISpace.rowSpace["label" + o.data.id].selected = true;
		bwManager.setMicQuality (o.data.value);
	}
	function showPresentationBrowser (o:Object) {
		_global.tt("showPresentationBrowser");
		o.target.selected = false;
		_global.contentBrowser.hide ();
		_global.presentationBrowser.openMyPresentation ();
	}
	function showContentBrowser (o:Object) {
		o.target.selected = false;
		_global.presentationBrowser.hide ();
		_global.contentBrowser.openMyContent ();
	}
	function onSelectTemplate (o:Object) {
		changeTemplate (o.data.id, templateList[o.data.id].data);
	}
	function onPodOption (o:Object, selected:Boolean) {
		if (selected) {
			nc.call ("closePod", null, _global.podList[o.data.podname].id);
			//_global.path["pod_"+_global.podList[o.data.podname].id].removeMovieClip();
		} else {
			nc.call ("openPod", null, {podname:o.data.podname, id:_global.podList[o.data.podname].id, title:_global.podList[o.data.podname].title});
			//_global.application.openPod( {podname:o.data.podname, id:_global.podList[o.data.podname].id, title:_global.podList[o.data.podname].title} );
		}
	}
	function openPod (o:Object) {
		_global.tt ("[Template] openpod id " + o.id);
		_global.application.openPod (o);
		pods_menu.UISpace.rowSpace["label" + o.id].selected = true;
	}
	function closePod (id:Number) {
		_global.tt ("[Template] closepod id " + id);
		_global.path["pod_" + id].removeMovieClip ();
		pods_menu.UISpace.rowSpace["label" + id].selected = false;
	}
	function onResize () {
		//this._y = Stage.height - 6;
		mainRight._x = Stage.width - mainRight._width;
		// - 8;
		//this.maithis._x - nRight._x = this.spliterRight._x + this.spliterRight._width;
		addSpace._x = spliterLeft._x + spliterLeft._width;
		addSpace._width = Stage.width - addSpace._x - mainRight._width;
		// - 4;
		recordingStatus._x = addSpace._x + addSpace._width;
	}
	function onLoad () {
		_global.tt("[Template] onLoad");
		if (currentActiveTemplate == undefined) {
			//_global.application.applyTemplate(templateList[0].data);
			//changeTemplate(templateList[0].data);
			nc.call ("loadTemplate", null);
		}
	}
	function changeTemplate (id:Number, data:Object) {
		_global.tt("[Template] changeTemplate");
		nc.call ("applyTemplate", null, id, data);
	}
	function initTemplate () {
		_global.tt("[Template] initTemplate");
		changeTemplate (0, templateList[0].data);
	}
	function loadTemplate (id:Number, data:Object) {
		_global.tt("[Template] loadTemplate");
		this.owner.currentActiveTemplate = data;
		this.owner.activeBtn.enabled = true;
		this.owner.activeBtn.bgLeft._visible = true;
		this.owner.activeBtn.bgRight._visible = true;
		this.owner.activeBtn.led.gotoAndStop (1);
		// update active btn
		this.owner.activeBtn = this.owner["tbtn_" + id];
		this.owner.activeBtn.enabled = false;
		this.owner.activeBtn.bgLeft._visible = false;
		this.owner.activeBtn.bgRight._visible = false;
		this.owner.activeBtn.led.gotoAndStop (2);
		_global.application.applyTemplate (data);
	}
	function applyTemplate (id:Number, data:Object) {
		_global.tt("[Template] applyTemplate");
		currentActiveTemplate = data;
		activeBtn.enabled = true;
		activeBtn.bgLeft._visible = true;
		activeBtn.bgRight._visible = true;
		activeBtn.led.gotoAndStop (1);
		// update active btn
		activeBtn = this["tbtn_" + id];
		activeBtn.enabled = false;
		activeBtn.bgLeft._visible = false;
		activeBtn.bgRight._visible = false;
		activeBtn.led.gotoAndStop (2);
		// 
		_global.application.applyTemplate (data);
		// pod menu selected
		for (var n in podList) {
			pods_menu.UISpace.rowSpace["label" + podList[n].id].selected = false;
		}
		for (var i = 0; i < data.length; i++) {
			for (var n = 0; n < data[i].length; n++) {
				pods_menu.UISpace.rowSpace["label" + podList[data[i][n].type].id].selected = true;
			}
		}
		// layout menu selected
		for (var i = 0; i < templateList.length; i++) {
			layout_menu.UISpace.rowSpace["label" + i].selected = false;
		}
		layout_menu.UISpace.rowSpace["label" + id].selected = true;
	}
	function addItem (arr:Array) {
		if (templateBtnList.length > 0) {
			for (var i = 0; i < templateBtnList.length; i++) {
				templateBtnList[i].swapDepths (123456);
				templateBtnList[i].removeMovieClip ();
			}
		}
		mainRight._x = Stage.width - mainRight._width - 8;
		this.attachMovie ("templateCtrlCenter", "addSpace", 9);
		addSpace._x = spliterLeft._x + spliterLeft._width;
		addSpace._width = Stage.width - addSpace._x - mainRight._width - 4;
		//this.attachMovie("recordingStatus","recordingStatus",10);
		//recordingStatus._x = addSpace._x + addSpace._width;
		var mc:MovieClip;
		//spliterRight.swapDepths(arr.length+10);
		//spliterRight._x = lastMC._x + lastMC._width;
		mainRight.swapDepths (arr.length + 10 + 1);
		//this.maithis._x - nRight._x = this.spliterRight._x + this.spliterRight._width;
		addShadow (this, true);
	}
	function drawBox (t:MovieClip, w:Number, h:Number) {
		with (t) {
			beginFill (0xEEEEEE, 1);
			moveTo (0, 0);
			lineTo (w, 0);
			lineTo (w, h);
			lineTo (0, h);
			lineTo (0, 0);
			endFill ();
		}
	}
	function addShadow (mc:MovieClip, b:Boolean) {
		var dropShadow = new DropShadowFilter (0, 45, 0x000000, 0.4, 6, 6, 2, 3);
		mc.filters = b ? [dropShadow] : [];
	}
	function getScreenCaptureDriver ():Number {
		_global.tt("[Template] getScreenCaptureDriver");
		var camList:Array = Camera.names;
		for (var i = 0; i < camList.length; i++) {
			if (camList[i] == "VHScrCap") {
				return i;
			}
		}
		return 0;
	}
}
