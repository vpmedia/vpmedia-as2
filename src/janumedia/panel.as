import flash.filters.DropShadowFilter;
class janumedia.panel extends MovieClip {
	var logobg, left, center, right, led, meeting, present, layout, pods, help, meeting_menu, present_menu, layout_menu, pods_menu, help_menu:MovieClip;
	var space:Number = 2;
	function panel () {
		_global.tt ("panel");
		_global.panelmc = this;
		this._y = 40;
		// panel
		this.attachMovie ("panel_led", "led", 10, {_x:Stage.width, _width:10});
		this.attachMovie ("panel_logo", "logobg", 11);
		this.attachMovie ("panel_left", "left", 12, {_x:logobg._x + logobg._width + space, _width:60});
		this.attachMovie ("panel_right", "right", 13, {_x:led._x - led._width - space, _width:60});
		this.attachMovie ("panel_center", "center", 14, {_x:left._x + left._width, _width:Stage.width - left._x - left._width - right._width - led._width});
		// menu
		if (_global.userMode == 2) {
			this.attachMovie ("Menu", "meeting_menu", 20);
			this.attachMovie ("Menu", "help_menu", 24);
		} else {
			this.attachMovie ("Menu", "meeting_menu", 20);
			this.attachMovie ("Menu", "present_menu", 21);
			this.attachMovie ("Menu", "layout_menu", 22);
			this.attachMovie ("Menu", "pods_menu", 23);
			this.attachMovie ("Menu", "help_menu", 24);
		}
		// menubar
		var menuBarList:Array = new Array ();
		if (_global.userMode == 2) {
			menuBarList = [{label:"Meetings", target:meeting_menu}, {label:"Help", target:help_menu}];
		} else {
			menuBarList = [{label:"Meetings", target:meeting_menu}, {label:"Present", target:present_menu}, {label:"Layout", target:layout_menu}, {label:"Pods", target:pods_menu}, {label:"Help", target:help_menu}];
		}
		createMenuBar (menuBarList);
		// menu data
		var meeting_data:Array = [{label:"Invite Participant", data:"meeting", type:"check", selected:false}, {label:"Record Meeting", data:"meeting", type:"check", selected:false}, {label:"End Meeting", data:"meeting", type:"check", selected:false}, {label:"Room Bandwith", data:"meeting", type:"check", selected:false}, {label:"Select Camera", data:"meeting", type:"check", selected:false}, {label:"Fullscreen", data:"meeting", type:"check", selected:false}];
		var present_data:Array = [{label:"My Meetings", data:"meeting", type:"check", selected:false}, {label:"My Contents", data:"meeting", type:"check", selected:false}, {label:"My Presentations", data:"meeting", type:"check", selected:false}, {label:"My Events", data:"meeting", type:"check", selected:false}];
		var layout_data:Array = [{label:"Sharing", data:"meeting", type:"check", selected:false}, {label:"Discussion", data:"meeting", type:"check", selected:false}, {label:"Colaboration", data:"meeting", type:"check", selected:false}, {label:"My Layout #1", data:"meeting", type:"check", selected:false}];
		var pods_data:Array = [{label:"Share Window", data:"meeting", type:"check", selected:false}, {label:"Camera and Voice", data:"meeting", type:"check", selected:false}, {label:"People List", data:"meeting", type:"check", selected:false}, {label:"Chat Box", data:"meeting", type:"check", selected:false}, {label:"File Share", data:"meeting", type:"check", selected:false}, {label:"Polling", data:"meeting", type:"check", selected:false}, {label:"Note", data:"meeting", type:"check", selected:false}];
		var help_data:Array = [{label:"Sharing", data:"meeting", type:"check", selected:false}, {label:"Discussion", data:"meeting", type:"check", selected:false}, {label:"Colaboration", data:"meeting", type:"check", selected:false}, {label:"My Layout #1", data:"meeting", type:"check", selected:false}];
		meeting_menu.headerLabel = "Meetings Preference";
		present_menu.headerLabel = "Presentations Setup";
		layout_menu.headerLabel = "Layout Template";
		pods_menu.headerLabel = "View Pods";
		help_menu.headerLabel = "Help / Documentation";
		meeting_menu.dataProvider = meeting_data;
		present_menu.dataProvider = present_data;
		layout_menu.dataProvider = layout_data;
		pods_menu.dataProvider = pods_data;
		help_menu.dataProvider = help_data;
		Stage.addListener (this);
		onResize ();
	}
	function onResize () {
		_global.tt ("onResize");
		led._x = Stage.width;
		left._x = logobg._width + space;
		right._x = led._x - led._width - space;
		center._x = left._x + left._width;
		center._width = Stage.width - left._x - left._width - right._width - led._width - space;
		addShadow (true);
	}
	function createMenuBar (arr:Array) {
		_global.tt ("createMenuBar");
		for (var i = 0; i < arr.length; i++) {
			var mc:MovieClip = this.createEmptyMovieClip (arr[i].label, 30 + i);
			mc.createTextField ("label", 1, 0, 0, 2, 2);
			var fmt:TextFormat = new TextFormat ();
			fmt.font = "Verdana";
			fmt.size = 10;
			mc.label.setNewTextFormat (fmt);
			mc.label.autoSize = true;
			mc.selectable = false;
			mc.label.text = arr[i].label;
			drawBox (mc, mc._width, mc._height);
			mc._y = 2;
			mc._x = i > 0 ? this[arr[i - 1].label]._x + this[arr[i - 1].label]._width + 10 : left._x + 20;
			mc.menuname = arr[i].target;
			mc.onPress = function () {
				this.menuname.show (this._x, this._parent.height);
			};
		}
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
	function get height ():Number {
		return logobg._height;
	}
	function addShadow (b:Boolean) {
		var dropShadow = new DropShadowFilter (0, 45, 0x000000, 0.4, 6, 6, 2, 3);
		this.filters = b ? [dropShadow] : [];
	}
}
