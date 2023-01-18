/*
Class	ScrollBarManager
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	1 mars 2006
*/

//import
import ch.component.scrollbar.ScrollBarModel;

/**
 * Manager of a {@code ScrollBarModel}.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		1 mars 2006
 * @version		1.6
 */
interface ch.component.scrollbar.ScrollBarManager
{
	/**
	 * Add a {@code ScrollBarModel} to manage.
	 * 
	 * @param	scr	The {@code ScrollBarModel} to add.
	 */
	public function addScrollBarModel(scr:ScrollBarModel):Void;
	
	/**
	 * Remove a {@code ScrollBarModel}.
	 * 
	 * @param	scr	The {@code ScrollBarModel} to remove.
	 */
	public function removeScrollBarModel(scr:ScrollBarModel):Void;
}