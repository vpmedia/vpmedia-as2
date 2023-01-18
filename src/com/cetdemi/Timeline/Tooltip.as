import com.cetdemi.Timeline.*;
import com.nuran.draw.*;

/**
 * The Tooltip class is used to create a tooltip
 * It extends the com.pixelficker.gui.ToolTip class
 */
 class com.cetdemi.Timeline.Tooltip extends com.pixelficker.gui.ToolTip
 {
	 /**
	 * Constructor
	 */
	function Tooltip()
	{
		super();
	}
	
	/**
	* Draw a tooltip object
	* 
	* @param ref The movieclip associated with the tooltip
	* @param w The width of the movieclip to create
	* @param h The height o fth emovieclip to create
	*/
	private function drawTip (ref:MovieClip, w:Number, h:Number) 
	{
		super.drawTip(ref, w, h);
		$tt.lineStyle(1,0x000000);
		if($tt._y > ref._y)
		{
			//Tooltip above
			$tt.moveTo(w/2, 0);
			var point = {x:0, y:ref._height/5.5};
		}
		else
		{
			//Tooltip below
			$tt.moveTo(w/2, h);
			var point = {x:0, y:-ref._height/3.6};
		}

		ref.localToGlobal(point);
		$tt.globalToLocal(point);
		
		$tt.lineTo(point.x, point.y);
	}
	
	private function positionTip (ref) 
	{
		var sw2 = Stage.width/2;
		$tt._x = ref._x - $tt._width/2 + 35;
		$tt._x += ($tt._x + $tt._width/2 > sw2) ? -20 : 20;
		$tt._y = ref._y - $tt._height - 15;

		var this_rx = $tt._x + $tt._width;
		var sw = Stage.width;
		var sh = Stage.height;
		if (this_rx > sw) 
		{
			$tt._x = sw - this_rx + $tt._x;
		}
		if ($tt._y < 20) 
		{
			$tt._y = $tt._y + $tt._height + 35;
		}
	}
}