class am.events.Call
{
	private var obj: Object;
	private var func;
	private var args: Array;

	function Call( obj , func )
	{
		if ( arguments.length == 0 ) return;
		this.obj = obj ? obj : null;
		this.func = func ? func : null;
		this.args = arguments.splice( 2 );
	}

	function solve(): Void
	{
		if ( func instanceof Function )
			func.apply( obj , args )
		else
			obj[ func ].apply( obj , args );
	}
	function copy(): Call
	{
		var copy: Call = new Call( obj , func );
		copy.setArguments( args );
		return copy;
	}
	//-- FUNCTION GETTER
	function getFunctionName(): String
	{
		if ( func instanceof Function )
		{
			for( var i in obj )
			{
				if ( obj[i] == func ) return i;
			}
			return null;
		} else return func;

	}
	function getEvaluateFunction(): Function
	{
		if ( func instanceof Function ) return func
		return obj[ func ];
	}
	//-- GETTER SETTER
	function getObject(): Object
	{
		return obj;
	}
	function setObject( obj: Object ): Void
	{
		this.obj = obj;
	}
	function setFunction( func ): Void
	{
		this.func = func;
	}
	function getFunction()
	{
		return func;
	}
	function setArguments( args: Array ): Void
	{
		this.args = args;
	}
	function getArguments(): Array
	{
		return arguments;
	}
}