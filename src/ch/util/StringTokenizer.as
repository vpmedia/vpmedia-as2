/*
Class	StringTokenizer
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	18 nov. 2005
*/

/**
 * Split a string into tokens and provides methods to
 * get each of them.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		18 nov. 2005
 * @version		1.0
 */
class ch.util.StringTokenizer
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * Default separators.
	 * <p>Constant value : " -/\\".</p>
	 */
	public static function get DEFAULT_SEPARATORS():String { return " 	-/\\:"; }
	
	//---------//
	//Variables//
	//---------//
	private var		_string:String; //string
	private var		_splitted:Array; //string splitted
	private var		_separators:Array; //separators
	private var		_currentIndex:Number; //index
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new StringTokenizer.
	 * <p>If the separators are not defined, or {@code separators.length} is 0,
	 * {@link #DEFAULT_SEPARATORS} will be used.</p>
	 * 
	 * @param	str			The {@code String} to read.
	 * @param	separators	The separators (each char is a separator) or {@code null}.
	 * @throws	Error		If {@code str} is {@code null}.
	 */
	public function StringTokenizer(str:String, separators:String)
	{
		//check
		if (str == null)
		{
			throw new Error(this+".<init> : str is undefined");
		}
		
		if (separators == null || separators.length == 0)
		{
			separators = DEFAULT_SEPARATORS;
		}
		
		_string = str;
		_separators = separators.split("");
		_currentIndex = -1;
		
		var ln:Number = _separators.length;
		for (var i:Number=1 ; i<ln ; i++)
		{
			str = str.split(_separators[i]).join(_separators[0]);
		}
		
		//split
		_splitted = str.split(_separators[0]);
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get if there is tokens to iterate.
	 * 
	 * @return	{@code true} if the {@link #nextToken()} method
	 * 			can be called.
	 */
	public function hasMoreTokens(Void):Boolean
	{
		var i:Number = _currentIndex+1;
		
		if (i > _splitted.length-1)
		{
			return false;
		}
		
		while (i < _splitted.length)
		{
			i++;
			
			//ok there is a word
			if (_splitted[i].length > 0)
			{
				return true;
			}
		}
		
		//no more token
		return false;
	}
	
	/**
	 * Iterate to the next token.
	 * 
	 * @return	The token.
	 */
	public function nextToken(Void):String
	{
		if (!hasMoreTokens())
		{
			throw new Error(this+".nextToken : no more tokens");
		}
		
		do
		{
			_currentIndex++;
		}
		while (_splitted[_currentIndex].length==0);
		
		return _splitted[_currentIndex];
	}
	
	/**
	 * Get the number of tokens into the {@code StringTokenizer}.
	 * 
	 * @return	The number of tokens.
	 */
	public function countTokens(Void):Number
	{
		return _splitted.length;
	}
	
	/**
	 * Get the source {@code String}.
	 * 
	 * @return	The source {@code String}.
	 */
	public function getStource(Void):String
	{
		return _string;
	}
	
	/**
	 * Get the separators.
	 * 
	 * @return	The separators.
	 */
	public function getSeparators(Void):String
	{
		return _separators.join("");
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the StringTokenizer instance.
	 */
	public function toString(Void):String
	{
		return "ch.util.StringTokenizer";
	}
}