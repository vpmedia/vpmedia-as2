import com.cetdemi.Timeline.*;
import mx.utils.Delegate;
//import mx.remoting.debug.NetDebug;

/**<
 * The main class for the Timeline app
 * @description The TimeineController handles creating layout, loading data, and basically 
 * everything about the timeline
 * @author Patrick Mineault
 * @version 1.0 initial port of the old AS2 code
 */
class TimelineController
{
	/**
	* The base location from which all XML files will be loaded
	*/
	var location:String = "";
	/**
	* A reference to the root timeline
	*/
	var root:MovieClip;
	/**
	* A reference to the dataLoader
	*/
	var dataLoader:com.cetdemi.Timeline.DataLoader;
	/**
	* A parameters object containing placement, labelling information
	*/
	var params:Object;
	/**
	* Data extracted from dataLoader
	*/
	var data:Object;
	/**
	* Reference to the renderer
	*/
	var renderer:com.cetdemi.Timeline.Renderer;
	/**
	* Reference to the Measurer
	*/
	var measurer:com.cetdemi.Timeline.Measurer;
	/**
	* Reference to the unique animation in the movie
	*/
	var anim:com.cetdemi.Timeline.Anim;
	/**
	* Headers references
	*/
	var headers:Array;
	/**
	* Connectors (lines between events) reference
	*/
	var connectors:Array = new Array();
	/**
	* Main localConnection to remotely control the movie
	*/
	var lc:LocalConnection;
	/**
	* Select event reference
	*/
	var selectedEvent:com.cetdemi.Timeline.Event;
	
	/**
	 * Constructor
	 * 
	 * @param The root timeline of the movie
	 */
	function TimelineController(root:MovieClip)
	{
		this.root = root;
		
		params = new Object();
		params.months = ["September", "October", "November", "December","January", "February", "March", "April", "May", "June", "July", "August"];
		params.months3 = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
		params.refAnimSpeed = 6;
		params.leftLayout = 0;
		params.topLayout = 0;
		
		//How much does the timeline zoom in or out when the + and - buttons are pressed
		params.zoomFactor = 3.5;
		
		params.refHeight = 217;
		params.refWidth = 699;
		params.maxZoom = 40;
		params.pcResolution = 100;
		params.lineColor = 0xff9900;
		
		//The tlRules determine when elements in the timelines are displayed
		//x: number of months in said zoom
		//y: zoom level where associated header date will appear
		//labels: the labels that will be affected in each case
		params.tlRules = [{x:12,  y:1, labels:["Year 1", "Year 2", "Year 3", "Year 4"], period:4}, 
						  {x:3,  y:3, labels:["Fall","Winter", "Spring","Summer"], period:4},
						  {x:1,  y:10, labels:params.months, period:12}, 
						  {x:1,   y:40, labels:null, period:0}];
						  
		params.datebgThreshold = 1;
		
		params.switchScale = 1.60;
		params.logSwitchScale = Math.log(params.switchScale)
		params.numScales = Math.ceil(Math.log(params.maxZoom)/params.logSwitchScale);
		
		//Layout
		
		params.leftTimeline = 31 + params.leftLayout;
		params.topTimeline = 23 + params.topLayout;
		
		params.leftHeader = params.leftTimeline;
		params.topHeader = 12 + params.topLayout;
		
		params.leftZoom = 721.5 + params.leftLayout;
		params.topZoom = 302.5 + params.topLayout;
		
		params.leftPeriodBack = 3 + params.leftLayout;
		params.topPeriodBack = 314 + params.topLayout;
			
		params.leftLeftRight = params.leftLayout;
		params.topLeftRight = params.topLayout;
		
		params.leftResults = 55 + params.leftLayout;
		params.topResults = 65 + params.topLayout;
		
		params.typeLabels = ['Movies','Actors','Technical Advances','Historic Events'];
		
		root.styles = new TextField.StyleSheet();
		root.styles.setStyle("a", 
		   {fontWeight: 'bold',
		   color: '#000066'}
		);
		root.styles.setStyle("a:hover", 
		   {fontWeight: 'bold',
		   textDecoration: 'underline',
		   color: '#000099'}
		);
		
		//NetDebug.initialize();
		
		//Initiate tooltip class
		_global.tooltip = new Tooltip();
	}
	
	/**
	 * Initiates the laoding operations
	 */
	function init()
	{
		MovieClip.prototype.useHandCursor = false;
		Button.prototype.useHandCursor = false;
		
		XMLWrapper.setBaseLocation(location);

		dataLoader = new DataLoader("timeline.xml");
		dataLoader.addEventListener("load", Delegate.create(this, handleDataLoaded));
		dataLoader.load();
	}
	
	/**
	 * Handles data load. 
	 * Creates the layout and renderer instance, and generally initiates layout and such
	 */
	function handleDataLoaded()
	{
		data = dataLoader.data;
		
		//Create a new layout object
		root.nextFrame();
		Layout.doLayout();
		
		root.mcBehindHeaders.onRelease = Delegate.create(this, handleClickBehindHeaders);
		root.mcLeftRight.btnLeft.onPress = Delegate.create(this, handleLeftRelease);
		root.mcLeftRight.btnRight.onPress = Delegate.create(this, handleRightRelease);
		
		measurer = new Measurer(this);
		measurer.doMeasures();
		
		//Create a new animation singleton
		anim = Anim.getAnim();
		anim.addEventListener('finish',Delegate.create(this, handleAnimFinish));
		
		//Create a new renderer
		renderer = new Renderer();
		renderer.zoom = 1;
		renderer.offset = 0;
		
		//Set up an enterFrame beacon that will create the main animation
		root.onEnterFrame = Delegate.create(this, handleEnterFrame);

		//Prepare scrollbar
		root.mcScrollbar.addEventListener("change", Delegate.create(this, handleScrollbarChange));
		
		//Prepare Plus and minus zoom buttons
		root.btnPlus.onPress = Delegate.create(this, handleZoomIn);
		root.btnLess.onPress = Delegate.create(this, handleZoomOut);

		//Setup listening localConnection
		lc = new LocalConnection();
		lc.connect('timeline');
		lc.getEvent = Delegate.create(this, handleShowEvent);
	}

	/**
	* Called when the scrollbar is changed (moved or pressed)
	*/
	function handleScrollbarChange()
	{
		if(!isNaN(root.mcScrollbar.value))
		{
			renderer.mode = 'scrollbar';
			renderer.offset = root.mcScrollbar.value/10000;
			_global.tooltip.hideToolTip(false);
		}
	}
	
	/**
	* Called when the + button is pressed to zoom into the timeline
	* Starts an animation to zoom in
	*/
	function handleZoomIn()
	{
		var center = renderer.offset + 0.5/renderer.zoom;
		var newzoom = Math.min(renderer.zoom*params.zoomFactor, params.maxZoom);
		var newoffset = Math.min(Math.max(0,center - 0.5/newzoom), 1 - 1/newzoom);
		
		//Create a zoom in animation
		anim.begin(renderer.offset, renderer.zoom, newoffset, newzoom);
	}
	
	/**
	* Called when the - button is pressed to oom out of the timeline. 
	* Starts an animation to zoom out
	*/
	function handleZoomOut()
	{
		if(renderer.zoom != 1)
		{
			var center = renderer.offset + 0.5/renderer.zoom;
			var newzoom = Math.max(renderer.zoom/params.zoomFactor, 1);
			var newoffset = Math.min(Math.max(0,center - 0.5/newzoom), 1 - 1/newzoom);
			
			anim.begin(renderer.offset, renderer.zoom, newoffset, newzoom);
		}
	}
	
	/**
	* Called on each frame to potentially render the timeline, if needed.
	*/
	function handleEnterFrame()
	{
		if(renderer.invalid)
		{
			renderer.render();
		}
	}
	
	/**
	 * Called when the area behind the headers is clicked
	 */
	function handleClickBehindHeaders()
	{
		var xoffset = root.mcBehindHeaders._xmouse/root.mcBehindHeaders._width;
		var center = renderer.offset + xoffset/renderer.zoom;
		var newzoom = Math.min(renderer.zoom*params.zoomFactor, params.maxZoom);
		var newoffset = Math.max(Math.min(center - 0.5/newzoom, 1 - 1/newzoom), 0);
		
		anim.begin(renderer.offset, renderer.zoom, newoffset, newzoom);
	}

	/**
	* Called from HTML to Flash. Please see documentation.txt for info on LocalConnection handling
	*/
	function handleShowEvent(id:String)
	{
		var found = false;
		if(id != "")
		{
			//Find the event's position
			for(var i = 0; i < data.events.length; i++)
			{
				for(var j = 0; j < data.events[i].length; j++)
				{
					if(data.events[i][j].id == id)
					{
						var c = data.events[i][j];
						
						var left = c.pos - 1/2*1/params.maxZoom;
						left = Math.min(Math.max(0, left), 1 - 1/params.maxZoom);
						if(Math.abs(renderer.offset - left) > 0.1 || Math.abs(renderer.zoom - params.maxZoom) > 0.1)
						{
							//Zoom in to event
							if(selectedEvent != c && selectedEvent.associated != c)
							{
								anim.begin(renderer.offset, renderer.zoom, left, params.maxZoom);
							}
							c.handleGetContent(id);
						}
						found = true;
						break;
					}
				}
				if(found)
				{
					break;
				}
			}
		}
		else
		{
			if(renderer.zoom != 1)
			{
				//Perform a zoom out
				anim.begin(renderer.offset, renderer.zoom, 0, 1);
			}
		}
	}

	/**
	 * Called when the Left arrow is pressed
	 */
	function handleLeftRelease()
	{
		var newoffset = Math.max(0, renderer.offset - 0.8/renderer.zoom);
		anim.begin(renderer.offset, renderer.zoom, newoffset, renderer.zoom);
	}

	/**
	 * Called when the Right arrow is pressed
	 */
	function handleRightRelease()
	{
		var newoffset = Math.min(renderer.offset + 0.8/renderer.zoom, 1 - 1/renderer.zoom);
		anim.begin(renderer.offset, renderer.zoom, newoffset, renderer.zoom);
	}
	
	/**
	 * Fired when animation is over
	 */
	function handleAnimFinish()
	{
		renderer.cleanGarbage();
	}
}