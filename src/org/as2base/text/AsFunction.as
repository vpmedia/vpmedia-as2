import org.as2base.event.Executable;

class org.as2base.text.AsFunction
{
	private var id: Number;

	static private var instanceCount: Number = 0;
	static private var exes: Array = new Array();

	static function resolve( strId: String ): Void
	{
		exes[ parseInt( strId ) ].execute();
	}

	function AsFunction( exe: Executable )
	{
		exes[ id = instanceCount++ ] = exe;
	}

	function toString(): String
	{
		return "'asfunction:org.as2base.text.AsFunction.resolve," + id + "'";
	}
}