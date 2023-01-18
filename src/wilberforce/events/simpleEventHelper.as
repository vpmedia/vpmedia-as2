import com.bourre.events.EventBroadcaster;

class wilberforce.events.simpleEventHelper
{
		
	private var _oEB:EventBroadcaster;
	
	public function simpleEventHelper()
	{
		_oEB = new EventBroadcaster( this );
	}
	
	public function addListener(listeningObject:Object):Void
	{
		_oEB.addListener(listeningObject);
	}
	public function removeListener(listeningObject:Object):Void
	{
		_oEB.removeListener(listeningObject);
	}
	
	public function addEventListener(t:String,oL)
	{
		
		_oEB.addEventListener(arguments[0],arguments[1],arguments[2],arguments[3]);//t,oL,.add
	}
	
	public function removeEventListener(t:String,oL)
	{
		_oEB.removeEventListener(t,oL);
	}
}