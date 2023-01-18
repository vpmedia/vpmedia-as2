import flash.filters.DropShadowFilter;
class com.vpmedia.ui.Pod extends MovieClip {
	public var topRight:MovieClip;
	public var topCenter:MovieClip;
	public var topLeft:MovieClip;
	public var subRight:MovieClip;
	public var subCenter:MovieClip;
	public var subLeft:MovieClip;
	public var bottomLeft:MovieClip;
	public var bottomCenter:MovieClip;
	public var bottomRight:MovieClip;
	public var midRight:MovieClip;
	public var midCenter:MovieClip;
	public var midLeft:MovieClip;
	public var iconMaximize:MovieClip;
	public var iconMinimize:MovieClip;
	public var resize_btn:MovieClip;
	public var resize_mc:MovieClip;
	public var hitBoxarea:MovieClip;
	public var title:TextField;
	var isToped:Boolean;
	var isLefted:Boolean;
	var isRighted:Boolean;
	var isChild:Boolean;
	var nonResize, scaled:Boolean;
	var mcTopOrientation:MovieClip;
	var mcLeftOrientation:MovieClip;
	var oldWstage:Number;
	var oldHstage:Number;
	var oldW:Number;
	var oldH:Number;
	var __width;
	var __height;
	var __subcontenty;
	var __contenty;
	var __bottomy:Number;
	var space:Number = 5;
	function Pod () {
		this._parent._visible = false;
		this.oldWstage = Stage.width;
		this.oldHstage = Stage.height;
		this.oldW = this._width;
		this.oldH = this._height;
		topLeft._focusrect = topCenter._focusrect = topRight._focusrect = false;
		topCenter.onPress = topLeft.onPress = topRight.onPress = function () {
			this._parent._parent.startDrag (false,0,0,Stage.width,Stage.height);
		};
		iconMaximize.onRelease = function () {
			//this._parent.show ();
		};
		iconMinimize.onRelease = function () {
			//this._parent.hide ();
		};
		Stage.addListener (this);
		//setSize(200,200);
		//onResize();
	}
	function onResize () {
		var w:Number = Stage.width / this.oldWstage;
		var h:Number = Stage.height / this.oldHstage;
		setSize (this.oldW * w,this.oldH * h);
		var xalt1 = this.mcLeftOrientation._x + this.mcLeftOrientation.bg._width + space;
		var xalt2 = this.mcTopOrientation._x + this.mcTopOrientation.bg._width + space;
		var yalt = this.mcTopOrientation._y + this.mcTopOrientation.bg._height + space;
		var x = this.isLefted ? this.isChild ? xalt1 : this._parent._x : this.isChild ? xalt2 : xalt1;
		var y = this.isToped ? this.isChild ? yalt : this._parent._y : this.isChild ? this.mcTopOrientation._y : yalt;
		this._parent.setPos (x,y);
		this.oldWstage = Stage.width;
		this.oldHstage = Stage.height;
	}
	function percentage (top:Boolean, left:Boolean, right:Boolean, topmc:MovieClip, leftmc:MovieClip, child:Boolean):Void {
		this.isToped = top;
		this.isLefted = left;
		this.isRighted = right;
		this.isChild = child;
		this.mcTopOrientation = topmc;
		this.mcLeftOrientation = leftmc;
	}
	function setSize (w:Number, h:Number, init:Boolean, NonCallBack:Boolean):Void {
		if (nonResize) {
			return;
		}
		w = w < 100 ? 100 : w;
		h = h < 100 ? 100 : h;
		// bg title
		topRight._x = w;
		topCenter._width = w - topRight._width - topLeft._width;
		// sub menu
		if (subRight != undefined) {
			subRight._x = w;
			subCenter._width = w - subRight._width - subLeft._width;
		}
		// bottom           
		bottomLeft._y = bottomCenter._y = bottomRight._y = h;
		bottomRight._x = w;
		bottomCenter._width = w - bottomRight._width - bottomLeft._width;
		// middle
		midRight._x = w;
		midCenter._width = w - midRight._width - midLeft._width;
		midLeft._height = midCenter._height = midRight._height = bottomLeft == undefined ? h - midRight._y : h - bottomLeft._height - midLeft._y;
		// icons
		iconMaximize._x = w - (iconMaximize._width / 2) - 5;
		iconMinimize._x = iconMaximize._x - (iconMaximize._width / 2) - 10;
		// title
		title._width = w - 38;
		// scaller
		this._parent.resize_btn._x = w;
		this._parent.resize_btn._y = h;
		this._parent.resize_mc.clear ();
		this.oldW = w;
		this.oldH = h;
		__width = w;
		__height = h;
		if (!NonCallBack) {
			this._parent.setSize (this._width,this._height);
		}
		if (init) {
			this._parent._visible = true;
		}
		addShadow (true);
		updateAfterEvent ();
	}
	function setTitle (t:String):Void {
		title.text = t;
	}
	function set isNonResize (b:Boolean) {
		nonResize = b;
		iconMaximize._visible = b ? false : true;
		iconMinimize._visible = b ? false : true;
	}
	function addScaller (t:MovieClip) {
		t.attachMovie ("pod_asset_resize","resize_btn",t.getNextHighestDepth ());
		t.resize_mc = t.createEmptyMovieClip ("resize_mc", t.getNextHighestDepth ());
		t.resize_btn._x = __width;
		t.resize_btn._y = __height;
		t.resize_btn.owner = this;
		t.resize_btn.onPress = function () {
			trace ("press " + this.owner);
			this.owner.scaled = true;
		};
	}
	function onMouseUp () {
		this._parent.stopDrag ();
		if (scaled) {
			setSize (this._parent.resize_mc._width,this._parent.resize_mc._height);
		}
		scaled = false;
	}
	function onMouseDown () {
		if (!this._parent._visible) {
			return;
		}
		if (this._parent.hitTest (_root._xmouse, _root._ymouse)) {
			var gb:Object = this.getBounds (this._parent);
			var hit:Boolean = this._parent._xmouse > gb.xMin + 6 && this._parent._xmouse < gb.xMax - 6 && this._parent._ymouse > gb.yMin + 6 && this._parent._ymouse < gb.yMax - 6 ? true : false;
			//trace (this._name + " : " + this._parent._name + " : " + hit);
			if (!hit) {
				return;
			}
			if (_global.$CURRENT_TOP_POD._name != this._parent._name && !_global.$CURRENT_TOP_POD.hitTest (_root._xmouse, _root._ymouse)) {
				setOnTop ();
			}
		}
	}
	function onMouseMove () {
		if (!scaled) {
			return;
		}
		if (this._xmouse < 100) {
			return;
		}
		if (this._ymouse < 100) {
			return;
		}
		updateAfterEvent ();
		drawBox (this._xmouse,this._ymouse);
	}
	function setOnTop () {
		this._parent.swapDepths (this._parent.getDepth () + 100);
		_global.$CURRENT_TOP_POD.swapDepths (_global.$CURRENT_TOP_POD.getDepth () - 100);
		_global.$CURRENT_TOP_POD = this._parent;
	}
	function drawBox (x, y) {
		this._parent.resize_mc.clear ();
		with (this._parent.resize_mc) {
			lineStyle (2,0x666666,100);
			moveTo (0,0);
			lineTo (x,0);
			lineTo (x,y);
			lineTo (0,y);
			lineTo (0,0);
		}
	}
	function hide () {
		this._parent._visible = false;
		close ();
	}
	function show () {
		this._parent._visible = true;
	}
	function close () {
		//_global.nc.call ("closePod",null,this._parent.id);
	}
	function get contentWidth ():Number {
		return __width;
	}
	function get contentHeight ():Number {
		return this.midLeft._height;
	}
	function get width ():Number {
		return __width;
	}
	function get height ():Number {
		return __height;
	}
	function get subcontenty ():Number {
		return __subcontenty;
	}
	function get contenty ():Number {
		return __contenty;
	}
	function get bottomy ():Number {
		return __bottomy;
	}
	function addShadow (b:Boolean) {
		var dropShadow:DropShadowFilter = new DropShadowFilter (0, 45, 0x000000, 0.6, 3, 3, 2, 3);
		this.filters = b ? [dropShadow] : [];
	}
}