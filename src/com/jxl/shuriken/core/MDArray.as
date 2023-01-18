import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.shuriken.core.MDArray
{
	
	public var rows:Number;
	public var cols:Number;
	
	//private var __source:Array;
	//private var totalCells:Number;
	
	public function get length():Number { return  rows * cols; }
	//public function get length():Number { return  __source.length; }
	
	public function MDArray(p_rows:Number, p_cols:Number, optional)
	{
		init(p_rows, p_cols, optional);
	}
	
	public function init(p_rows:Number, p_cols:Number, optional):Void
	{
		rows = p_rows;
		cols = p_cols;
		//__source = [];
		//totalCells = rows * cols;
		
		if(optional == null)
		{
			for(var r=0; r<rows; r++){
				this[r] = [];
				for(var c=0; c<cols; c++){
					this[r][c] = 0;
				}
			}
		}
		else
		{
			for(var r=0; r<rows; r++){
				this[r] = [];
				for(var c=0; c<cols; c++){
					this[r][c] = optional;
				}
			}
		}
		
		
		/*
		// explicitly set to null; undefined implies things went haywire; null is intentional
		optional = (optional == undefined) ? null : optional;
		for(var r:Number=0; r<rows; r++)
		{
			for(var c:Number=0; c<cols; c++)
			{
				setCell(r, c, optional);
			}
		}
		*/
	}
	
	public function setCell(r:Number, c:Number, whichValue):Void
	{
		this[r][c] = whichValue;
		//__source[cell(r, c)] = whichValue;
		//trace("set value: " + whichValue + ", value stored: " + __source[cell(r, c)]);
		/*
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.CHANGE, this);
		event.row = r;
		event.col = c;
		event.value = whichValue;
		dispatchEvent(event);
		*/
	}
	
	public function getCell(r:Number, c:Number):Object
	{
		var cellValue = this[r][c];
		return cellValue;
		//return __source[cell(r, c)];
	}
	
	private function cell(r:Number, c:Number):Number
	{
		var cellLoc:Number = (r * rows) + c;
		return cellLoc;
	}
	
	/*
	public function toString():String
	{
		return __source.toString();	
	}
	*/
	
	public function toFormattedString():String
	{
		var s:String = "";
		s += "        ";
		for(var i:Number = 0; i<cols; i++)
		{
			if(i != 0)
			{
				s += ",\t\tcol " + i;
			}
			else
			{
				s += "col " + i;
			}
		}
		s += "\n";
		s += "      ";
		
		var lineStrLen:Number = cols;
		while(lineStrLen--)
		{
			
			s += "------------";
		}
		s += "\n";
		
		for(var r:Number = 0; r<rows; r++)
		{
			s += "row " + r + " | ";
			for(var c:Number = 0; c<cols; c++)
			{
				if(c != 0)
				{
					s += ",\t\t" + c + ": " + getCell(r, c);
				}
				else
				{
					s += c + ": " + getCell(r, c);
				}
			}
			s += "\n";
		}
		return s;
	}
}
