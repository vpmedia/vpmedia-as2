import org.as2base.event.*;

class org.as2base.event.Recall extends Call
{
	function Recall()
	{
		super.constructor.apply( this, arguments );
	}
	
	function start( Void ): Void
	{
		Impulse.connect( this );
	}
	
	function stop( Void ): Void
	{
		Impulse.disconnect( this );
	}
}