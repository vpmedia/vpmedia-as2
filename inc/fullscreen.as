/**
 * <p>Description: Fullscreen</p>
 *
 * @author András Csizmadia - vpmedia.hu
 * @version 2.0
 */
// functions to enter and leave full screen mode
function goFullScreen ()
{
	Stage["displayState"] = "fullScreen";
}
function exitFullScreen ()
{
	Stage["displayState"] = "normal";
}
// function to enable, disable context menu items, based on which mode we are in.
function menuHandler (obj, menuObj)
{
	if (Stage["displayState"] == "normal")
	{
		// if we're in normal mode, enable the 'go full screen' item, disable the 'exit' item
		menuObj.customItems[0].enabled = true;
		menuObj.customItems[1].enabled = false;
	}
	else
	{
		// if we're in full screen mode, disable the 'go full screen' item, enable the 'exit' item
		menuObj.customItems[0].enabled = false;
		menuObj.customItems[1].enabled = true;
	}
}
// create a new context menu 
var fullscreenCM:ContextMenu = new ContextMenu (menuHandler);
// hide the regular built-in items
fullscreenCM.hideBuiltInItems ();
//

var fs:ContextMenuItem = new ContextMenuItem ("Go Full Screen", goFullScreen);
fullscreenCM.customItems.push (fs);
var xfs:ContextMenuItem = new ContextMenuItem ("Exit Full Screen", exitFullScreen);
fullscreenCM.customItems.push (xfs);

//  
var appCP:ContextMenuItem = new ContextMenuItem (_global.____$APP_COPYRIGHT, onCP);
fullscreenCM.customItems.push (appCP);
_root.menu = fullscreenCM;
