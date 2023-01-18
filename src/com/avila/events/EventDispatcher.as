import com.avila.events.IEventDispatcher;
import com.avila.events.Event;
import com.avila.utils.ArrayUtil;

/**
 * The Event Dispatcher object is used as a base class for objects which dispatch events, or as a class
 * which can be used in combination with the IEventDispatcher interface to create a composite solution.
 *
 * @langversion Actionscript 2.0
 * @playerversion Flash 8
 *
 * @author Michael Avila
 */
class com.avila.events.EventDispatcher implements IEventDispatcher
{
	private var listeners:Object;

	/**
	 * Creates a new EventDispatcher object.
	 */
	public function EventDispatcher()
	{
		listeners = new Object();
	}
	
	/**
	 * @inheritDoc
	 */
	public function addEventListener( type:String, scope:Object, listener:Function ):Void
	{
		if ( !hasEventListener( type ) )
		{
			listeners[ type ] = new Array();
		}
		else
		{			
			for ( var i:Number=0; i<listeners[type].length; i++ )
			{
				if ( listeners[type][i][0] == scope && listeners[type][i][1] == listener )
				{
					return;
				}
			}
		}
				
		listeners[type].push( [scope, listener] );
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeEventListener( type:String, scope:Object, listener:Function ):Void
	{
		if ( hasEventListener( type ) )
		{
			for ( var i:Number=0; i<listeners[type].length; i++ )
			{
				if ( listeners[type][i][0] == scope && listeners[type][i][1] == listener )
				{
					listeners[type].splice( i, 1 );
				}
			}
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function hasEventListener( type:String ):Boolean
	{
		return listeners[ type ] != null;
	}
	
	/**
	 * @inheritDoc
	 */
	public function dispatchEvent( event:Event ):Void
	{
		var recipients:Array = listeners[ event.type ];
		
		var method:Function;
		var scope:Object;
		
		for ( var i:Number=0; i<recipients.length; i++ )
		{
			scope = recipients[i][0];
			method = recipients[i][1];
			
			method.apply( scope, [event] );
		}
	}
}