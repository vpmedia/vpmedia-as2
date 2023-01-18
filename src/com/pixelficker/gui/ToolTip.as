import com.nuran.draw.*;
/**
* The ToolTip class is a highly modifed version of com.nuran.gui.ToolTip
* Fitted to work with the specs of the com.cetdemi.Timeline framework
*/
class com.pixelficker.gui.ToolTip extends MovieClip 
{
	private var $registeredClips:Array = [];
	private var $activeClip:MovieClip;
	private var $animated:Boolean = true;
	private var $interval = 31;
	private var $fadeInRate:Number = 60;
	private var $fadeOutRate:Number = 30;
	private var $animID:Number;
	private var $tiptext:String = "";
	private var $fmt:TextFormat;
	private var $indent:Number = 4;
	private var $depth:Number = 0;
	private var $tt:MovieClip;
	private var $bgColor:Number = Number (0xFFFFCC);
	private var $font:String = "Arial";
	private var $fontSize:Number = 12;
	private var $followMouse:Boolean;
	private var $maxWidth:Number = (Stage.width < 300) ? 300 : Stage.width;
	
	/**
	 * Creates a tooltip object
	 */
	function ToolTip () 
	{
		//
	}
	
	/**
	* Registers a clip
	*/
	public function registerClip (clip:MovieClip, tiptext:String, font:String, fontSize:Number, follow:Boolean) 
	{
		$registeredClips.push ([clip, tiptext, $font, $fontSize, false]);
	};
	
	/**
	* Show the tooltip for the registered clip
	* 
	* @param clip The clip to associate with a tooltip
	*/
	public function showToolTip (clip:MovieClip) 
	{
		$activeClip = clip;
		if ($animID != undefined) clearAnimation ();
		var i = 0, len = $registeredClips.length;
		while (i < len) {
			if ($registeredClips[i][0] == clip) {
				var c = $registeredClips[i];
				$tiptext = c[1];
				$font = c[2];
				$fontSize = c[3];
				$followMouse = c[4]
				var size = calcSize ($tiptext);
				drawTip (c[0], size[0], size[1]);
				return;
			}
			i++;
		}
	};
	
	/**
	* Hides the tooltip
	*/
	public function hideToolTip () 
	{
		clearAnimation();
		fade ($tt, "_alpha", 0, $fadeOutRate, $interval, false);
	};
	
	/**
	* Checks if a movie clip is registered within the tooltip framework
	*/
	public function isRegisteredClip (clip:MovieClip) 
	{
		var i = 0, len = $registeredClips.length, ret:Boolean = false;
		while (i < len) {
			if ($registeredClips[i][0] == clip) ret = true;
			i++;
		}
		return ret;
	}
	
	//Private functions
	
	/**
	* Calculate the size to assign to a tooltip
	* 
	* @param txt The text of the tolltip
	*/
	private function calcSize (txt:String) 
	{
		$fmt = new TextFormat ();
		$fmt.font = $font == "" ? "_sans" : $font;
		$fmt.size = $fontSize;
		// getTextExtent returns: width, height, ascent, descent, textFieldHeight, textFieldWidth.
		var obj = $fmt.getTextExtent (txt);
		var w = obj.textFieldWidth + 4;
		var h = obj.textFieldHeight + 0;
		return ([w, h]);
	};
	
	/**
	* Draw a tooltip object
	* 
	* @param ref The movieclip associated with the tooltip
	* @param w The width of the movieclip to create
	* @param h The height o fth emovieclip to create
	*/
	private function drawTip (ref:MovieClip, w:Number, h:Number) 
	{
		if ($depth != undefined) $tt.removeMovieClip();
		
		//$depth = _root.getNextHighestDepth (); // verbesserungs würdig ... sollte der Tip nicht immer nur an der ...
		$tt = _root.createEmptyMovieClip ("__TOOLTIP", 100000);
		$tt._alpha = 0;
		//
		if (w > $maxWidth) 
		{
			w = $maxWidth;
		}
		
		//Draw drop shadow
		$tt.beginFill(0x999999);
		var rect = new Rectangle($tt, 0+3,1+3,w-2+3,h-1+3);
		$tt.endFill();
		
		//Draw rectangle
		$tt.lineStyle(1,0x000000);
		$tt.beginFill($bgColor);
		var rect = new Rectangle($tt, 0,1,w-2,h-1);
		$tt.endFill();
		
		$tt.createTextField("label", 1000, 2, 1, w - $indent, h );
		$tt.label._visible = 0;
		if ($bgColor == 0x0) $tt.label.textColor = 0xFFFFF;
		//
		
		$tt.label.background = false;
		$tt.label.border = false;
		$tt.label.wordWrap = true;
		$tt.label.multiline = true;
		$tt.label.selectable = false;
		
		$tt.label.autoSize = "right";
		$tt.label.embedFonts = false;
		//$tt.label.embedFonts = $font == "_sans" ? false : true;
		$tt.label.mouseWheelEnabled = false;
		
		$tt.label.setNewTextFormat ($fmt);
		$tt.label.text = $tiptext;
		
		if (w == $maxWidth) 
		{
			h = $tt.label.textHeight + (2 * $indent) + 1;
		}
		positionTip(ref);
		if ($animated) 
		{
			fade ($tt, "_alpha", 100, $fadeInRate, $interval);
		} 
		else 
		{
			$tt._alpha = 100;
		}
	}
	
	/**
	* Position the tooltip on the stage
	* 
	* May be overriden in a child class
	*/
	private function positionTip (ref) 
	{
		//Implement positioning script
	}
	
	/**
	* Clears the animation
	*/
	private function clearAnimation () 
	{
		clearInterval ($animID);
		delete ($animID);
	}
	
	/**
	* Fade the movieclip
	*/
	private function fade (c:MovieClip, p:String, da:Number, r:Number, i:Number, del) 
	{		
		if (!i) i = 1;
		var f = r * ((da > c[p]) * 2 - 1)
		$animID = setInterval(__fade, i, c, p, da, r, del, f);
	}
	
	/**
	* Fade callback
	*/
	private function __fade (c:MovieClip, p:String, da:Number, r:Number, del, f) 
	{
		if (Math.abs(c[p] - da) < r)
		{
			c[p] = da;
			c.label._visible = true;
			clearInterval($animID);
			(del != undefined) ? c.removeMovieClip() : null;
		} 
		else 
		{
			if (c[p] >= 75 && c.label._visible == 0) 
			{
				c.label._visible = true;
				c.label._alpha = 100;
			}
			c[p] += f;
			updateAfterEvent();
		}
	}
}