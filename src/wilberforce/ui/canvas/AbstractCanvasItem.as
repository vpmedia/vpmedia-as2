import wilberforce.ui.canvas.*;
import wilberforce.geom.*;
import wilberforce.util.drawing.styles.*;

class wilberforce.ui.canvas.AbstractCanvasItem
{
	private var _itemContainer:MovieClip;
	private var _transformableObjectContainer:MovieClip;
	private var _transformableObject:AbstractTransformableObject;
	
	private var _x:Number;
	private var _y:Number;
	private var _width:Number;
	private var _height:Number;
	private var _activeRect:rect;

	function AbstractCanvasItem()
	{
		_width=300;
		_height=150;
	}
	
	function clone():AbstractCanvasItem
	{
		var tItem=new AbstractCanvasItem();
		return tItem;
	}
			
	public function createVisualElement(container:MovieClip,x:Number,y:Number)
	{
		_x=x;
		_y=y;
		_itemContainer=container;
		_itemContainer._x=x;
		_itemContainer._y=y;		
	}
	
	public function get x():Number
	{
		return _x;
	}
	
	public function get y():Number
	{
		return _y;
	}
	
	public function setDepth(tNumber)
	{
		_itemContainer.swapDepths(tNumber);
		_transformableObjectContainer.swapDepths(tNumber);
	}
	
	public function getTransformableObject():AbstractTransformableObject
	{
		return _transformableObject
	}
	
	/** Create and return a transformable object to manipulate this canvas item */
	public function createTransformableObject(transformableObjectContainer:MovieClip,fillStyleOver:fillStyleFormat,fillStyleOff:fillStyleFormat,lineStyleOver:lineStyleFormat,lineStyleOff:lineStyleFormat):AbstractTransformableObject
	{
		_transformableObjectContainer=transformableObjectContainer;
		_activeRect=new rect(_x,_y,_x+_width,_y+_height);
		_transformableObject=new transformableRect(_transformableObjectContainer,_activeRect,true,true,false,fillStyleOver,fillStyleOff,lineStyleOver,lineStyleOff);
		return _transformableObject;
	}
	
	public function updateShape(shape:IShape2D)
	{
		
	}
	
	public function get transformableObject():AbstractTransformableObject
	{
		return _transformableObject;
	}
	public function select():Void
	{
		
	}
	
	public function remove():Void
	{
		_itemContainer.removeMovieClip();
		_transformableObjectContainer.removeMovieClip();
	}
	
	public function deselect():Void
	{
		_transformableObject.deselect();
	}
}