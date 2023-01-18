import com.cetdemi.Timeline.*;
import mx.remoting.debug.NetDebug;

/**
 * Calculates a bunch of values from raw data
 */
class com.cetdemi.Timeline.Measurer
{
	/**
	* UTC of the start of the periods
	*/
	var periodStart;
	/**
	* UTC of the end of the periods
	*/
	var periodEnd;
	/**
	* Delta between end and start of periods
	*/
	var periodDelta;
	
	/**
	* Number of months in period span
	*/
	var numMonths;
	
	/**
	* Events to be rendered
	*/
	var eventRenderStack:Array = new Array();
	/**
	* Periods to be rendered
	* 
	* @todo Implement appropriately
	*/
	var periodRenderStack:Array = new Array();

	/**
	* Left interval measures
	*/
	var il:Array = new Array();
	/*
	* Right interval measures
	*/
	var ir:Array = new Array();
	
	/**
	* Constructor
	*/
	function Measurer()
	{

	}
	
	/**
	 * Uses the period and event data to calculate special arrays which are used
	 * In Renderer.render
	 * 
	 * @see com.cetdemi.Timeline.Renderer#render
	 */
	function doMeasures()
	{
		
		var ctrl = Referencer.getController();
		var root = ctrl.root;
		var periods = ctrl.data.periods;
		var params = ctrl.params;
		var events = ctrl.data.events;
		var connectors = ctrl.connectors;
		
		var i;
		var currCol;
		var betweenFlag;
		var startCol;
		var endCol;
		var steps;
		var j;
		var k;
		var last;
		var oldPos;
		var c;
		var currZoom;
		var m;
		var ref;
		//Find the lowest dates: use as 0-points
		periodStart = periods[0].startDate.utc;
		periodEnd   = periods[periods.length - 1].endDate.utc;
		periodDelta = periodEnd - periodStart;
		numMonths = 12*periodDelta/(365.2425*24*60*60*1000);
		
		//Calculate which squares need to be rendered
		//and create filters
		for(i = 0; i < events.length; i++)
		{
			eventRenderStack[i] = i;
		}
		for(i = 0; i < periods.length; i++)
		{
			periodRenderStack.push(i);
		}
		
		//Calculate lowest square number in interval for predictive algorithm
		//See Renderer.render for info on how this works
		for(i = 0; i < events.length; i++)
		{
			il[i] = new Array();
			
			k = 0;
			last = false;
			for(j = 0; j <= params.pcResolution; j++)
			{
				il[i].push(k);
				while(!last && events[eventRenderStack[i]][k].pos < j/params.pcResolution)
				{
					k++;
					if(k == events[eventRenderStack[i]].length)
					{
						last = true;
						break;
					}
				}
			}
		}
	
		for(i = 0; i < events.length; i++)
		{
			ir[i] = new Array();
			k = events[eventRenderStack[i]].length - 1;
			last = false;
			
			for(j = params.pcResolution; j >= 0; j--)
			{
				ir[i][j] = k;
				while(!last && events[eventRenderStack[i]][k].pos > j/params.pcResolution )
				{
					k--;
					if(k < 1)
					{
						last = true;
						break;
					}
				}
			}
		}
		
		for(i = 0; i < connectors.length; i++)
		{
			for(j = 0; j < connectors[i].length; j++)
			{
				connectors[i][j].startDate = new DateWrapper(connectors[i][j].startString);
				connectors[i][j].endDate = new DateWrapper(connectors[i][j].endString);
			}
		}
	}
}