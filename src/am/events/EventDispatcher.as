class am.events.EventDispatcher
{
	static var _EventDispatcher: EventDispatcher;

	static function initialize( object ): Void
	{
		if ( _EventDispatcher == undefined ) _EventDispatcher = new EventDispatcher;

		object.addEventListener = _EventDispatcher.addEventListener;
		object.removeEventListener = _EventDispatcher.removeEventListener;
		object.dispatchEvent = _EventDispatcher.dispatchEvent;
		object.getListeners = _EventDispatcher.getListeners;
	}

	function addEventListener( event: String , handler ): Void
	{
		var queueName = "__q_" + event;
		if ( this[ queueName ] == undefined )
		{
			this[ queueName ] = new Array();
			_global.ASSetPropFlags( this , queueName , 1 );
		}
		this[ queueName ].push( handler );
	}

	function removeEventListener( event: String , handler ): Boolean
	{
		var listeners: Array = this[ "__q_" + event ];
		var listener;
		var l: Number;
		for ( l in listeners )
		{
			listener = listeners[l];
			if ( listener == handler )
			{
				listeners.splice( l , 1 );
				if ( listeners.length == 0 ) delete this[ "__q_" + event ];
				return true;
			}
		}
		return false;
	}

	function getListeners( event: String ): Array
	{
		if ( this[ "__q_" + event ] ) return this[ "__q_" + event ];
		return null;
	}

	function dispatchEvent( event: String ): Void
	{
		var args: Array = arguments.slice( 1 );
		var listeners: Array = this[ "__q_" + event ];
		var l: Number, listener;
		for ( l in listeners )
		{
			listener = listeners[l];
			if ( typeof( listener ) == 'function' ) listener.apply( null , args )
			else listener[ event ].apply( listener , args );
		}
	}

}