import org.as2base.event.*;

class org.as2base.event.ShortCut
{
	private var keyCodes: Array;
	private var exe: Executable;
	private var keyPressed: Array;
	
	function ShortCut( keyCodes /*, Executable*/ )
	{
		if( keyCodes instanceof Array )
		{
			this.keyCodes = keyCodes;
		}
		else
		{
			keyCodes = [ keyCodes ];
		}
		
		if( arguments.length == 2 )
		{
			exe = arguments[1];
		}
		else
		{
			//-- Create Call on the fly
			//
			exe = new Call( arguments[1] , arguments[2] );
			Call( exe ).setArguments( arguments.slice( 3 ) );
		}
		
		Key.addListener( this );
		
		keyPressed = new Array;
	}
	
	function onKeyDown( Void ): Void
	{
		keyPressed[ Key.getCode() ] = true;
		
		var k: Number;
		var resolve: Boolean = true;
		for ( k in keyCodes )
		{
			if ( !keyPressed[ keyCodes[ k ] ] )
			{
				resolve = false;
				break;
			}
		}

		if ( resolve ) exe.execute();
	}
	
	function onKeyUp( Void ): Void
	{
		keyPressed[ Key.getCode() ] = false;
	}
	
	function execute(){}
}