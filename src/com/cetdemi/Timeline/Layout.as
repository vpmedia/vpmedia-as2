import com.cetdemi.Timeline.*;
import mx.utils.Delegate;

/**
 * Handles creating the original layout of the visuals
 */
 
class com.cetdemi.Timeline.Layout
{
	/**
	 * A rather treaturous static function that has the job of attaching movie clips
	 * placing things and doing other nasty things.	 */
	static function doLayout()
	{	
		var ctrl = Referencer.getController();
		var root = ctrl.root;
		var params = ctrl.params;
		var events = ctrl.data.events;
		var eventY = ctrl.data.eventY;
		var periods = ctrl.data.periods;
		var connectors = ctrl.connectors;
				//Caption dynamic text field
		root.txtCaption.html = true;
		root.txtCaption.selectable = false;
		root.txtCaption.text = "Timeline loaded";
		
		//Attach left and right buttons
		root.attachMovie("mcLeftRight", "mcLeftRight", 10000);
		root.mcLeftRight._x = params.leftLeftRight;
		root.mcLeftRight._y = params.topLeftRight;
		
		root.attachMovie("mcPeriodBack", "mcPeriodBack", 11998);
		root.mcPeriodBack._x = params.leftPeriodBack;
		root.mcPeriodBack._y = params.topPeriodBack;
		
		//Create all necessary squares
		root.createEmptyMovieClip("mcEvents", 1000);		root.mainMask = new Mask(root, 'mcEvents', 1001);
		root.mainMask.drawRectangle({ x: params.leftTimeline + params.refWidth*0.015, 
									  y: params.topTimeline,
									  w: params.refWidth*0.97,
									  h: params.refHeight});
		doForAllEvents(events, "createVisual");
		
	
		//Create movie clips for lines joining squares
		for( var i = 0; i < connectors.length; i++)
		{
			for( var j = 0; j < connectors[i].length; j++)
			{
				var mc = root.mcEvents.createEmptyMovieClip("joint_" + i + '_' + j, 300 + i*20 + j);
				mc._x = 0;
				mc._y = eventY[i];
			}
		}
		root.mcEvents._x = params.leftTimeline;
		
		root.createEmptyMovieClip("mcPeriods", 150);
		root.mcPeriods._x = params.leftTimeline;
		root.mcPeriods._y = params.topTimeline;
		
		root.periodMask = new Mask(root, 'mcPeriods', 1002);
		root.periodMask.drawRectangle( { x: params.leftTimeline, 
									  y: params.topTimeline,
									  w: params.refWidth,
									  h: params.refHeight} );
		
		//Create periods
		doForAllPeriods(periods, "createVisual");
		
		//Create the movieclip that will go behind the header
		root.attachMovie("mcBehindHeaders", "mcBehindHeaders", 398);
		root.mcBehindHeaders._x = params.leftTimeline;
		root.mcBehindHeaders._y = params.topLayout;
		
		//Create intermediary line MC
		root.createEmptyMovieClip("mcTicks", 399);
		root.mcTicks._x = params.leftTimeline;
		root.mcTicks._y = params.topTimeline;
		
		root.createEmptyMovieClip("mcHeader", 400);
		root.mcHeader._x = params.leftHeader;
		root.mcHeader._y = params.topHeader;
		
		ctrl.headers = new Array();
		//Create year movie clips for the timeline
		for(var i = 0; i < 6; i++)
		{
			ctrl.headers.push(new Header(i));
					//Since the smallest division is in four seasons, create 3 ticks for each header
			for(var j = 0; j < 4; j++)
			{
				root.mcTicks.attachMovie("mcTick", "mc" + (j + i*4), i*4 + j);
			}
		}
		
		root.btnDummy._visible = false;
	}
	
	/**
	* Loops through all events and fires a function
	* 
	* @param events Reference to the events
	* @param func The function to be called
	*/
	static function doForAllEvents(events:Array, func:String)
	{
		for( var i = 0; i < events.length; i++)
		{
			for(var j = 0; j < events[i].length; j++)
			{
				events[i][j][func]();
			}
		}
	}
	
	/**
	* Loops through all periods and fires a function
	* 
	* @param periods Reference to the periods
	* @param func The function to be called
	*/
	static function doForAllPeriods(periods:Array, func:String)
	{
		for( var i = 0; i < periods.length; i++)
		{
			periods[i][func]();
		}
	}
}