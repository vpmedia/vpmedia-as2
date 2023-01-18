import org.as2base.util.*;

class org.as2base.util.LoadQueue extends Array
{
	public var onLoadQueueComplete: Function;
	
	private var currentLoader: Loader;
	
	#include "AsBroadcaster.as"
	
	function LoadQueue()
	{
		splice.apply( this , [ 0 , 0 ].concat( arguments ) );
		
		AsBroadcaster.initialize( this );
	}
	
	function load( Void ): Void
	{
		currentLoader = Loader( pop() );
		
		if( currentLoader )
		{
			currentLoader.addListener( this );
			currentLoader.load();
		}
		else
		{
			onLoadQueueComplete();
		}
	}
	
	function onLoaderRequest( Void ): Void
	{
		broadcastMessage.apply( this, [ 'onLoaderRequest' ].concat( arguments ) );
	}
	
	function onLoaderStart( Void ): Void
	{
		broadcastMessage.apply( this, [ 'onLoaderStart' ].concat( arguments ) );
	}
	
	function onLoaderProcess( Void ): Void
	{
		broadcastMessage.apply( this, [ 'onLoaderProcess' ].concat( arguments ) );
	}
	
	function onLoaderComplete( Void ): Void
	{
		broadcastMessage.apply( this, [ 'onLoaderComplete' ].concat( arguments ) );
	}
	
	function onLoaderInit( Void ): Void
	{
		broadcastMessage.apply( this, [ 'onLoaderInit' ].concat( arguments ) );
		
		currentLoader.removeListener( this );
		
		load();
	}
}