import org.as2base.event.*;

/*
	Stores a list of CallObjs to call them by a single execute()
*/

class org.as2base.event.Batch extends Array
	implements Executable
{
	function Batch()
	{
		splice.apply( this , [ 0 , 0 ].concat( arguments ) );
	}
	
	function push(): Number
	{
		if( arguments.length == 1 )
		{
			return super.push( arguments[0] );
		}
		
		//-- Create Call on the fly
		//
		var call: Call = new Call( arguments[0], arguments[1] );
		call.setArguments( arguments.slice( 2 ) );
		
		return super.push( call );
	}
	
	function execute()
	{
		var l: Number = length;
		
		if( arguments.length )
		{
			var f: Function = Call.prototype.execute;
			
			while( --l > -1 )
			{
				f.apply( this[l], arguments );
			}
		}
		else
		{
			while( --l > -1 )
			{
				this[l].execute();
			}
		}
	}
}