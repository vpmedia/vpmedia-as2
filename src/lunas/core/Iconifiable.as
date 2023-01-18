
/**
 * This interface defines all display components with an internal icon.
 * @author eKameleon
 */
interface lunas.core.Iconifiable 
{

	/**
	 * (read-write) Returns a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 * To create a custom icon, create a movie clip or graphic symbol. 
	 * Select the symbol on the Stage in symbol-editing mode and enter 0 in both the X and Y boxes in the Property inspector. 
	 * In the Library panel, select the movie clip and select Linkage from the Library pop-up menu. 
	 * Select Export for ActionScript, and enter an identifier in the Identifier text box.
	 * The default value is an empty string, which indicates that there is no icon.
	 * @return a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 */
	function getIcon():String ;
	
	/**
	 * Returns the depth value of the icon.
	 * @return the depth value of the icon.
	 */
	function getIconDepth():Number ; 
	
	/**
	 * Returns the scope reference of the icon.
	 * @return the scope reference of the icon.
	 */
	function getIconTarget():MovieClip ;
	
	/**
	 * Sets a string that specifies the linkage identifier of a symbol in the library to be used as an icon for a button instance.
	 */
	function setIcon( str:String ):Void ;
	
	/**
	 * Sets the icon reference of the display.
	 */
	function setIconTarget( target:MovieClip ):Void ;

	/**
	 * Invoqued when the icon property is changed.
	 */
	function viewIconChanged():Void ;

}