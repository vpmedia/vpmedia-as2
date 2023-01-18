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
* Class to encapsulate the properties that could be applied to a fillStyle.
* Includes roundedness, but not sure if this is a good idea. Perhaps move to rect?
*/
class wilberforce.util.drawing.styles.fillStyleFormat
{
	var rgb;
	var alpha;	
	var cornerRoundedSize;
	
	var gradientFill:Boolean;
	static var defaultFillStyle:fillStyleFormat;
	static var transparentFillStyle:fillStyleFormat=new fillStyleFormat(0xFF0000,0,0);
	
	function fillStyleFormat(tRgb:Number, tAlpha:Number,tCornerRoundedSize:Number)
	{
		rgb=tRgb;
		alpha=tAlpha;
		if (tCornerRoundedSize>0) cornerRoundedSize=tCornerRoundedSize;
	}
	function apply(tMovieClip:MovieClip)
	{
		tMovieClip.beginFill(rgb,alpha);		
	}
	
	public static function get defaultStyle():fillStyleFormat
	{
		if (!defaultFillStyle)
		{
			defaultFillStyle=new fillStyleFormat(0xFF0000,100);
		}
		return defaultFillStyle;
	}
}