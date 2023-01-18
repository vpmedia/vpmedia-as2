import wilberforce.geom.circle;
import wilberforce.util.drawing.drawingUtility;
import wilberforce.util.drawing.styles.*;
import wilberforce.util.textField.textFieldUtility;
import wilberforce.geom.rect;
import com.bourre.commands.Delegate;

import com.bourre.events.EventBroadcaster;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;


class wilberforce.ui.forms.AbstractRadioButton
{
	private var _container:MovieClip;
	private var _width:Number;
	private var _height:Number;
	
	private var _radioSelectedContainer:MovieClip;
	private var _textFieldContainer:MovieClip;
	private var _radioSelectedBackground:MovieClip;
	private var _hiddenButtonContainer:MovieClip;
	
	private var _selected:Boolean;
	private var _label:String;
	
	private var _textFormat:TextFormat;
	private var _rollOverTextFormat:TextFormat;
	
	private var _textField:TextField;
	
	private var _oEB:EventBroadcaster;
	public var index:Number;
	
	private static var RADIO_BUTTON_SELECTED_EVENT : EventType =  new EventType( "onRadioButtonSelected" );
	
	function AbstractRadioButton(container:MovieClip,tIndex:Number,label:String,startSelected:Boolean,width:Number,height:Number,textFormat:TextFormat,rollOverTextFormat:TextFormat,radioButtonBackgroundLinkage:String,radioButtonCheckmarkLinkage:String)
	{
		_container=container;
		_width=width;
		_height=height;
		_label=label;
		index=tIndex;
				
		_oEB = new EventBroadcaster( this );
		
		_textFormat=textFormat;
		_rollOverTextFormat=rollOverTextFormat
		if (!textFormat) _textFormat=textFieldUtility.defaultTextFormat;
		//trace("LINKAGE "+radioButtonBackgroundLinkage);
		if (!radioButtonBackgroundLinkage)
		{
			_radioSelectedBackground=_container.createEmptyMovieClip("radioBackground",_container.getNextHighestDepth());
			_radioSelectedContainer=_container.createEmptyMovieClip("selectedIcon",_container.getNextHighestDepth());
			renderDefaultItems();
		}
		else {
			_radioSelectedBackground=_container.attachMovie(radioButtonBackgroundLinkage,"radioBackground",_container.getNextHighestDepth());
			_radioSelectedContainer=_container.attachMovie(radioButtonCheckmarkLinkage,"selectedIcon",_container.getNextHighestDepth());
			//trace("New container "+_radioSelectedContainer+" - from "+radioButtonCheckmarkLinkage)
		}
		_textFieldContainer=_container.createEmptyMovieClip("textFieldContainer",_container.getNextHighestDepth());
		_hiddenButtonContainer=_container.createEmptyMovieClip("hiddenButtonContainer",_container.getNextHighestDepth());
		
		_render();
		if (startSelected)
		{
			select();
		}
		else {
			deselect();
		}
	}
	
	private function renderDefaultItems()
	{
		var circlex=_height/2;
		var circley=_height/2;
		var circleRadius=_height/2;
		
		var radiusGap=4;
		
		var tBackgroundFillStyle=new fillStyleFormat(0xFFFFFF,100,0);
		var tForegoundFillStyle=new fillStyleFormat(0xAAAAAA,100,0);
		var tLineStyle=new lineStyleFormat(0,0xAAAAAA,100,true);
		
		
		var tOuterCircle=new circle(circlex,circley,circleRadius);
		var tInnerCircle=new circle(circlex,circley,circleRadius-radiusGap);
		
		drawingUtility.drawCircle(_radioSelectedBackground,tOuterCircle,tLineStyle,tBackgroundFillStyle);
		drawingUtility.drawCircle(_radioSelectedContainer,tInnerCircle,tLineStyle,tForegoundFillStyle);
	}
	
	// Overwrite with specific implementation
	private function _render()
	{
		
		var radioSpacing=5;
		var tTextFieldX:Number=_radioSelectedBackground._width+radioSpacing;
		//_label="<font face=\""+_textFormat.font+"\">"+_label+"</font>";
		//trace("Textformat is "+_textFormat.font);
		_textField=textFieldUtility.createTextField(_textFieldContainer ,tTextFieldX,0,_width-tTextFieldX,_height,_textFormat,_label,false,true);
		_height=Math.max(_height,_textField.textHeight);
		
		var tButtonRect:rect=new rect(0,0,_width,_height);
		drawingUtility.drawRect(_hiddenButtonContainer,tButtonRect,null,fillStyleFormat.transparentFillStyle);
		_hiddenButtonContainer.onPress=Delegate.create(this,onPress);
		_hiddenButtonContainer.onRollOver=Delegate.create(this,onRollOver);
		_hiddenButtonContainer.onRollOut=Delegate.create(this,onRollOut);
	}
	
	public function onPress():Void
	{
		select();
		// Distribute event
		_oEB.broadcastEvent( new BasicEvent( RADIO_BUTTON_SELECTED_EVENT,this ) );
		
	}
	
	public function onRollOver():Void
	{
		if (_rollOverTextFormat) _textField.setTextFormat(_rollOverTextFormat);
	}
	
	public function onRollOut():Void
	{
		if (_textFormat) _textField.setTextFormat(_textFormat);
	}
	
	public function get height():Number
	{
		return _height;
	}
	
	public function select()
	{
		_radioSelectedContainer._visible=true;
	}
	
	public function deselect()
	{
		_radioSelectedContainer._visible=false;
	
	}
	
	public function addListener(listeningObject)
	{
		_oEB.addListener(listeningObject);
	}
	public function removeListener(listeningObject)
	{
		_oEB.removeListener(listeningObject);
	}
}