class com.vpmedia.ui.ToolTip
{
	/**
	* Variables
	*/
	private var name:String;
	private var base:MovieClip;
	private var title:String = "";
	private var interval:Number = 0;
	public var delay:Number = 0;
	public var font:String = "Arial";
	public var size:Number = 11;
	public var bold:Boolean = false;
	public var color:Number = 0xFFFFFF;
	static var counter = 30000;
	/**
	* Constructor
	*/
	public function ToolTip (base:MovieClip, title:String)
	{
		this.base = base;
		this.title = title;
		this.name = "tooltip" + counter++;
		//this.name = "tooltip";
		this.applyChanges ();
	}
	/**
	* Initializes the tooltip.
	*/
	private function initialize ():Void
	{
		var toolTipTextFormat:Object = new TextFormat ();
		toolTipTextFormat.indent = 1;
		toolTipTextFormat.font = this.font;
		toolTipTextFormat.size = this.size;
		toolTipTextFormat.bold = this.bold;
		toolTipTextFormat.embedFonts = true;
		var info:Object = toolTipTextFormat.getTextExtent (this.title);
		///9999 counter
		_root.createTextField (this.name, counter, 0, 0, info.width + info.height + 4, info.height + 4);
		_root[this.name].border = true;
		_root[this.name].selectable = false;
		_root[this.name].multiline = true;
		_root[this.name].wordWrap = false;
		_root[this.name].autoSize = true;
		_root[this.name].html = true;
		_root[this.name].htmlText = this.title;
		_root[this.name].background = true;
		_root[this.name].backgroundColor = this.color;
		_root[this.name].setTextFormat (toolTipTextFormat);
		_root[this.name]._visible = false;
	}
	/**
	* Shows the tooltip instance.
	*/
	private function show ():Void
	{
		trace ("show");
		clearInterval (this.interval);
		this.moveTo (_root._xmouse, _root._ymouse);
		_root[this.name]._visible = true;
	}
	/**
	* Hides the tooltip instance.
	*/
	private function hide ():Void
	{
		clearInterval (this.interval);
		_root[this.name]._visible = false;
	}
	/**
	* Moves the tooltip instance.
	*/
	private function moveTo (x:Number, y:Number):Void
	{
		_root[this.name]._x = x - (_root[this.name]._width);
		_root[this.name]._y = y - (_root[this.name]._height);
	}
	/**
	* Applies changes to the tooltip instance.
	*/
	public function applyChanges ():Void
	{
		this.initialize ();
		var reference = this;
		this.base.onMouseDown = function ()
		{
			reference.hide ();
		};
		this.base.onMouseMove = function ()
		{
			if (this.hitTest (_root._xmouse, _root._ymouse, true) && this._parent._visible)
			{
				clearInterval (reference.interval);
				reference.interval = setInterval (reference, "show", reference.delay);
			}
			else
			{
				reference.hide ();
			}
			updateAfterEvent ();
		};
	}
}
