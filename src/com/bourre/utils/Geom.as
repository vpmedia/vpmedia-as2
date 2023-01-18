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
 * @author Francis Bourre
 * @version 1.0
 */
 
class com.bourre.utils.Geom
{
	public static function buildRectangle(mc:MovieClip, d:Number, w:Number, h:Number, c0:Number, c1:Number) : MovieClip
	{
		var _mc:MovieClip = mc.createEmptyMovieClip('__rectangle' + d, d);

		_mc.beginFill(c0?c0:0x000000);
		_mc.lineStyle(1, c1?c1:0x000000);
		_mc.moveTo(0, 0);
		_mc.lineTo(w, 0);
		_mc.lineTo(w, h);
		_mc.lineTo(0, h);
		_mc.lineTo(0, 0);
		_mc.endFill();
		
		return _mc;
	}

	public static function buildMask( 	target : MovieClip, 
										depth : Number, 
										width : Number, 
										height : Number ) : MovieClip
	{
		var mask : MovieClip = Geom.buildRectangle( target._parent, depth, width, height );
		target.setMask( mask );
		return mask;
	}
}