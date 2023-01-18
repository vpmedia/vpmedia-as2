import wilberforce.layout.AbstractLayoutItem;
import wilberforce.ui.forms.abstractScrollbar;
import wilberforce.layout.gridLayoutFixed;
import wilberforce.geom.rect;
//import wilberforce.ui.canvas.transformableObjectModifiedEvent;
import com.bourre.events.BasicEvent;

import wilberforce.events.simpleEventHelper;

class wilberforce.layout.gridLayoutFixedScrolling
{
	private var _scrollbar:abstractScrollbar;
	private var _gridLayout:gridLayoutFixed;
		
	private var _scrollbarContainer:MovieClip;
	private var _gridLayoutContainer:MovieClip;
		
	private var _container:MovieClip;
		
	private var _width:Number;
	private var _height:Number;
		
	private var _scrollBarWidth:Number;
	private var _gridWidth:Number;
		
	function gridLayoutFixedScrolling(container:MovieClip,width:Number,height:Number,xspacing:Number,yspacing:Number,itemWidth:Number,itemHeight:Number)
	{
		_container=container;
		_width=width;
		_height=height;
		
		_scrollbarContainer=_container.createEmptyMovieClip("scrollbarContainer",_container.getNextHighestDepth());
		_gridLayoutContainer=_container.createEmptyMovieClip("gridLayoutContainer",_container.getNextHighestDepth());
		
		_scrollbar=new abstractScrollbar(_scrollbarContainer,_height);
		_scrollBarWidth=_scrollbarContainer._width;
		_gridWidth=width-_scrollBarWidth;
		
		_scrollbarContainer._x=_gridWidth;
		
		_gridLayout=new gridLayoutFixed(_gridLayoutContainer,_gridWidth,_height,xspacing,yspacing,itemWidth,itemHeight);
		_gridLayout.addListener(this);
		_scrollbar.setProperties(5,10);
		_scrollbar.addListener(this);			
	}
		
	function setItems(items:Array):Void
	{
		//trace("Setting items "+items);
		_gridLayout.setItems(items);
		
	}
		
	public function onLayoutDimensionsChanged(e : BasicEvent)
	{		
		var tDimensions:Object=BasicEvent( e ).getTarget();	
		_scrollbar.setProperties(tDimensions.rows,tDimensions.totalRows);
	}
	
	public function onScroll(e : BasicEvent)
	{
		var tScrollValue:Number=BasicEvent( e ).getTarget();
		//Logger.LOG("New scroll Position - "+tScrollValue,LogLevel.INFO);
		_gridLayout.rowOffset=tScrollValue;
	}
	
	public function addListener(o:Object)
	{
		_gridLayout.addListener(o);
	}
		
	public function removeListener(o:Object)
	{
		_gridLayout.removeListener(o);
	}
}