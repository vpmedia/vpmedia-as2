import com.flade.app.Runnable;
import com.flade.app.Call;
import com.flade.app.Proxy

/**
 * 
 * @author  Younes
 * @version 1.0
 * @since   
 */
class com.flade.app.Timeline 
{
	private static var instance: Timeline; 
	private var scope: MovieClip;
	private var listeners: Array;
	
	
	public function Timeline( scope: MovieClip )
	{
		this.scope = scope;	
		listeners = new Array();
		start();
		//trace(this+ "initialize");
	}
		

	public function addTimelineListener( handler:Runnable ): Void
	{		
		listeners.push(handler);
		if ( listeners.length == 1 ) resume();
	}

	/**
	 * 
	 * @param   handler 
	 */
	public function removeTimelineListener( handler:Runnable ): Boolean
	{
		var listener:Object;
		for ( var i:Number; i<listeners.length; i++ )
		{
			if ( listeners[i] == handler )
			{
				listeners.splice(i,1);
				if ( listeners.length == 0 ) pause();
				return true;
			}
		}
		return false;
	}
	
	
	/**
	 * 	Public function 
	 */
	public function pause(): Void
	{
		stop();
	}
	
	public function resume(): Void
	{
		start();
	}
		
	/**
	 * 	private function 
	 */
	private function start(): Void
	{
		if ( listeners.length == 0 ) return;
		scope.onEnterFrame = Proxy.create(this,onRun);
	}
	
	private function onRun():Void
	{		
		for (var i:Number = 0; i < listeners.length; i++)
		{
			Call.create(listeners[i],Runnable(listeners[i]).run)
		}
	}
	
	private function stop(): Void
	{
		delete scope.onEnterFrame;
	}
	
	public function toString():String
	{
		return "[Object Timeline]";
	}
}