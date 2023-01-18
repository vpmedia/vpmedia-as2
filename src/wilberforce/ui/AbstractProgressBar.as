
import wilberforce.geom.rect;
import wilberforce.util.drawing.drawingUtility;
import wilberforce.util.drawing.styles.*;
import com.bourre.events.BasicEvent;

class wilberforce.ui.AbstractProgressBar
{
	private var _container:MovieClip;
	private var _backgroundContainer:MovieClip;
	private var _foregroundContainer:MovieClip;
	private var _rect:rect;
	
	public function AbstractProgressBar(container:MovieClip,tRect:rect)
	{
		_rect=tRect;
		render(tRect);
		_container=container;
		_backgroundContainer=_container.createEmptyMovieClip("background",_container.getNextHighestDepth());
		_foregroundContainer=_container.createEmptyMovieClip("foreground",_container.getNextHighestDepth());
		//_foregroundContainer._xscale=0.01;
		render();
		_foregroundContainer._xscale=0.01;
		//onProgress(0.01);
	}
	
	public function onProgress(e:BasicEvent)
	{
		var perc=e.getTarget();
		//trace("Perc is "+perc);
		_foregroundContainer._xscale=perc;
	}
	
	public function render():Void
	{
		var tOutlineStyle:lineStyleFormat=new lineStyleFormat(0,0xCCCCCC,100,true);
		var tForeGroundFillStyle:fillStyleFormat=new fillStyleFormat(0xCCCCCC,100,0);//fillStyleFormat.transparentFillStyle;
		drawingUtility.drawRect(_backgroundContainer,_rect,tOutlineStyle,fillStyleFormat.transparentFillStyle);
		drawingUtility.drawRect(_foregroundContainer,_rect,tOutlineStyle,tForeGroundFillStyle);
	}
	
	// To allow it to listen directly to a lib
	
}