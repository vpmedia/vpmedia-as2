/*
Class	Comparator
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	29 oct. 2005
*/

/**
 * Interface Comparator.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		29 oct. 2005
 * @version		1.0
 */
interface ch.util.Comparator
{
	/**
	 * Compare two {@code Object} between them.
	 * <p>This method must return 3 kinds of results :
	 * 	<ul>
	 * 		<li>A value less than 0 if {@code b} is bigger than
	 * 			{@code a}.</li>
	 * 		<li>0 if {@code b} and {@code a} are the same.</li>
	 * 		<li>A value greater than 0 if {@code b} is lower than
	 * 			{@code a}.</li>
	 * 	</ul>
	 * </p>
	 * 
	 * @param	a	The first {@code Object}.
	 * @param	b	The second {@code Object}.
	 * @return	A {@code Number} indicating the size of {@code b}
	 * 			compared to {@code a}.
	 */
	public function compare(a:Object, b:Object):Number;
}