import com.cetdemi.Timeline.*
import mx.remoting.debug.NetDebug;

/** * Renders the timeline
 * The renderer has two very important getter/setter vars that are also used by 
 * com.cetdemi.Timeline.Anim, which are zoom and offset. Offset is a number between 0 and 1
 * That refers to the left position of the timeline relative to the whole thing.
 * zoom refers to the zoom of the timeline, meaning 1/(offset + span)
 * 
 */
class com.cetdemi.Timeline.Renderer
{
	/**
	* Controller ref
	*/	private var ctrl:TimelineController;
	/**
	* Root ref
	*/
	private var root:MovieClip;
	/**
	* Internal zoom var
	*/
	private var _zoom:Number;
	/**
	* Internal ofset var
	*/
	private var _offset:Number;
	/**
	* params ref
	*/
	private var params:Object;
	/**
	* Events ref
	*/	private var events:Array;
	/**
	* Periods ref
	*/	private var periods:Array;
	/**
	* Left interval measures ref
	*/
	private var il:Array;
	/**
	* Right interval measures ref
	*/
	private var ir:Array;
	/**
	* Event groups to be rendered ref
	*/
	private var eventRenderStack:Array;
	/**
	* Periods to be rendered ref
	* @todo do a better job at selective period rendering
	*/
	private var periodRenderStack:Array;
	/**
	* The current zoom level, with regards to params.tlRules
	*/
	private var currLevel:Number;
	/**
	* The number of months in the period rendered
	*/
	private var numMonths:Number;
	/**
	* Connectors (line bettwen spanning events reference
	*/
	private var connectors:Array;
	/**
	* Mode refers to what fired the renderer invalidation, for example 'scrollbar' or 'anim'
	*/
	var mode:String = "";
	/**
	* We use an invalidation scheme instead of direct calls to render
	*/
	var invalid:Boolean = false;
		/**
	 * Constructor
	 */	function Renderer()
	{
		this.ctrl = Referencer.getController();
		this.root = ctrl.root;		this.params = ctrl.params;
		this.events = ctrl.data.events;		this.periods = ctrl.data.periods;
		this.il = ctrl.measurer.il;
		this.ir = ctrl.measurer.ir;		this.eventRenderStack = ctrl.measurer.eventRenderStack;
		this.periodRenderStack = ctrl.measurer.periodRenderStack;
		this.numMonths = ctrl.measurer.numMonths;
		this.connectors = ctrl.connectors;
		
		/**
		* In the first render, some dynamic attributes are called to initialize them
		* This way we can use the (faster) internal variables in the main render
		*/
		var garbage;
		var c;
		var i;
		for(i = 0; i < periods.length; i++)
		{
			c = periods[i];
			garbage = c.startPos;
			garbage = c.endPos;
		}
	}
		/**	 * Renders the headers of the timeline
	 */
	function renderHeaders()
	{

		var lo1 = (offset + 0.001)*numMonths;
		var hi1 = (offset + 1/zoom - 0.001)*numMonths;
		var k = 1;
		var barred = new Array();
		var num;
		var mc;
		var lo2;
		var hi2;
		var i;
		var j;
		var m;
		var header;
		var mplushalf;

		var heading = false;
		var ticking = false;
		for(i = 0; i < params.tlRules.length; i++)
		{
			//Create dates
			if(params.tlRules[i + 1].y < _zoom)
			{
				continue;
			}
			else
			{
				if(!heading)
				{
					lo2 = Math.ceil(lo1/params.tlRules[i].x - 0.5);
					hi2 = Math.ceil(hi1/params.tlRules[i].x - 0.5);
					
					for(j = lo2; j < hi2; j++)
					{
						m = j*params.tlRules[i].x;
						mplushalf = (j + 0.5)*params.tlRules[i].x;

						//Create a date
						num = k - 1;
						header = ctrl.headers[num];
						header.mc._visible = true;
						header.pos = m/numMonths;
						
						header.mc.dateText.text = params.tlRules[i].labels[Math.round(m/params.tlRules[i].x) % params.tlRules[i].period];
						header.mc.dateText.textColor = 0xffffff;
						header.mc.bg._visible = true;

						header.mc._x = (mplushalf/numMonths - offset)*zoom*params.refWidth;
						k++;
						
						heading = true;
					}
					var _k1 = k - 1;
					currLevel = i;
				}
				else if(!ticking)
				{
					lo2 = Math.ceil(lo1/params.tlRules[i].x);
					hi2 = Math.ceil(hi1/params.tlRules[i].x);
					
					k = 1;
					for( var j = lo2; j < hi2; j++)
					{
						var m = j*params.tlRules[i].x

						//Create a date with graphix
						num = k - 1;
						mc = _root.mcTicks["mc" + num];
						mc._visible = true;
						mc.pos = m/numMonths;
						mc._x = (m/numMonths - offset)*zoom*params.refWidth;
						k++;

					}
					var _k2 = k - 1;
					ticking = true;
				}
				else
				{
					break;
				}
			}
		}
		
		//Turn off unrequired headers
		for(var i = _k1; i < 6; i++)
		{
			ctrl.headers[i].mc._visible = false;
		}
		
		//Turn off unrequired ticks
		//24 := 4*6 = num ticks per header * num headers
		for( var j = _k2; j < 24; j++)
		{
			root.mcTicks["mc" + j]._visible = false;
		}
	}
	
	/**	 * Critical function:: renders the canvas
	 * sql and sqr are created by the measurer, and they represent the max or min id of the square in an
	 * interval. Hiding squares at 60fps is very expensive, and so is moving useless squares
	 * This issue is solved here by simply ignoring squares outside of the viewed interval. 
	 * In order to know which squares to move, we need to have the sql and sqr arrays which tell us 
	 * What's the lowest square id on the left and right. There's a tradeoff between speed and
	 * accuracy here. If the measures are coarse, it takes less memory, but when zooming in, garbage tends to 
	 * accumulate on the sides. We don't really need to be very precise anyway, but this is really
	 * the best method I know to not move out of sight squares, while not having to make some invisible  every frame
	 * 
	 * @version This version is the moviestimeline.com one, which is faster than previous versions	 */
	function render()
	{
		if(mode == 'scrollbar')
		{
			cleanGarbage();
		}
		
		//Render all relevant events
		var omc;
		var i;
		var j;
		var k;
		var l;
		var r;
		var oldPos;
		var c;
		var a;
		var t;
		var s;
		var e;
		var w = params.refWidth;
		var z = zoom*params.refWidth;
		var p = params.pcResolution;
		var stack;
		var pc = params.lineColor;
		
		//Render events
		for(i = 0; i < eventRenderStack.length; i++)
		{
			stack = eventRenderStack[i];
			l = il[stack][Math.floor(_offset*p)];
			r = ir[stack][Math.floor((_offset + 1/_zoom)*p)];
			for(var j = l - 3 ; j < r + 5; j++)
			{
				c = events[stack][j];
				c.mc._visible = true;
				c.mc._x = (c._pos - _offset)*z;
			}
			for(var j = 0; j < connectors[stack].length; j++)
			{
				s = Math.max(0, (connectors[stack][j].startDate.pos - offset)*z);
				e = Math.min((connectors[stack][j].endDate.pos - offset)*z, w);			
				with(root.mcEvents["joint_" + stack + '_' + j])
				{
					clear();
					if(e > 0 && s < w)
					{
						lineStyle (1, pc, 100);
						moveTo(s,-1);
						lineTo(e,-1);
						moveTo(s,1);
						lineTo(e,1);
					}
				}
			}
		}
		
		//Render periods
		for(i = 0; i < periodRenderStack.length; i++)
		{
			c = periods[periodRenderStack[i]];
			c.mc._x = (c._startPos - offset)*z;
			c.mc._width = (c._endPos - c.startPos)*z + 1;
			c.mc._visible = true;
		}
		
		//Render timeline
		renderHeaders();
		if(mode != 'scrollbar')
		{
			updateScrollbar();
		}
		invalid = false;
		mode = '';
	}
	
	/**
	* Cleans up the garbage that tends to accumulate on the sides of the anim
	*/
	function cleanGarbage()
	{
		//Make everything invisible
		for( var i = 0; i < events.length; i++)
		{
			for(var j = 0; j < events[i].length; j++)
			{
				events[i][j].mc._visible = false;
			}
		}
		
		//Compute inverse of event render stack
		var invStack = new Array();
		for(var i = 0; i < events.length; i++)
		{
			invStack[i] = 0;
			
		}
		for(var i = 0; i < eventRenderStack.length; i++)
		{
			invStack[eventRenderStack[i]] = 1;
			
		}
		
		//Clear all lines
		for(i = 0; i < invStack.length; i++)
		{
			if(!invStack[i])
			{
				for(j = 0; j < connectors[i].length; j++)
				{
					root.mcEvents["joint_" + i + '_' + j].clear();
				}
			}
		}
		
		//Make stuff selectively visible
		for( var i = 0; i < eventRenderStack.length; i++)
		{
			for(var j = 0; j < events[eventRenderStack[i]].length; j++)
			{
				var c = events[eventRenderStack[i]][j];
				if(c.pos > offset && c.pos < offset + 1/zoom )
				{
					c.mc._visible = true;
				}
			}
		}
		//trace('garbage cleaned');
	}
	
	/**
	* Modifies the scrollbar properties
	*/
	function updateScrollbar()
	{
		//trace(zoom);
		root.mcScrollbar.minimum = 0;
		root.mcScrollbar.maximum = 10000 - 10000/zoom;
		root.mcScrollbar.thumbScale = 1/zoom;
		root.mcScrollbar.value = 10000*offset;
		root.mcScrollbar.lineScroll = 450/zoom;
	}
	
	/**
	* Triggers a refresh of the timeline.
	* Cleans garbage on sides
	*/
	function invalidate()
	{
		_global.tooltip.hideToolTip(false);
		invalid = true;
		this.eventRenderStack = ctrl.measurer.eventRenderStack;
		cleanGarbage();
		render();
	}
	
	/**	 * Sets the zoom
	 * And invalidate	 */	function set zoom(paramZoom:Number)
	{
		if(paramZoom != _zoom)
		{
			_zoom = paramZoom;
			invalid = true;
		}
	}	/**
	 * Sets the offset
	 * and invalidate
	 */
	function set offset(paramOffset:Number)
	{
		if(_offset != paramOffset)
		{
			if(paramOffset < 0.000000000001)
			{
				paramOffset = 0;
			}
			_offset = paramOffset;
			invalid = true;
		}
	}	/**
	 * Gets the zoom
	 */
	function get zoom():Number
	{
		return _zoom;
	}

	/**
	 * Gets the offset
	 */
	function get offset():Number
	{
		return _offset;
	}}