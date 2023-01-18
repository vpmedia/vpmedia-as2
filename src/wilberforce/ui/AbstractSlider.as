/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Simon Oliver
 * @version 1.0
 */
 
 /*
 * TODO - Add vertical implementation
 */

import wilberforce.events.simpleEventHelper;
import wilberforce.util.textField.textFieldUtility;

import com.bourre.commands.Delegate;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
class wilberforce.ui.AbstractSlider extends simpleEventHelper
{
	private var _container:MovieClip;
	private var _sliderBarContainer:MovieClip;
	private var _sliderWidgetContainer:MovieClip;
	
	public static var SLIDER_BAR_ATTACHNAME:String="sliderBarAsset";
	public static var SLIDER_WIDGET_ATTACHNAME:String="sliderWidgetAsset";
	
	private var _value:Number;
	private var _length:Number;
	private var _startRange:Number;
	private var _endRange:Number;
	
	private var _lastMouseX:Number;
	private var _lastMouseY:Number;
	
	private var _valueTextField:TextField;
	private var _titleTextField:TextField;
	
	public static var SLIDER_VALUE_CHANGED_EVENT:EventType=new EventType("onSliderValueChanged");
	
	function AbstractSlider(container:MovieClip,length:Number,startRange:Number,endRange:Number,initialValue:Number,vertical:Boolean,showValue:Boolean,valueTextFormat:TextFormat,title:String,titleTextFormat:TextFormat)
	{
		super();
		
		_container=container;
		_length=length;
		
		if (startRange) _startRange=startRange;
		else _startRange=0;
		if (endRange)_endRange=endRange;
		else _endRange=1;
		
		if (initialValue) _value=initialValue;
		else _startRange=0;
		_sliderBarContainer=_container.attachMovie(SLIDER_BAR_ATTACHNAME,"sliderBar",_container.getNextHighestDepth());
		_sliderBarContainer._width=length;
		
		_sliderWidgetContainer=_container.attachMovie(SLIDER_WIDGET_ATTACHNAME,"sliderWidget",_container.getNextHighestDepth());
		
		if (showValue)
		{
			_valueTextField=textFieldUtility.createTextField(_container,length,0,200,40,valueTextFormat,""+initialValue);
			_valueTextField._width=70;
		}
		
		if (title)
		{
			_titleTextField=textFieldUtility.createTextField(_container,0,0,200,40,titleTextFormat,title);
			var ty:Number=_titleTextField.textHeight+10;
			_sliderBarContainer._y+=ty;
			_sliderWidgetContainer._y+=ty;
			_valueTextField._y+=ty;
		}
		updateWidgetPosition();
		
		_sliderWidgetContainer.onPress=Delegate.create(this,startWidgetDrag);
		_sliderWidgetContainer.onRelease=_sliderWidgetContainer.onReleaseOutside=Delegate.create(this,stopWidgetDrag);
	}
	
	
	private function startWidgetDrag()
	{
		//trace("Dragging");
		_lastMouseX=_container._xmouse;
		_lastMouseY=_container._ymouse;
		//_moving=true;
		Mouse.addListener(this);
	}
	
	private function stopWidgetDrag()
	{
		Mouse.removeListener(this);
	}
	
	public function onMouseMove()
	{
		//trace("Moved");
		var dx=_container._xmouse-_lastMouseX;
		var dy=_container._xmouse-_lastMouseY;
		
		_sliderWidgetContainer._x+=dx;
		// Update the position
		_sliderWidgetContainer._x=Math.max(_sliderWidgetContainer._x,0);
		_sliderWidgetContainer._x=Math.min(_sliderWidgetContainer._x,_length);
		
		_lastMouseX=_container._xmouse;
		_lastMouseY=_container._ymouse;
		
		var tPerc:Number=_sliderWidgetContainer._x/_length;
		var tNewValue=_startRange+tPerc*(_endRange-_startRange);
		if (_value!=tNewValue)
		{
			_value=tNewValue;
			_valueTextField.text=""+_value;
			//trace("Value now "+_value);
			_oEB.broadcastEvent(new BasicEvent(SLIDER_VALUE_CHANGED_EVENT,this));
		}
	}
	
	private function updateWidgetPosition():Void
	{
		var tPos=_length*(_value-_startRange)/(_endRange-_startRange);
		_sliderWidgetContainer._x=tPos;
	}
	
	function get container():MovieClip{
		return _container;
	}
	
	function get value():Number{
		return _value;
	}
	function set value(tVal:Number){
		_value=tVal;
		_value=Math.max(_startRange,_value);
		_value=Math.min(_endRange,_value);
		_valueTextField.text=""+_value;
		updateWidgetPosition();
	}
}