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

import flash.display.BitmapData;
import flash.geom.Matrix;

/** @author Marek Brun 'minim' */
class pl.milib.util.MIBitmapUtil {
	
	static public function getBitmapFromMC(mc:MovieClip):BitmapData {
		var rect:Object=mc.getBounds();
		var bd:BitmapData=new BitmapData(rect.xMax-rect.xMin+1, rect.yMax-rect.yMin+1, true, 0x00FFFFFF);
		var matrix:Matrix=new Matrix();
		matrix.translate(-rect.xMin, -rect.yMin);
		bd['draw'](mc, matrix);
		return bd; 
	}//<<
	
	static public function getBitmapFragmentFromMC(mc:MovieClip, iniX:Number, iniY:Number, width:Number, height:Number):BitmapData {
		var bd:BitmapData=new BitmapData(width, height, true, 0x00FFFFFF);
		var matrix:Matrix=new Matrix();
		matrix.translate(-iniX, -iniY);
		bd['draw'](mc, matrix);
		return bd;
	}//<<
	
	static public function pasteBitmap(bd:BitmapData, mc:MovieClip):Void {
		var bmpMC:MovieClip=getBitmapNewMC(mc);
		bmpMC._x=0;
		bmpMC._y=0;
		bmpMC.attachBitmap(bd, 1, 'never', false);
	}//<<
	
	static public function pasteBitmapInCenterMC(bd:BitmapData, mc:MovieClip):Void {
		var bmpMC:MovieClip=getBitmapNewMC(mc);
		bmpMC._x=-bd['width']/2;
		bmpMC._y=-bd['height']/2;
		bmpMC.attachBitmap(bd, 1, 'never', false);
	}//<<
	
	static public function deleteBitmap(mc:MovieClip):Void {
		var holderMC:MovieClip=getBitmapMC(mc);
		holderMC.cmc.unloadMovie();
	}//<<
	
	static public function getBitmapMC(mc:MovieClip):MovieClip {
		//TODO change to milibojbect
		var mcHolderName:String='out_MIBitmapUtil_bmpHolder';
		if(!mc[mcHolderName]){
			mc.createEmptyMovieClip(mcHolderName, mc.getNextHighestDepth());
			mc[mcHolderName].count=0;
		}
		return mc[mcHolderName];
	}//<<
	
	static private function getBitmapNewMC(mc:MovieClip):MovieClip {
		var holderMC:MovieClip=getBitmapMC(mc);
		holderMC.cmc.unloadMovie();
		holderMC.count++;
		var nmc:MovieClip=holderMC.createEmptyMovieClip('hol'+holderMC.count, holderMC.count);
		holderMC.cmc=nmc;
		return nmc;
	}//<<
	
}