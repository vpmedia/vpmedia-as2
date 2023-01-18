import wilberforce.ui.canvas.*;
import wilberforce.geom.*;
import wilberforce.util.drawing.drawingUtility
import wilberforce.util.drawing.styles.*;
import wilberforce.container.IVisualContainer;

import com.bourre.events.EventBroadcaster;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.commands.Delegate;
import com.bourre.log.Logger;

class wilberforce.ui.canvas.AbstractCanvas implements IVisualContainer
{
	private var _container:MovieClip;
	private var _backGround:MovieClip;
	private var _backgroundLayer:MovieClip;
	private var _transformableObjectLayer:MovieClip;
	private var _itemObjectLayer:MovieClip;
	
	private var _area:rect;
	private var _maskShapes:Array;
	private var _canvasItems:Array;
	private var _transformableObjects:Array;
	private var _canvasItemVisualElements:Array;
	
	private var _fillStyleOver:fillStyleFormat;
	private var _fillStyleOff:fillStyleFormat
	private var _lineStyleOver:lineStyleFormat
	private var _lineStyleOff:lineStyleFormat
	
	private var _oEB:EventBroadcaster;
	
	private var _backgroundPressedPoint:vector2D;
	
	private var _currentSelectedItemsArray:Array;
	
	private static var CANVAS_ITEMS_CHANGED_EVENT: EventType =  new EventType( "onCanvasItemsChanged" );
	private static var CANVAS_SELECTION_CHANGED_EVENT: EventType =  new EventType( "onCanvasSelectionChanged" );
	
	private var _currentSelectionArray:Array;
	
	
	function AbstractCanvas(container:MovieClip,area:rect)
	{
		//trace("Canvas "+area.width+","+area.height+" - "+container);
		//_area=area;
		_container=container;
		_maskShapes=new Array();
		_canvasItems=new Array();
		_transformableObjects=new Array();
		_canvasItemVisualElements=new Array();
		
		_currentSelectionArray=[];
		
		_backgroundLayer=_container.createEmptyMovieClip("backgroundLayer",_container.getNextHighestDepth());
		
		_itemObjectLayer=_container.createEmptyMovieClip("itemObjectLayer",_container.getNextHighestDepth());
		_transformableObjectLayer=_container.createEmptyMovieClip("transformableObjectLayer",_container.getNextHighestDepth());
		
		_createBackground();
		_backgroundLayer.onPress=Delegate.create(this,onTransformableObjectSelected);
		_backgroundLayer.useHandCursor=false;
		
		// Setup default styles for transformable objects
		_setDefaultSelectionStyles();
		
		setRect(area);
		
		_oEB = new EventBroadcaster( this );
	}
	
	private function _setDefaultSelectionStyles():Void
	{
		_fillStyleOver=new fillStyleFormat(0xDDDDFF,00);
		_fillStyleOff=new fillStyleFormat(0xDDDDDD, 0);
		_lineStyleOver=new lineStyleFormat(1,0x000000, 100);
		_lineStyleOff=new lineStyleFormat(1,0x000000, 0);		
	}
	
	/** Overwritten. Create background */
	private function _createBackground():Void
	{
		
	}
	
	private function _updateBackground():Void
	{
		//trace("drawing background "+_backgroundLayer);
		//trace("Canvas "+_area.width+","+_area.height+" - "+_backgroundLayer);
		var bgFill=new fillStyleFormat(0xEEEEEE,100,10);
		var bgOutline=new lineStyleFormat(0,0x333333,100,true);
		drawingUtility.drawRect(_backgroundLayer,_area,bgOutline,bgFill);
	}
	
	public function addMaskShape(shape:IShape2D)
	{
		_maskShapes.push(shape);
	}
	
	public function setRect(renderArea:rect):Void
	{
		_area=renderArea;
		_container._x=_area.left;
		_container._y=_area.top;
		
		_updateBackground();
	}
	
	public function addItem(item:AbstractCanvasItem,x:Number,y:Number)
	{		
		//item.moveTo(x,y);
		var _OBJdepth:Number=_itemObjectLayer.getNextHighestDepth();
		var _itemVisualElementContainer=_itemObjectLayer.createEmptyMovieClip("obj"+_OBJdepth,_OBJdepth);
		
		var _TOdepth:Number=_transformableObjectLayer.getNextHighestDepth();
		var _itemTransformableObjectContainer=_transformableObjectLayer.createEmptyMovieClip("to"+_TOdepth,_TOdepth);
		
		item.createVisualElement(_itemVisualElementContainer,x,y);
		var _itemTransformableObject:AbstractTransformableObject=item.createTransformableObject(_itemTransformableObjectContainer,_fillStyleOver,_fillStyleOff,_lineStyleOver,_lineStyleOff);
		_itemTransformableObject.addListener(this);
		_itemTransformableObject.addListener(item);
		_canvasItems.push(item);
		_oEB.broadcastEvent( new BasicEvent( CANVAS_ITEMS_CHANGED_EVENT,this ) );
	}
	
	public function onTransformableObjectSelected(e:BasicEvent)
	{
		
		var tTarget=AbstractTransformableObject(e.getTarget());
		for (var i in _canvasItems)
		{
			if (tTarget!=_canvasItems[i].getTransformableObject())
			{
				_canvasItems[i].deselect();
			}
		}
		if (tTarget) _currentSelectionArray=[tTarget];
		else _currentSelectionArray=[];
		
		_currentSelectedItemsArray=getSelectionItems();
		_oEB.broadcastEvent( new BasicEvent( CANVAS_SELECTION_CHANGED_EVENT,this ) );
		//trace("HERE");
	}
	
	public function onDeleteTransformableObject(e:BasicEvent)
	{
		Logger.LOG("Deleting object");
		trace("DELETING OBJECT");
		var tTarget=AbstractTransformableObject(e.getTarget());
		deleteObject(tTarget);
	}
	
	public function deleteObject(tTarget:AbstractTransformableObject)
	{
		for (var i:Number=0;i<_canvasItems.length;i++)
		{
			trace("Item removing");
			if (tTarget==_canvasItems[i].getTransformableObject())
			{
				trace("tranform object removing");
				Logger.LOG("Object found... removing");
				postDeleteAction(_canvasItems[i]);
				_canvasItems[i].remove();
				_canvasItems.splice(i,1);
				i--;
			}
		}
		_oEB.broadcastEvent( new BasicEvent( CANVAS_ITEMS_CHANGED_EVENT,this ) );
		
	}
	
	public function postDeleteAction(item:AbstractCanvasItem):Void
	{
		
	}
	
	public function deleteAllItems():Void
	{
		for (var i:Number=0;i<_canvasItems.length;i++)
		{
			_canvasItems[i].remove();
			_canvasItems.splice(i,1);
			i--;
		}
	}
	
	public function selectItemsWithinRect(tRect:rect)
	{
		var tHitTransformableObjects:Array=new Array();
		for (var i in _canvasItems)
		{
			var tItem:AbstractCanvasItem=_canvasItems[i];
			var tHit:Boolean=tItem.transformableObject.testRectIntersect(tRect);
			if (tHit)
			{
				//trace("Hit one")
				tHitTransformableObjects.push(tItem.transformableObject);
				tItem.transformableObject.select(true);
			}
		}
		_currentSelectionArray=tHitTransformableObjects;
		_currentSelectedItemsArray=getSelectionItems();
	}
	
	public function duplicateItem(canvasItem:AbstractCanvasItem)
	{
		var tDuplicate:AbstractCanvasItem=canvasItem.clone();
		addItem(tDuplicate,canvasItem.x+5,canvasItem.y+5);
		tDuplicate.transformableObject.select();
	}
	
	public function deleteSelection()
	{
		if (_currentSelectionArray.length>0) {
			for (var i in _currentSelectionArray)
			{
				deleteObject(_currentSelectionArray[i]);
			}
		}
		_currentSelectionArray=[];
	}
	
	public function duplicateSelection()
	{
		for (var i in _currentSelectedItemsArray)
		{
			duplicateItem(_currentSelectedItemsArray[i]);
		}
	}
	
	public function onTransformableObjectDeselected()
	{
		
	}
	
	public function onTransformableObjectNewDimensions()
	{
		
	}
	
	public function addListener(listeningObject)
	{
		
		_oEB.addListener(listeningObject);
	}
	public function removeListener(listeningObject)
	{
		_oEB.removeListener(listeningObject);
	}
	
	public function getSelectionTransformableObjects():Array
	{
		return _currentSelectionArray;
	}
	
	public function getSelectionItems():Array
	{
		var tSelectedItems:Array=[];
		for (var i:Number=0;i<_canvasItems.length;i++)
		{
			for (var j:Number=0;j<_currentSelectionArray.length;j++)
			{
				if (_currentSelectionArray[j]==_canvasItems[i].getTransformableObject())
				{
					tSelectedItems.push(_canvasItems[i]);
				}
			}
		}
		return tSelectedItems;
	}
	
}