import TextField.StyleSheet;
class com.vpmedia.text.StyleSheetTracer
{
	// StyleSheetTracer.displayFromURL
	//
	// This method displays the CSS style sheet at
	// URL "url" to the Output Panel.
	static function displayFromURL (url:String):Void
	{
		// Create a new style sheet object
		var my_styleSheet:StyleSheet = new StyleSheet ();
		// The load operation is asynchronous, so set up
		// a callback function to display the loaded style sheet.
		my_styleSheet.onLoad = function (success:Boolean)
		{
			if (success)
			{
				StyleSheetTracer.display (this);
			}
			else
			{
				trace ("Error loading style sheet " + url);
			}
		};
		// Start the loading operation.
		my_styleSheet.load (url);
	}
	static function display (my_styleSheet:StyleSheet):Void
	{
		var styleNames:Array = my_styleSheet.getStyleNames ();
		if (!styleNames.length)
		{
			trace ("This is an empty style sheet.");
		}
		else
		{
			for (var i = 0; i < styleNames.length; i++)
			{
				var styleName:String = styleNames[i];
				trace ("Style " + styleName + ":");
				var styleObject:Object = my_styleSheet.getStyle (styleName);
				for (var propName in styleObject)
				{
					var propValue = styleObject[propName];
					trace ("\t" + propName + ": " + propValue);
				}
				trace ("");
			}
		}
	}
}
