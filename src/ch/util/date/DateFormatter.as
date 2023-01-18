/*
Class	DateFormatter
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	25 nov. 2005
*/

/**
 * Represent a formatter of {@code Date}.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		25 nov. 2005
 * @version		1.0
 */
interface ch.util.date.DateFormatter
{
	/**
	 * Format a {@code Date}.
	 * 
	 * @param	d	The {@code Date} to format.
	 * @return	The formatted {@code Date}.
	 */
	public function format(d:Date):String;
}