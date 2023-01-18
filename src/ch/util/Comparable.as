/*
Class	Comparable
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	29 oct. 2005
*/

/**
 * Represent an object that can be compared to another.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		29 oct. 2005
 * @version		1.0
 */
interface ch.util.Comparable
{
	/**
	 * Compare the current {@code Object} to another.
	 * <p>This method must return 3 kinds of results :
	 * 	<ul>
	 * 		<li>A value less than 0 if {@code other} is bigger than
	 * 			the current {@code Object}.</li>
	 * 		<li>0 if {@code other} and the current {@code Object} are
	 * 			the same.</li>
	 * 		<li>A value greater than 0 if {@code other} is lower than
	 * 			the current {@code Object}.</li>
	 * 	</ul>
	 * </p>
	 * 	
	 * @param	other	The {@code Object} to compare.
	 * @return	A {@code Number} indicating the size of {@code other}
	 * 			compared to the current {@code Object}.
	 */
	public function compareTo(other:Object):Number;
}