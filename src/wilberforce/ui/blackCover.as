import wilberforce.util.drawing.drawingUtility;
import wilberforce.util.drawing.styles.*;
import wilberforce.geom.rect;

class wilberforce.ui.blackCover
{
	var _container:MovieClip;
	static var _fillStyle=new fillStyleFormat(0x000000,30,0);
	
	function blackCover(container:MovieClip)
	{
		_container=container;
		var tWidth:Number=Stage.width;
		var tHeight:Number=Stage.height;
		
		
		var tRect:rect=new rect(0,0,tWidth,tHeight);
		drawingUtility.drawRect(_container,tRect,null,_fillStyle);
		// Get the black area to block mouse events
		_container.onPress=function()
		{
			
		}
		_container.useHandCursor=false;
		hide();
	}
	
	function show()
	{
		_container._visible=true;
	}
	function hide()
	{
		_container._visible=false;
	}
	function fadeIn()
	{
		
	}
	
	function fadeOut()
	{
		
	}
}