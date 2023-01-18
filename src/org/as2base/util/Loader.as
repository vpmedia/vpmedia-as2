import org.as2base.event.*;

class org.as2base.util.Loader
	implements Executable
{
	static var MAX_TIMEOUT: Number = 300;
	
	private var loadable: Object;
	private var url: String;
	private var infoObj: Object;
	
	#include "AsBroadcaster.as"
	
	/*
		mode declares current loading mode ( -1 = error )
		0 - nothing
		1 - idle
		2 - requesting
		3 - downloading
		4 - wait for first frame (MovieClip only, other finished)
		5 - finished (MovieClip only)
	*/
	
	private var mode: Number;
	private var timer: Number;
	private var _loaded: Number;
	
	public var onLoaderRequest: Function;
	public var onLoaderStart: Function;
	public var onLoaderProcess: Function;
	public var onLoaderComplete: Function;
	public var onLoaderInit: Function;

	public var onLoaderError: Function;
	
	function Loader( loadable: Object, url: String, infoObj: Object )
	{
		this.loadable 	= loadable;
		this.url 		= url;
		this.infoObj 	= infoObj;
		
		AsBroadcaster.initialize( this );
		
		addListener( this );
		
		timer = 0;
		mode  = 0;
	}
	
	function load( Void ): Void
	{
		if( loadable instanceof MovieClip )
		{
			loadable.loadMovie( url );
			
			execute = loadClip;
		}
		
		Impulse.connect( this );
		
		mode = 1;
	}
	
	/*
		Executable Implementation
	*/
	function execute(){};
	
	/*
		Watch MovieClip Loading
	*/
	private function loadClip()
	{
		var loaded: Number = loadable.getBytesLoaded();
		var total: Number  = loadable.getBytesTotal();
		
		switch( mode )
		{
			case 1:
			
				if( loadable._url.indexOf( url ) > -1 )
				{
					broadcastMessage( 'onLoaderRequest', this );
					mode = 2;
				}
				break;
				
			case 2: 
				
				if( total > -1 )
				{
					broadcastMessage( 'onLoaderStart', this, loaded, total );
					_loaded = loaded;
					mode = 3;
				}
				else
				{
					if( ++timer > MAX_TIMEOUT )
					{
						mode = -1;
						Impulse.disconnect( this );
						broadcastMessage( 'onLoaderError', this, 'timeout' );
					}
				}
				break;
				
			case 3:
			
				if( loaded == total )
				{
					broadcastMessage( 'onLoaderComplete', this, loaded, total );
					mode = 4;
				}
				else
				{
					if( loaded > _loaded )
					{
						broadcastMessage( 'onLoaderProcess', this, loaded, total );
						_loaded = loaded;
					}
				}
				break;
				
			case 4:
			
				if( loadable._currentframe )
				{
					broadcastMessage( 'onLoaderInit', this, loaded, total );
					mode = 5;
					
					Impulse.disconnect( this );
				}
				break;
		}
	}
	
	function getInfoObj( Void ): Object
	{
		return infoObj;
	}
}



















