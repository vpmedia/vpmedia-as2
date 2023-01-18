/*
* class GDelimiter (Singleton)
* Counts the started ISoundSources to avoid overlap 8 busy channels
*/

class org.audiopackage.util.GDelimiter
{
	static private var instance: GDelimiter;
	static function getInstance( Void ): GDelimiter
	{
		if ( instance == null )
		{
			instance = new GDelimiter();
		}
		return instance;
	}
	
	private var maxChannels: Number = 8;
	
	function push()
	{
		--maxChannels;
	}
	
	function pop()
	{
		++maxChannels;
	}
	
	function isLimit(): Boolean
	{
		return maxChannels == 0;
	}
	
}