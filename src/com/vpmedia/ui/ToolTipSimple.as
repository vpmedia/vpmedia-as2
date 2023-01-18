class com.vpmedia.ui.ToolTipSimple
{
	public function ToolTipSimple (base:MovieClip)
	{
		this.base = base;
	}
	/**
	 * <p>Description: Tooltip</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	setTooltip = function (theText, timer, text_color, bg_color, border_color, __alpha, __textformat)
	{
		if (timer == undefined)
		{
			timer = 500;
		}
		var addMsg = function (theMsg, col, bg_color, border_color, level, __alpha, __textformat)
		{
			var x = _root._xmouse;
			var y = _root._ymouse;
			if (!textformat)
			{
				var f = new TextFormat ();
				f.font = "Arial";
				f.size = 11;
				f.color = col != undefined ? col : 0x000000;
			}
			else
			{
				var f = __textformat;
			}
			_level0.createEmptyMovieClip ("tooltip", 123455);
			_level0.tooltip.removeTextField ("tooltipText");
			_level0.tooltip.createTextField ("tooltipText", 123456, x, y, 150, 20);
			with (_level0.tooltip.tooltipText)
			{
				setNewTextFormat (f);
				text = theMsg;
				selectable = false;
				autoSize = true;
				background = true;
				border = true;
				//embedFonts = true;
				borderColor = border_color != undefined ? border_color : 0x000000;
				backgroundColor = bg_color != undefined ? bg_color : 0xFFFFEE;
				_y -= _height;
				if (_x + _width > Stage.width)
				{
					_x = Stage.width - _width - 5;
				}
			}
			//trace(__alpha);
			//tooltip._alpha = __alpha;
			clearInterval (level.q_t);
		};
		this.q_t = setInterval (addMsg, timer, theText, text_color, bg_color, border_color, this, __alpha, __textformat);
	};
	unsetTooltip = function ()
	{
		_level0.tooltip.tooltipText.removeTextField ();
		clearInterval (this.q_t);
	};
}
