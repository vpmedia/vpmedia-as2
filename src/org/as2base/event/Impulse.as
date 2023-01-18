import org.as2base.event.Executable;

class org.as2base.event.Impulse
{
	static private var instance: Impulse; 
	
	static function initialize( timeline: MovieClip ): Impulse
	{
		if( instance == undefined )
		{
			return instance = new Impulse( timeline );
		}
		
		delete instance.timeline.onEnterFrame;
		instance.timeline = timeline;
		instance.start();
	}
	
	static function connect( exe: Executable ): Boolean
	{
		return instance.addListener( exe );
	}
	
	static function disconnect( exe: Executable ): Boolean
	{
		return instance.removeListener( exe );
	}
	
	static function pause( Void ): Void
	{
		instance.stop();
	}
	
	static function resume( Void ): Void
	{
		instance.start();
	}
	
	static function nextFrame( Void ): Void
	{
		instance.broadcastMessage( 'execute' );
	}
	
	static function clear( Void ): Void
	{
		instance._listeners = new Array;
	}
	
	private var addListener: Function;
	private var removeListener: Function;
	private var broadcastMessage: Function;
	private var _listeners: Array;
	
	private var timeline: MovieClip;
	
	private function Impulse( timeline: MovieClip )
	{
		AsBroadcaster.initialize( this );
		
		this.timeline = timeline;
		
		start();
	}
	
	private function start( Void ): Void
	{
		timeline.onEnterFrame = function()
		{
			instance.broadcastMessage( 'execute' );
		}
	}
	
	private function stop( Void ): Void
	{
		delete timeline.onEnterFrame;
	}
}




















