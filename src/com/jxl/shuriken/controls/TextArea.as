import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.utils.DrawUtils;

class com.jxl.shuriken.controls.TextArea extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.TextArea";
	
	// how many lines to scroll the text
	// Nokia 6680: WAP Browser defaults to 2 lines
	public static var SCROLL_SIZE:Number = 2;
	
	public var scrollbarThumbSymbol:String = "ScrollbarThumb";
	public var scrollbarTrackSymbol:String = "ScrollbarTrack";
	public var minThumbHeight:Number = 12;
	
	public function set text(val:String):Void
	{
		__txtLabel.html = false;
		__txtLabel.text = val;
		__txtLabel._visible = false;
		invalidate();
	}
	
	public function set htmlText(val:String):Void
	{
		__txtLabel.html = true;
		__txtLabel.htmlText = val;
		__txtLabel._visible = false;
		invalidate();
	}
	
	private var __txtLabel:TextField;
	private var __track_mc:MovieClip;
	private var __thumb_mc:MovieClip;
	private var __upArrow_pb:SimpleButton;
	private var __downArrow_pb:SimpleButton;
	
	public function get textField():TextField { return __txtLabel; }
	
	public function TextArea()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__txtLabel == null)
		{
			__txtLabel = createLabel("__txtLabel");
			__txtLabel.multiline = true;
			__txtLabel.wordWrap = true;
			__txtLabel.onChanged = Delegate.create(this, onChanged);
		}
		
		if(__track_mc == null) __track_mc = attachMovie(scrollbarTrackSymbol, "__track_mc", getNextHighestDepth());
		if(__thumb_mc == null) __thumb_mc = attachMovie(scrollbarThumbSymbol, "__thumb_mc", getNextHighestDepth());
		if(__upArrow_pb == null)
		{
			__upArrow_pb = SimpleButton(createComponent(SimpleButton, "__upArrow_pb"));
			__upArrow_pb.setReleaseCallback(this, onUpArrowRelease);
		}
		
		if(__downArrow_pb == null)
		{
			__downArrow_pb = SimpleButton(createComponent(SimpleButton, "__downArrow_pb"));
			__downArrow_pb.setReleaseCallback(this, onDownArrowRelease);
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		__txtLabel._visible = true;
		
		if(__txtLabel.maxscroll > 1)
		{
			__track_mc._x = __width - __track_mc._width;
			__track_mc._y = 0;
			__track_mc._height = __height;
		
			var biggerW:Number = Math.max(__thumb_mc._width, __track_mc._width);
			
			__upArrow_pb.move(0, 0);
			__upArrow_pb.setSize(__width - biggerW - 1, 4);
			
			__downArrow_pb.move(0, __height - 4);
			__downArrow_pb.setSize(__upArrow_pb.width, 4);
			
			var lastW:Number = __txtLabel._width;
			var lastH:Number = __txtLabel._height;
			__txtLabel.setSize(__width - biggerW, __height - __upArrow_pb.height - __downArrow_pb.height);
			if(__txtLabel._width != lastW || __txtLabel._height != lastH)
			{
				// KLUDGE
				// size has changed, thus, so has maxscroll potentially.
				// abort redrawing, and do it again
				// unfortunately, if we turn it invisible (__txtLabel._visible = false)
				// to avoid flicker, it prevents the recalculating of the maxscroll...
				invalidate();
				return;
			}
			__txtLabel.move(0, __upArrow_pb.y + __upArrow_pb.height);
			
			var thumbHPer:Number = __txtLabel.scroll / __txtLabel.maxscroll;
			// TODO: it'd be nice if this scaled so the scrollbar would have more variation in height
			// currently it's a cut and dry division.  If there was some sort of exponent
			// in the drop in size, that'd be nice looking, like real scrollbars.
			var thumbH:Number = Math.max(minThumbHeight, (__height / __txtLabel.maxscroll));
			if(isNaN(thumbH) == true) thumbH = minThumbHeight;
			var locV:Number;
			
			if(__txtLabel.scroll == 1)
			{
				locV = 0;
				__upArrow_pb._visible = false;
				__downArrow_pb._visible = true;
			}
			else if(__txtLabel.scroll == __txtLabel.maxscroll)
			{
				locV = __height - thumbH;
				__upArrow_pb._visible = true;
				__downArrow_pb._visible = false;
			}
			else
			{
				// KLUDGE: My name is Jesse Warden, and I cannot write scroll algorithms to save my life....
				// Please fix if you can.
				locV = Math.max(2, (__height * thumbHPer) - thumbH);
				__upArrow_pb._visible = true;
				__downArrow_pb._visible = true;
			}
			
			__thumb_mc._x = __width - __thumb_mc._width;
			__thumb_mc._y = locV;
			__thumb_mc._height = thumbH;
			__thumb_mc._visible = true;
			__track_mc._visible = true;
		}
		else
		{
			__track_mc._visible = false;
			__thumb_mc._visible = false;
			__upArrow_pb._visible = false;
			__downArrow_pb._visible = false;
			
		}
		
		drawButtons();
	}
	
	private function drawButtons():Void
	{
		__upArrow_pb.clear();
		__upArrow_pb.lineStyle(0, 0x666666);
		__upArrow_pb.beginFill(0xCCCCCC);
		DrawUtils.drawBox(__upArrow_pb, 0, 0, __upArrow_pb.width, __upArrow_pb.height);
		__upArrow_pb.lineStyle(0, 0x000000, 0);
		__upArrow_pb.beginFill(0x000000);
		var centerX:Number = __upArrow_pb.width / 2;
		var centerY:Number = __upArrow_pb.height / 2;
		var arrowW:Number = 6;
		var arrowH:Number = 4;
		var arrowWHalf:Number = arrowW / 2;
		var arrowHHalf:Number = arrowH / 2;
		__upArrow_pb.moveTo(centerX - arrowWHalf, centerY + arrowHHalf);
		__upArrow_pb.lineTo(centerX, centerY - arrowHHalf);
		__upArrow_pb.lineTo(centerX + arrowWHalf, centerY + arrowHHalf);
		__upArrow_pb.lineTo(centerX - arrowWHalf, centerY + arrowHHalf);
		__upArrow_pb.endFill();
		
		__downArrow_pb.clear();
		__downArrow_pb.lineStyle(0, 0x666666);
		__downArrow_pb.beginFill(0xCCCCCC);
		DrawUtils.drawBox(__downArrow_pb, 0, 0, __downArrow_pb.width, __downArrow_pb.height);
		__downArrow_pb.lineStyle(0, 0x000000, 0);
		__downArrow_pb.beginFill(0x000000);
		__downArrow_pb.moveTo(centerX - arrowWHalf, centerY - arrowHHalf);
		__downArrow_pb.lineTo(centerX + arrowWHalf, centerY - arrowHHalf);
		__downArrow_pb.lineTo(centerX, centerY + arrowHHalf);
		__downArrow_pb.lineTo(centerX - arrowWHalf, centerY - arrowHHalf);
		__downArrow_pb.endFill();
	}
	
	private function onChanged():Void
	{
		invalidate();
	}
	
	private function onUpArrowRelease(p_event:ShurikenEvent):Void
	{
		scrollUp();
	}
	
	private function onDownArrowRelease(p_event:ShurikenEvent):Void
	{
		scrollDown();
	}
	
	public function scrollUp():Void
	{
		__txtLabel.scroll -= SCROLL_SIZE;
		invalidate();
	}
	
	public function scrollDown():Void
	{
		__txtLabel.scroll += SCROLL_SIZE;
		invalidate();
	}
	
	
	
}