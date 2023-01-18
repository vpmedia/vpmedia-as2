import com.cetdemi.Timeline.*;
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import mx.remoting.debug.NetDebug;

/**
 * Loads data from remote server and renders it into a useful form
 * Includes its own graphical loader handler
 * 
 * @todo create a decent data abstrction layer
 * @class com.cetdemi.Timeline.DataLoader
 */
 
 /**
 * Broadcasted when data is laoded and parsed
 */
 [Event("load")]
class com.cetdemi.Timeline.DataLoader extends EventDispatcher
{
	/**
	* The source of the XML data
	*/
	private var src:String;
	/**
	* XMLWrraper object used to load file
	*/
	private var file:com.cetdemi.Timeline.XMLWrapper;
	
	/**
	* Internal data reference
	*/
	private var _data:Object;
	/**
	* Internal loaded boolean
	*/
	private var _loaded:Boolean = false;
	
	/**
	* Interval to call pie loader updatee
	*/
	private var xmlInt;
	/** 
	 * Constructor
	 */
	function DataLoader(src)
	{
		this.src = src;
	}
	
	/**
	 * Initiates the loading process
	 */
	function load()
	{
		file = new XMLWrapper();
		file.ignoreWhite = true;
		file.onLoad = Delegate.create(this,xmlLoaded);
		file.load(src);
		updateLoader();
		xmlInt = setInterval(updateLoader, 30);
	}

	/**
	 * Fired once xml is loaded
	 * 
	 * @param success whether the loading failed or was succesful
	 * @todo implement fallback code in case of a problem
	 */
	 function xmlLoaded(success)
	 {
		 if(success)
		 {
			 clearInterval(xmlInt);
			 parseXML();
		 }
		 else
		 {
			 //Todo: fallback
		 }
	 }
	 
	/**
	 * Called when loading of XML file is successful. 
	 * It is responsible for creating the period and event objects
	 */
	private function parseXML()
	{
		var ctrl = Referencer.getController();
		
		//Select the bio node
		var bio = file.firstChild;
		
		//Create the events & periods arrays
		var events = new Array();
		var periods = new Array();
		var eventColors = new Array();
		var eventY = new Array();
		
		var nodeP = bio.lastChild;
		
		//Construct periods from the periods node
		
		var startDate = nodeP.attributes.from;
		//Label ref is used to properly label the headers of the timeline
		var labelref = Number(nodeP.attributes.labelref);
		
		var prevStart = startDate;
		for( var i = 0; i < nodeP.childNodes.length; i++)
		{
			//Level 1 node
			var nodeC = nodeP.childNodes[i];
			var atts = nodeC.attributes;
			
			periods.push( new Period(prevStart, atts.color, atts.name, i));
			periods[i].endDate = atts.to;
			prevStart = atts.to;
		}
		
		//Periods done; move on to events
		var space = ctrl.params.refHeight - 30;
		for( i = 0; i < bio.childNodes.length - 1; i++)
		{
			ctrl.connectors[i] = new Array();
			events[i] = new Array();
			var nodeE = bio.childNodes[i];
			
			atts = nodeE.attributes;
			//eventY.push(ctrl.params.topTimeline + 15 + i*space/(bio.childNodes.length - 1));
			eventY.push(Number(atts.y) + ctrl.params.topTimeline);
			var iconType = atts.icon;
			for( var j = 0; j < nodeE.childNodes.length; j++)
			{
				atts = nodeE.childNodes[j].attributes;
				if(atts.start != null && atts.start != undefined)
				{
					events[i].push( new Event(atts.start, atts.text, i, events[i].length - 1, iconType, atts.num, atts.id));
					ctrl.connectors[i].push({i:i, y:eventY[i], startString:atts.start, endString:atts.end});
				}
				events[i].push( new Event(atts.end, atts.text, i, events[i].length - 1, iconType, atts.num, atts.id));
				
				//Associate linked events
				if(atts.start != null && atts.start != undefined)
				{
					events[i][events[i].length - 1].associated = events[i][events[i].length - 2];
					events[i][events[i].length - 2].associated = events[i][events[i].length - 1];
				}
			}
		}

		//Unpollute namespace
		delete file;
		
		data = {events:events, periods:periods, eventY:eventY, labelref:labelref};
		dispatchEvent({type:"load"});
		loaded = true;
	}
	
	/**
	 * Visually updates the loader circle
	 */
	function updateLoader()
	{
		var root = Referencer.getRoot();
		if(file.getBytesTotal() > 100)
		{
			root.pc.text = Math.round(file.getBytesLoaded()/file.getBytesTotal()*100) + "%";
			
			//Draw appropriate triangles in mask
			var p = file.getBytesLoaded()/file.getBytesTotal();
			root.pl.mask.clear();
			var dt = 1/30*Math.PI;
			for(var i = 0; i < 60; i++)
			{
				if(i+1 < p*60)
				{
					var ang = i/30*Math.PI;
					with(root.pl.mask)
					{
						moveTo(0,0);
						beginFill(0x000000);
						lineTo(50*Math.cos(ang), 50*Math.sin(ang));
						lineTo(50*Math.cos(ang+dt), 50*Math.sin(ang+dt));
						endFill();
					}
				}
				else
				{
					break;
				}
			}
		}
	}
	
	/**
	 * Gets the data extracted from the loaded XML
	 */ 
	function get data():Object
	{
		return _data;
	}
	
	/**
	 * Sets the data
	 */ 
	function set data(paramData:Object)
	{
		_data = paramData;
	}
	
	/**
	 * Check if the data has been loaded 
	 */
	function get loaded():Boolean
	{
		return _loaded;
	}

	/**
	 * Set loaded var
	 */
	function set loaded(paramLoaded:Boolean)
	{
		_loaded = paramLoaded;
	}
}