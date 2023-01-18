import wilberforce.ui.forms.AbstractRadioButton;
import wilberforce.events.simpleEventHelper;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;

class wilberforce.ui.forms.AbstractRadioButtonCollection extends simpleEventHelper
{
	private var _container:MovieClip;
	private var _labels:Array;
	private var _dataArray:Array;
	private var _width:Number;
	private var _radioButtonsArray:Array;
	private var _height:Number;
	private static var _buttonYseperation:Number=5;
	private var _currentSelectionIndex:Number;
	
	private static var RADIO_BUTTON_COLLECTION_SELECTION_EVENT : EventType =  new EventType( "onRadioButtonCollectionSelectionChanged" );
	
	function AbstractRadioButtonCollection(container:MovieClip,labels:Array,dataArray:Array,width:Number,selectedIndex:Number,textFormat:TextFormat,rollOverTextFormat:TextFormat,radioButtonBackgroundLinkage:String,radioButtonCheckmarkLinkage:String)
	{
		//trace("Textformat is "+textFormat.font);
		_container=container;
		_labels=labels;
		_dataArray=dataArray;
		_width=width;
		_radioButtonsArray=new Array();
		
		
		var ty=0;
		var tItemHeight=30;
		for (var i=0;i<_labels.length;i++)
		{
			var tLabel=_labels[i];
			var tRadioButtonContainer=_container.createEmptyMovieClip("radioButton"+i,_container.getNextHighestDepth());
			var tStartSelected=false;
			if (selectedIndex==i) tStartSelected=true;
			var tRadioButton:AbstractRadioButton=new AbstractRadioButton(tRadioButtonContainer,i,tLabel,tStartSelected,_width,tItemHeight,textFormat,rollOverTextFormat,radioButtonBackgroundLinkage,radioButtonCheckmarkLinkage);
			tRadioButton.addListener(this);
			_radioButtonsArray.push(tRadioButton);
			tRadioButtonContainer._y=ty;//tItemHeight*i;
			ty+=tRadioButton.height;
			ty+=_buttonYseperation;
		}
		
		_height=ty;//_labels.length*tItemHeight;
	}
	public function get height():Number
	{
		return _height;
	}
	public function get width():Number
	{
		return _width;
	}
	
	public function onRadioButtonSelected(e:BasicEvent)
	{
		//trace("Press found");
		var tTarget:AbstractRadioButton=AbstractRadioButton(e.getTarget());
		for (var i in _radioButtonsArray)
		{
			if ( _radioButtonsArray[i]!=tTarget) _radioButtonsArray[i].deselect();
		}
		_currentSelectionIndex=tTarget.index;
		_oEB.broadcastEvent( new BasicEvent( RADIO_BUTTON_COLLECTION_SELECTION_EVENT,_currentSelectionIndex ) );
		
	}
}