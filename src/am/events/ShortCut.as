import am.events.*;

class am.events.ShortCut
{
	private var keyCodes: Array;
	private var keyPressed: Array;

	private var _callbacks: Array;

	function ShortCut()
	{
		keyCodes = arguments;

		keyPressed = new Array();
		_callbacks = new Array();

		Key.addListener( this );
	}

	private function onKeyDown(): Void
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

		if ( resolve ) broadcast();
	}

	private function onKeyUp(): Void
	{
		delete keyPressed[ Key.getCode() ];
	}

	function addCallBack( callback ): Void
	{
		if ( arguments.length > 1 )
		{
			var callback: Call = new Call();
			callback.setObject( arguments[0] );
			callback.setFunction( arguments[1] );
			callback.setArguments( arguments.splice( 2 ) );
		}

		removeListener( callback.getObject() );
		_callbacks.push( callback );
	}

	function removeListener( object: Object ): Void
	{
		var c: Number;
		var callback: Array;
		for ( c in _callbacks )
		{
			callback = _callbacks[ c ];
			if( object === callback.getObject() )
			{
				_callbacks.splice( c , 1 );
				return;
			}
		}
	}

	private function broadcast(): Void
	{
		var c: Number;
		for ( c in _callbacks )
		{
			_callbacks[ c ].solve();
		}
	}
}