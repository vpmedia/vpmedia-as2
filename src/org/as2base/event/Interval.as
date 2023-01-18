import org.as2base.event.*;

class org.as2base.event.Interval
	implements Executable
{
	private var exe: Executable;
	private var length: Number;
	private var frame: Number;

	function Interval()
	{
		if( arguments.length == 2 )
		{
			exe 	= arguments[0];
			length 	= arguments[1];
		}
		else
		{
			//-- Create Call on the fly
			//
			exe = new Call( arguments[0] , arguments[1] );
			length 	= arguments[2];
			Call( exe ).setArguments( arguments.slice( 3 ) );
		}

		reset();
	}
	
	function reset(): Void
	{
		frame = 0;
		Impulse.connect( this );
	}

	function clear(): Void
	{
		Impulse.disconnect( this );
	}

	function execute()
	{
		if ( ++frame % length == 0 )
		{
			exe.execute();
		}
	}
}