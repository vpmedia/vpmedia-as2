import com.fear.app.menu.impl.CoreXMLMenu;
import com.fear.app.menu.ICoreXMLMenu;
import com.fear.app.menu.MenuInfo;
import com.fear.util.MovieClipUtil;

class com.fear.yahoo.services.views.ImageSearchResultsDisplay extends CoreXMLMenu
{
	private var menu:MenuInfo;
	private var imageXML:XML;
	private var container:MovieClip;
	private var channel_menu:MovieClip;
	public static var MENU_ITEM_ID:String = 'image';
	
	public function ImageSearchResultsDisplay(target:MovieClip, imageXML:XML, menuItemLinkageId:String)
	{
		this.setMenuItemLibaryClip(menuItemLinkageId)
		this.imageXML = imageXML;
		this.container = target;
		this.menu = new MenuInfo(this.container, 'ImagesMenu', 0,0, this.container.getNextHighestDepth(),imageXML.firstChild);
		this.generateMenu(menu)
	}
	
	public function init(xURL:String):Void
	{
		//_root.searchResultsView.htmlText += "\n"+'init';
	}
	public function handleLoad(success:Boolean):Void
	{
		//_root.searchResultsView.htmlText += "\n"+'handle load';
	}
	
	public function generateMenu(m:MenuInfo):Void
	{
		//_root.searchResultsView.htmlText += "\n"+'generate menu';
		var curr_node;
		var curr_item;
		if(m.targetClip[m.name] != undefined)
		{
			m.targetClip[m.name].removeMovieClip();
		}
		var curr_menu = m.targetClip.createEmptyMovieClip(m.name, m.depth);
		
		var xmlLength = m.xml.childNodes.length;
		if(xmlLength == undefined)
		{
		}
		var i = 0;
		var startX:Number = 100;
		var startY:Number = 0;
		// for all items or XML nodes (items and menus)
		// within this menu_xml passed for this menu
		while(xmlLength--) 
		{
			// MovieClip for each menu item
			curr_item = curr_menu.attachMovie(this.menuItemLibraryClip,'resultImage'+i, i,{_x:m.x,_y:m.y});
			if(i > 0)
			{
				startX += curr_item._width + 5;
			}
			curr_item._x += startX;
			curr_item._y = startY;
			curr_item.orderIndex = i;
			curr_item.curr_menu = curr_menu;
			curr_item.trackAsMenu = true;
			if((i % 5) == 4)
			{
				startY += 90 + curr_item._height;
				startX = 0;
			}
			
			// item properties assigned from XML
			curr_node = m.xml.childNodes[i];
			curr_item.imageURL = curr_node.attributes.imageURL;
			curr_item.thumbURL = curr_node.attributes.thumbURL;
			curr_item.name.htmlText = '<a target="YahooSearchResults" href="'+curr_node.attributes.imageURL+'">'+curr_node.attributes.name+'</a>';
			curr_item.btn.gotoURL = curr_node.attributes.imageURL;
			curr_item.btn.onRelease = function()
			{
				trace('foo:'+this.gotoURL)
				getURL(this.gotoURL, 'YahooSearchResults')
			}
			// construct handler object
			var imageLoadHandler = new Object;
			imageLoadHandler.onLoadComplete = function(obj) 
			{
				obj._width = 90;
				obj._height = 68;
				// todo: resize
			}
			trace('curr_node.attributes.thumbURL:'+curr_node.attributes.thumbURL);
			MovieClipUtil.loadContent(curr_item.imageContainer, curr_node.attributes.thumbURL, startX,startY,curr_item.imageContainer, imageLoadHandler.onLoadComplete); 			
			
			i++;
		} // end for loop
	}
}