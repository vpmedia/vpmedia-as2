import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.core.UIComponent extends MovieClip
{
	
	// TextField Decoration
	// This adds some helpful methods and properties to TextField's prototype.
	// Don't want them?  Comment out or delete this line of code.
	private static var textfield_mixin = com.jxl.shuriken.core.TextFieldDecorator.decorateTextField();
	
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.core.UIComponent";
	
	// Abstract variable; set it to whatever you want.
	public var data:Object;
	public var defaultTextFormat:TextFormat;
	
	public var isConstructing:Boolean;
	
	private var __width:Number;
	private var __height:Number;
	private var __boundingBox_mc:MovieClip;
	private var __arrayMethodTable:Array;
	
	public function get width():Number
	{
		return __width;
	}
	
	public function get height():Number
	{
		return __height;
	}
	
	public function get x():Number
	{
		return _x;
	}
	
	public function get y():Number
	{
		return _y;
	}
	
	public function UIComponent()
	{
		// this gets called when being defined as the prototype
		// don't do anything, just return.
		if (_name == undefined)
		{
			return;
		}
		
		isConstructing = true;
		
		__width 		= _width;
		__height 		= _height;
		
		_xscale 		= 100;
		_yscale 		= 100;
		
		//trace("UIComponent::constructor, __boundingBox_mc: " + __boundingBox_mc);
		__boundingBox_mc._visible = false;
		__boundingBox_mc._width = __boundingBox_mc._height = 0;
		
		defaultTextFormat = new TextFormat();
		defaultTextFormat.font = "_sans";
		defaultTextFormat.size = 11;
		
		watch("enabled", enabledChanged);

		// special case for enable since it isn't getter/setter
		// all components assume enabled unless set to disabled
		if(enabled == false)
		{
			setEnabled(false);
		}
		
		createChildren();
		redraw();
		isConstructing = false;
	}
	
	public function move(p_x:Number, p_y:Number):Void
	{
		_x 			= p_x;
		_y 			= p_y;
	}
	
	public function setSize(p_width:Number, p_height:Number):Void
	{
		__width 		= p_width;
		__height 		= p_height;
		
		redraw();
	}
	
	private function enabledChanged(pID:String, pOldValue:Boolean, pNewValue:Boolean):Boolean
	{
		setEnabled(pNewValue);
		return pNewValue;
	}
	
	private function setEnabled(p_enabled:Boolean):Void
	{
		invalidate();
	}
	
	// TODO: prevent the methods above from getting called since
	// we're about to invalidate everything anyway
	public function invalidate():Void
	{
		callLater(this, redraw);
	}
	
	// LIMITATION: you cannot add the same scope & function to a callLater
	public function callLater(p_scope:Object, p_func:Function, p_args:Array):Void
	{
		if(__arrayMethodTable == null)
		{
			__arrayMethodTable = [];
		}
		else
		{
			var i:Number = __arrayMethodTable.length;
			while(i--)
			{
				var o:Object = __arrayMethodTable[i];
				if(o.s == p_scope && o.f == p_func)
				{
					return;
				}
			}
		}
		__arrayMethodTable.push({s: p_scope, f: p_func, a: p_args});
		onEnterFrame = callLaterDispatcher;
	}
	
	private function callLaterDispatcher():Void
	{
		//trace("----------------------");
		//trace("UIComponent::callLaterDispatcher");
		//trace("before onEnterFrame: " + onEnterFrame);
		delete onEnterFrame;
		//trace("after onEnterFrame: " + onEnterFrame);
		
		// make a copy of the methodtable so methods called can requeue themselves w/o putting
		// us in an infinite loop
		//[gb] This won't work! It is not a copy.
		var __methodTable:Array = __arrayMethodTable;
		// new doLater calls will be pushed here
		__arrayMethodTable = [];

		// now do everything else
		if (__methodTable.length > 0)
		{
			var m:Object;
			while((m = __methodTable.shift()) != undefined)
			{
				m.f.apply(m.s, m.a);
			}
		}
	}
	
	public function cancelAllCallLaters():Void
	{
		__arrayMethodTable.splice(0);
		delete onEnterFrame;
	}
	
	private var createChildren:Function;
	private var redraw:Function;
	
	public function createComponent(p_class:UIComponent, p_name:String):MovieClip
	{
		// HACK: compiler hack; can't put static functions or properties in interfaces
		var theClass = p_class;
		var ref:MovieClip = attachMovie(theClass.SYMBOL_NAME, p_name, getNextHighestDepth());
		return ref;
	}
	
	public function createLabel(p_name:String):TextField
	{
		createTextField(p_name, getNextHighestDepth(), 0, 0, 100, 18);
		var txt:TextField = this[p_name];
		txt.setTextFormat(defaultTextFormat);
		txt.setNewTextFormat(defaultTextFormat);
		return txt;
	}
	
}