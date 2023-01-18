import mx.events.EventDispatcher;

import cinqetdemi.delay.DelayedFor;

import flash.display.BitmapData;

/**
 * This class exports 24-bit images to a compressed format
 * It translates pixels into base64, then performs several
 * compression schemes to obtain a color table and a compressed
 * string. Details of the format are available in readme.txt
 */
class cinqetdemi.display.BitmapDataExporter
{
	//The number of steps to take for the export process
	private var steps : Number;
	//The bitmap to export
	private var bmp : BitmapData;
	//The number of pixels per step
	private var stepLength : Number;
	//The bitmap represented as a string
	private var bmpStr : String;
	
	//EventDispatcher helpers
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	//The chars in our base 64 implementation
	//The first 64 are the original base 64 chars, 
	//the next 32 are for our grayscale palette
	private static var BASE64_CHARS:Array = [
		'A','B','C','D','E','F','G','H',
		'I','J','K','L','M','N','O','P',
		'Q','R','S','T','U','V','W','X',
		'Y','Z','a','b','c','d','e','f',
		'g','h','i','j','k','l','m','n',
		'o','p','q','r','s','t','u','v',
		'w','x','y','z','0','1','2','3',
		'4','5','6','7','8','9','+','/',
		'|','\\','!','"','_','$','%','?',
		'&','*','(',')','-','=',':',';',
		'^',' ','[',']','`','{','@','~',
		'}','<','>',',','.','\''
	];
	
	//The width and height of the bitmap
	private var height:Number;
	private var width:Number;

	private var exportFor : DelayedFor;
	
	/**
	 * Constructor
	 * @param bmp The BitmapData object to export
	 * @param steps The number of steps to use for the export
	 */
	function BitmapDataExporter(bmp:BitmapData, steps:Number)
	{
		//Initialize the EventDispatcher
		EventDispatcher.initialize(this);
		
		//Store steps
		this.steps = steps;
		
		//Apply a color transformation to flatten alpha on the image
		this.bmp = bmp;
		this.width = bmp.width;
		this.height = bmp.height;
	}
	
	/**
	 * Start the export process
	 */
	public function export():Void
	{
		//Start our export process
		stepLength = Math.ceil(bmp.width*bmp.height/steps);
		bmpStr = "";
		exportFor = new DelayedFor(this, steps, exportOne, exportFinished);
		exportFor.start();
	}
	
	/**
	 * Export a part of the image, called by the delayed for
	 * @param currStep the current step in the export process
	 * @param totalSteps The total number of steps in teh export process
	 */
	private function exportOne(currStep:Number, totalSteps:Number):Void
	{
		//The extracted pixel
		var pix:Number;

		//The max value to consider in the local for loop
		var maxVal:Number = Math.min((currStep + 1)*stepLength, bmp.width*bmp.height);

		//Loop through the relevant pixels
		for(var i:Number = currStep*stepLength; i < maxVal; i++)
		{
			//The pixel to examine
			pix = bmp.getPixel(i % bmp.width, Math.floor(i / bmp.width));
			
			bmpStr += BASE64_CHARS[(pix >> 18)] + 
					  BASE64_CHARS[(pix >> 12) % 64] + 
					  BASE64_CHARS[(pix >> 6) % 64] + 
					  BASE64_CHARS[pix % 64];
		}
		
		dispatchEvent({type:'progress', target:this, complete:(currStep + 1), total:steps});
	}

	
	/**
	 * Called when the export is finished
	 * Tell everyone we're done with the export
	 */
	private function exportFinished():Void
	{
		trace('in export finished');
		dispatchEvent({type:'complete', target:this});
	}
	
	/**
	 * Replace a string by another string
	 */
	private function replace(src:String, needle:String, rpl:String):String
	{
		return src.split(needle).join(rpl);
	}
	
	/**
	 * The the compressed bitmap as a string
	 */
	public function getCompressedData():String
	{
		return bmpStr;
	}
	
	public function getWidth():Number
	{
		return width;
	}
	
	public function getHeight():Number
	{
		return height;
	}
}