/*
	ShellParametersVO
	
	Strongly typed SWFStudio parameters.
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

class com.jxl.vidconverter.vo.parameters.ShellParametersVO
{
	public var path:String;
	
	public var arguments:String;
	public var currentDir:String;
	public var timeout:Number;
	public var waitForWindow:Boolean;
	public var waitForExit:Boolean;
	public var saveStdOut:Boolean;
	public var is16Bit:Boolean;
	public var winState:String;
	public var topmost:Boolean;
	public var x:Number;
	public var y:Number;
	public var width:Number;
	public var height:Number;
	
	public function ShellParametersVO(path:String,
										args,
										currentDir,
										timeout,
										waitForWindow,
										waitForExit,
										saveStdOut,
										is16Bit,
										winState,
										topmost,
										x,
										y,
										width,
										height)
	{
		this.path = 			path;
		this.arguments = 		args;
		this.currentDir = 		currentDir;
		this.timeout = 			timeout;
		this.waitForWindow = 	waitForWindow;
		this.waitForExit = 		waitForExit;
		this.saveStdOut = 		saveStdOut;
		this.is16Bit = 			is16Bit;
		this.winState = 		winState;
		this.topmost = 			topmost;
		this.x = 				x;
		this.y = 				y;
		this.width = 			width;
		this.height = 			height;
	}
	
}