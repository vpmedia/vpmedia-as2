import com.bumpslide.util.StageProxy;

class com.bumpslide.util.StageResizeEvent
{
	var type:String;
	var width:Number;
	var height:Number;	
	
	
	function StageResizeEvent(w:Number,h:Number)
	{
		type = StageProxy.ON_RESIZE_EVENT;
		width = w;
		height = h;
	}
}
