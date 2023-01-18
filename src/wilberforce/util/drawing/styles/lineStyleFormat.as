/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Simon Oliver
 * @version 1.0
 */
 
/**
* Class to encapsulate the properties that could be applied to a lineStyle.
*/
class wilberforce.util.drawing.styles.lineStyleFormat
{
	var thickness:Number;
	var rgb:Number;
	var alpha:Number;
	var pixelHinting:Boolean;
	
	var noScale:String;
	var capsStyle:String;
	var jointStyle:String;
	var miterLimit:Number;
	
	var dashLength:Number;
	
	private static var defaultLineStyle:lineStyleFormat;
		
	function lineStyleFormat(tThickness:Number, tRgb:Number, tAlpha:Number, tPixelHinting:Boolean, tNoScale:String, tCapsStyle:String, tJointStyle:String, tMiterLimit:Number,tDashLength:Number)
	{
		thickness=tThickness;
		rgb=tRgb;
		alpha=tAlpha;
		pixelHinting=tPixelHinting;
	
		noScale=tNoScale;
		capsStyle=tCapsStyle;
		jointStyle=tJointStyle;
		miterLimit=tMiterLimit;
	
		dashLength=tDashLength;
	}
	
	public function apply(tMovieClip:MovieClip):Void
	{		
		tMovieClip.lineStyle(thickness, rgb, alpha, pixelHinting, noScale, capsStyle, jointStyle, miterLimit);
	}
	
	public static function get defaultStyle():lineStyleFormat
	{
		if (!defaultLineStyle)
		{
			defaultLineStyle=new lineStyleFormat(0,0x000000,100);
		}
		return defaultLineStyle;
	}
}