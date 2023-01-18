/**
* BitmapExporter
* This singleton class scans a bitmap and returns a string.
* 
* Example:
*

import com.andculture.display.BitmapExporter;
import flash.display.BitmapData;
import mx.utils.Delegate;

var myBitmap:BitmapData = new BitmapData(300, 300, false, 0x000000);

function onScan(event:Object):Void
{
	trace("Scanning...");
}

function onProgress(event:Object):Void
{
	trace(event.percent + "% Complete.");
}

function onComplete(event:Object):Void
{
	trace("Final string is [n] length: " + BitmapExporter.getPixelData().length);
	trace("Completed in [n] milliseconds: " + event.time);
}

BitmapExporter.addEventListener("scan", Delegate.create(this, onScan));
BitmapExporter.addEventListener("progress", Delegate.create(this, onProgress));
BitmapExporter.addEventListener("complete", Delegate.create(this, onComplete));
BitmapExporter.scan(myBitmap);

* 
* Images are converted to various color depths in order to reduce the size of
* the output string. Conversion is done as follows (24 to 16 bit example):
*

	// ------------------------------------------------------------------------
	// 16-bit to 24-bit Algorithm expanded
	// ------------------------------------------------------------------------
	
	color16 = 0xFFFF;
	
	// Isolate colors
	red   = (color16 >> 11) & 0x1F;
	green = (color16 >> 5)  & 0x3F;
	blue  = (color16 >> 0)) & 0x1F;
	
	// Convert to 24-bit
	red   = (red   / 0x1F * 0xFF) << 16;
	green = (green / 0x3F * 0xFF) << 8;
	blue  = (blue  / 0x1F * 0xFF) << 0;
	
	// Merge
	color24 = red | green | blue;
	
	// ------------------------------------------------------------------------
	// Algorithm condensed
	// ------------------------------------------------------------------------
	
	p = 0xFFFFFF;
	
	// Convert to 16-bit color value
	var color16 = (
		((((p >> 16) & 0xFF) / 0xFF * 0x1F) << 11) |
		((((p >> 8)  & 0xFF) / 0xFF * 0x3F) << 5) |
		((((p)       & 0xFF) / 0xFF * 0x1F) << 0)
		);
	
	// Convert to 24-bit clor value
	var color24 = (
		((((color16 >> 11) & 0x1F) / 0x1F * 0xFF) << 16) |
		((((color16 >> 5)  & 0x3F) / 0x3F * 0xFF) << 8)  |
		((((color16))      & 0x1F) / 0x1F * 0xFF)
		);
		
*
* Copyright (C) 2007 andCulture.
* All rights reserved.
* 
* @author	Francis Lukesh
* @version 	1.0
*/

import flash.display.BitmapData;
import mx.events.EventDispatcher;

class com.andculture.display.BitmapExporter
{
	/**
	* EventDispatcher mixin functions
	*/
	// This function is replaced when getInstance initializes the
	// Event dispatcher mixin.
	public static function addEventListener(s:String, o:Object):Void
	{
		getInstance();
		BitmapExporter.addEventListener(s, o);
	}
	public static var removeEventListener:Function;
	private static var dispatchEvent:Function;

	/**
	* Private fields
	*/
	private static var _line:Number;
	private static var _timeoutID:Number;
	private static var _pixels:String;
	private static var _instance:BitmapExporter;
	private static var _timer:Number;
	private static var _bitmap:BitmapData;
	private static var _scanStep:Number;
	
	/**
	* Lookup array for Unicode characters. Gets populated on scan().
	*/
	private static var _utf:Array = [];
	
	/**
	* Lookup array for UTF-16 characters. Gets populated on scan();
	
	/**
	* Used to pad raw hex values (it is the fastest way).
	*/
	private static var _zeroBuffer:Array = ["00000",
											"0000", 
											"000", 
											"00", 
											"0",
											""];

	/**
	* Public properties
	*/
	
	/**
	* Declares what method will be used to scan.
	* Defaults to "scan15ToUnicode".
	*/
	private static var _method:String = "scan15ToUnicode";
	public static function set method(s:String):Void
	{
		if( s != "scan24ToHex" && 
			s != "scan16ToUnicode" && 
			s != "scan15ToUnicode" &&
			s != "scan8ToUnicode" &&
			s != "scan16ToUnicodePair" )
		{
			return;
		}
		_method = s;
	}
	public static function get method():String
	{
		return _method;
	}
	
	private static var _retryDelay:Number = 50;
	public static function set retryDelay(n:Number):Void
	{
		_retryDelay = n;
	}
	public static function get retryDelay():Number
	{
		return _retryDelay;
	}
	
	public static var _timeoutDelay:Number = 1000;
	public static function set timeoutDelay(n:Number):Void
	{
		_timeoutDelay = n;
	}
	public static function get timeoutDelay():Number
	{
		return _timeoutDelay;
	}
	
	/**
	* Minimum width of the output bitmap. If not set, it will be the same as
	* the input bitmap.
	*/
	private static var _minWidth:Number;
	public static function set minWidth(n:Number):Void
	{
		_minWidth = n;
	}
	public static function get minWidth():Number
	{
		return _minWidth;
	}
	
	/**
	* Minimum height of the output bitmap. If not set, it will be the same as
	* the input bitmap.
	*/
	private static var _minHeight:Number;
	public static function set minHeight(n:Number):Void
	{
		_minHeight = n;
	}
	public static function get minHeight():Number
	{
		return _minHeight;
	}
	
	/**
	* Returns the actual width of the output bitmap.
	* @return	Number
	*/
	public static function get width():Number
	{
		if(_scanStep != undefined)
		{
			return (_bitmap.width / _scanStep)>>0;
		}
		return -1;
	}
	
	/**
	* Returns the actual height of the output bitmap.
	* @return	Number
	*/
	public static function get height():Number
	{
		if(_scanStep != undefined)
		{
			return (_bitmap.height / _scanStep)>>0;
		}
		return -1;
	}
	
	/**
	* Sets a reference to a BitmapData object that can reflect the output image.
	*/
	private static var _outputBitmap:BitmapData;
	public static function set outputBitmap(b:BitmapData):Void
	{
		_outputBitmap = b;
	}
	public static function get outputBitmap():BitmapData
	{
		return _outputBitmap;
	}
	
	/**
	* Set to true to reflect the output to the outputBitmap.
	*/
	private static var _reflectOutputBitmap:Boolean = false;
	public static function set reflectOutputBitmap(b:Boolean):Void
	{
		_reflectOutputBitmap = b;
	}
	public static function get reflectOutputBitmap():Boolean
	{
		return _reflectOutputBitmap;
	}
	
	/**
	* -------------------------------------------------------------------------
	* Constructor
	* -------------------------------------------------------------------------
	*/
	private function BitmapExporter()
	{
		EventDispatcher.initialize(BitmapExporter);
	}
	
	private static function getInstance()
	{
		if(_instance == undefined)
		{
			_instance = new BitmapExporter();
		}
		return _instance;
	}
	
	/**
	* Returns a string of the uncompressed pixel data based on method.
	* @return	String
	*/
	public static function getPixelData():String
	{
		return _pixels;
	}
	
	/**
	* Initiates a scan of the bitmap. The bitmap is scanned line by line, 
	* checking for a timeout in between.
	* @param	bitmap	Reference to the bitmap to be scanned.
	*/
	public static function scan(bitmap:BitmapData):Void
	{			
		BitmapExporter.dispatchEvent({
									type:"scan",
									target:BitmapExporter
									});
				
		// Populate the _utf array if it's empty.
		if(_utf.length == 0)
		{
			for(var i:Number = 0; i <= 0x8000; i++)
			{
				_utf[i] = String.fromCharCode(i+32);
			}
		}
		
		
		_timer = getTimer();
		_bitmap = bitmap.clone();
		_pixels = "";
		_line = 0;
		
		if(_minWidth == undefined || _minHeight == undefined)
		{
			_scanStep = 1;
		} else {
			/**
			* Determine which dimension to use to calculate _scanStep.
			*
			* Example:
			* w400:h300 > w256:h256, aspect ratio of input image is wider than
			* bounding constraints. Therefore, use width to calculate _scanStep.
			*/
			if(_bitmap.width / _bitmap.height > _minWidth / _minHeight)
			{
				_scanStep = _bitmap.width / _minWidth;
			} else {
				_scanStep = _bitmap.height / _minHeight;
			}
		}
		
		BitmapExporter.getInstance().scanLines();
	}
	
	/**
	* Initiates the line-by-line scan of the input bitmap.
	*/
	public function scanLines()
	{
		var timer:Number = getTimer();
		var h:Number = height;
		do {
			if(getTimer() - timer > _timeoutDelay)
				break;
			_pixels += this[_method]();
		} while(++_line < h)
		if(_line >= h)
		{
			//COMPLETE
			//trace("Task took [n] milliseconds: " + getTimer() - _timer);
			BitmapExporter.dispatchEvent({
										type:"complete",
										time: (getTimer() - _timer),
										target:BitmapExporter
										});
		} else {
			//TIMEOUT
			//trace("Scanning line " + _line + "...");
			BitmapExporter.dispatchEvent({
										type:"progress",
										percent: Math.floor(_line / h * 100),
										target:BitmapExporter
										});
			_timeoutID = _global.setTimeout(this, "scanLines", _retryDelay);
		}
	}
	
	/**
	* -------------------------------------------------------------------------
	* Conversion functions
	* -------------------------------------------------------------------------
	*/
	private function convert24to8(p:Number):Number
	{
		return	(
				((((p >> 16) & 0xFF) / 0xFF * 7) << 5) |
				((((p >> 8)  & 0xFF) / 0xFF * 7) << 2) |
				((((p)       & 0xFF) / 0xFF * 3) << 0)
				);
	}
	private function convert8to24(p:Number):Number
	{
		return	(
				((((p >> 5) & 7) / 7 * 0xFF) << 16) |
				((((p >> 2) & 7) / 7 * 0xFF) << 8)  |
				((((p))     & 3) / 7 * 0xFF)
				);
	}
	
	private function convert24to15(p:Number):Number
	{
		return	(
				((((p >> 16) & 0xFF) / 0xFF * 0x1F) << 10) |
				((((p >> 8)  & 0xFF) / 0xFF * 0x1F) << 5)  |
				((((p)       & 0xFF) / 0xFF * 0x1F) << 0)
				);
	}
	private function convert15to24(p:Number):Number
	{
		return	(
				((((p >> 10) & 0x1F) / 0x1F * 0xFF) << 16) |
				((((p >> 5)  & 0x1F) / 0x1F * 0xFF) << 8)  |
				((((p))      & 0x1F) / 0x1F * 0xFF)
				);
	}
	
	private function convert24to16(p:Number):Number
	{
		return	(
				((((p >> 16) & 0xFF) / 0xFF * 0x1F) << 11) |
				((((p >> 8)  & 0xFF) / 0xFF * 0x3F) << 5)  |
				((((p)       & 0xFF) / 0xFF * 0x1F) << 0)
				);
	}
	private function convert16to24(p:Number):Number
	{
		return	(
				((((p >> 11) & 0x1F) / 0x1F * 0xFF) << 16) |
				((((p >> 5)  & 0x3F) / 0x3F * 0xFF) << 8)  |
				((((p))      & 0x1F) / 0x1F * 0xFF)
				);
	}
	
	/**
	* Converts the bitmap to 16-bit color, and encodes each pixel as a Unicode
	* character.
	* @return String
	*/
	private function scan16ToUnicode():String
	{	
		var p:Number;
		var data:String = "";
		var w:Number = width;
		var i:Number = 0;
		var uni16:String;
		
		do {
			p = _bitmap.getPixel((i * _scanStep)>>0, (_line * _scanStep)>>0);
			
			// Not using function reference to increase efficiency.
			// You have to compromise somewhere.
			// Referencing the conversion function decreases efficiency by 20%.
			uni16 = _utf[
						((((p >> 16) & 0xFF) / 0xFF * 0x1F) << 11) |
						((((p >> 8)  & 0xFF) / 0xFF * 0x3F) << 5)  |
						((((p)       & 0xFF) / 0xFF * 0x1F) << 0)
						];
			
			// If performance becomes an issue, comment out the following block
			// for about 10-15% increase in efficiency.
			if(_reflectOutputBitmap)
			{
				var color16 = (convert24to16(p));
				var color24 = (convert16to24(color16));
				
				// If _outputBitmap does not exist, Flash will fail silently.
				_outputBitmap.setPixel(i, _line, color24);
			}
			
			data += uni16;
		} while(++i < w)
		return data;
	}

	/**
	* Converts the bitmap to 15-bit color, and encodes each pixel as a Unicode
	* character.
	* @return String
	*/
	private function scan15ToUnicode():String
	{	
		var p:Number;
		var data:String = "";
		var w:Number = width;
		var i:Number = 0;
		var uni15:String;
		
		do {
			p = _bitmap.getPixel((i * _scanStep)>>0, (_line * _scanStep)>>0);
			
			// Not using function reference to increase efficiency.
			// You have to compromise somewhere.
			uni15 = _utf[
						((((p >> 16) & 0xFF) / 0xFF * 0x1F) << 10) |
						((((p >> 8)  & 0xFF) / 0xFF * 0x1F) << 5)  |
						((((p)       & 0xFF) / 0xFF * 0x1F) << 0)
						];
			
			// If performance becomes an issue, comment out the following block
			// for about 10-15% increase in efficiency.
			if(_reflectOutputBitmap)
			{
				var color15 = (convert24to15(p));
				var color24 = (convert15to24(color15));
				
				// If _outputBitmap does not exist, Flash will fail silently.
				_outputBitmap.setPixel(i, _line, color24);
			}

			data += uni15;
		} while(++i < w)
		return data;
	}
	
	/**
	* Converts the bitmap to 8-bit color, and encodes each pixel as a Unicode
	* character.
	* @return String
	*/
	private function scan8ToUnicode():String
	{	
		var p:Number;
		var data:String = "";
		var w:Number = width;
		var i:Number = 0;
		var uni8:String;
		
		do {
			p = _bitmap.getPixel((i * _scanStep)>>0, (_line * _scanStep)>>0);

			// Not using function reference to increase efficiency.
			// You have to compromise somewhere.			
			uni8 =  _utf[
						((((p >> 16) & 0xFF) / 0xFF * 7) << 5) |
						((((p >> 8)  & 0xFF) / 0xFF * 7) << 2) |
						((((p)       & 0xFF) / 0xFF * 3) << 0)
						];
				
			// If performance becomes an issue, comment out the following block
			// for about 10-15% increase in efficiency.
			if(_reflectOutputBitmap)
			{
				var color8 = (convert24to8(p));
				var color24 = (convert8to24(color8));
				
				// If _outputBitmap does not exist, Flash will fail silently.
				_outputBitmap.setPixel(i, _line, color24);
			}
			
			data += uni8;
		} while(++i < w)
		return data;
	}
	
	/**
	* Converts bitmap to 16-bit, and saves color value to pair of UTF-8-encoded
	* characters.
	* @return String
	*/
	private function scan16ToUnicodePair():String
	{	
		var p:Number;
		var data:String = "";
		var w:Number = width;
		var i:Number = 0;
		var color16:Number;
		
		do {
			p = _bitmap.getPixel((i * _scanStep)>>0, (_line * _scanStep)>>0);
			
			// Not using function reference to increase efficiency.
			// You have to compromise somewhere.
			color16 = 	(
						((((p >> 16) & 0xFF) / 0xFF * 0x1F) << 11) |
						((((p >> 8)  & 0xFF) / 0xFF * 0x3F) << 5)  |
						((((p)       & 0xFF) / 0xFF * 0x1F) << 0)
						);
			
			var part1:String = _utf[(color16 >> 8) & 0xFF];
			var part2:String = _utf[color16 & 0xFF];
			
			// If performance becomes an issue, comment out the following block
			// for about 10-15% increase in efficiency.
			if(_reflectOutputBitmap)
			{
				var color16 = (convert24to16(p));
				var color24 = (convert16to24(p));
				
				// If _outputBitmap does not exist, Flash will fail silently.
				_outputBitmap.setPixel(i, _line, color24);
			}
			
			data += part1 + part2;
		} while(++i < w)
		return data;
	}
	
	/*
	* Not needed, however this is how you would reverse-lookup a color from the
	* UTF table. This is very slow in the Flash runtime.
	
	private function getUtf8(s:String):Number
	{
		for(var i:Number = 0; i < _utf.length; i++)
		{
			if(_utf[i] == s)
				return i;
		}
		return 0;
	}
	*/
	
	/**
	* Scans the bitmap as 24-bit color, and encodes each pixel as a 24-bit
	* hex code.
	* @return String
	*/
	private function scan24ToHex():String
	{
		var p:Number;
		var buff:String = "";
		var data:String = "";
		var w:Number = width;
		var i:Number = 0;
		do {
			p = _bitmap.getPixel((i * _scanStep)>>0, (_line * _scanStep)>>0);
			
			// If performance becomes an issue, comment out the following block
			// for about 10-15% increase in efficiency.
			if(_reflectOutputBitmap)
			{
				// If _outputBitmap does not exist, Flash will fail silently.
				_outputBitmap.setPixel(i, _line, p);
			}
			
			buff = p.toString(16);
			buff = _zeroBuffer[buff.length-1] + buff;
			data += buff;
		} while(++i < w)
		return data;
	}
}