import org.as2base.event.Executable;

class org.as2base.event.Call
	implements Executable
{
	private var o: Object;
	private var f: Function;
	private var a: Array;
	
	static function create(): Function
	{
		if( arguments.length == 1 )
		{
			var exe: Executable = arguments[0];
			
			return function()
			{
				return exe.execute();
			}
		}
		
		var c: Call = new Call( arguments[0], arguments[1] );
		
		if( arguments.length > 2 )
		{
			c.setArguments( arguments.splice( 2 ) );
			
			return function()
			{
				return c.execute();
			}
		}
		else
		{
			return function()
			{
				return c.execute.apply( c, arguments );
			}
		}
	}
	
	function Call( o: Object, f )
	{
		this.o = o;
		
		if( f instanceof Function )
		{
			this.f = f;
		}
		else
		{
			this.f = o[ f ];
		}
		
		a = arguments.splice( 2 );
	}
	
	function execute()
	{
		if ( arguments.length ) return f.apply( o , arguments )
			else return f.apply( o , a );
	}
	
	/*
		Getter-Setter
	*/
	
	function setArguments( args: Array ): Void
	{
		a = args;
	}
	
	function getArguments( Void ): Array
	{
		return a;
	}
	
	function setFunction( func: Function ): Void
	{
		f = func;
	}
	
	function getFunction( Void ): Function
	{
		return f;
	}
	
	function setObject( obj ): Void
	{
		o = obj;
	}
	
	function getObject( Void )
	{
		return o;
	}
}