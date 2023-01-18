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
import flash.geom.Point;
import flash.geom.Rectangle;

import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.mc.virtualUI.VirtualUITwoSidesAndMidSmashable;
import pl.milib.util.MIBitmapUtil;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCScale9 extends MIBroadcastClass {

	public var mc : MovieClip;
	private var scale9MC : MovieClip;
	private var scale9MCS : Array;
	private var width : Number;
	private var height : Number;
	private var x2Width : Number;
	private var y2Height : Number;
	private var vi2SX : VirtualUITwoSidesAndMidSmashable;
	private var vi2SY : VirtualUITwoSidesAndMidSmashable;
	
	private function MCScale9(mc:MovieClip) {
		this.mc=mc;
		scale9MC=mc.createEmptyMovieClip('scale9MC', mc.getNextHighestDepth());
		scale9MCS=[
			[
				scale9MC.createEmptyMovieClip('s9x0y0', scale9MC.getNextHighestDepth()),				scale9MC.createEmptyMovieClip('s9x0y1', scale9MC.getNextHighestDepth()),				scale9MC.createEmptyMovieClip('s9x0y2', scale9MC.getNextHighestDepth())
			],
			[
				scale9MC.createEmptyMovieClip('s9x1y0', scale9MC.getNextHighestDepth()),
				scale9MC.createEmptyMovieClip('s9x1y1', scale9MC.getNextHighestDepth()),
				scale9MC.createEmptyMovieClip('s9x1y2', scale9MC.getNextHighestDepth())
			],
			[
				scale9MC.createEmptyMovieClip('s9x2y0', scale9MC.getNextHighestDepth()),
				scale9MC.createEmptyMovieClip('s9x2y1', scale9MC.getNextHighestDepth()),
				scale9MC.createEmptyMovieClip('s9x2y2', scale9MC.getNextHighestDepth())
			]
		];
		mc._xscale=mc._yscale=100;
		width=mc._width;		height=mc._height;
		
		vi2SX=new VirtualUITwoSidesAndMidSmashable();		vi2SY=new VirtualUITwoSidesAndMidSmashable();
		
		render();
	}//<>
	
	public function setWidth(width:Number):Void {
		if(width<0){ width=0; }
		this.width=width;
		resetScale9MCSXYWH();
	}//<<
	
	public function setHeight(height:Number):Void {
		if(height<0){ height=0; }
		this.height=height;
		resetScale9MCSXYWH();
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):Void {
		if(width<0){ width=0; }
		if(height<0){ height=0; }
		this.width=width;
		this.height=height;
		resetScale9MCSXYWH();
	}//<<
	
	public function getWidth(Void):Number {
		return width;
	}//<<
	
	public function getHeight(Void):Number {
		return height;
	}//<<
	
	public function getMinWidth(Void):Number {
		return vi2SX.getSidesLength();
	}//<<
	
	public function getMinHeight(Void):Number {
		return vi2SY.getSidesLength();
	}//<<
	
	public function getScale9MC(Void):MovieClip {
		return scale9MC;
	}//<<
	
	public function render(Void):Void {
		for(var i in mc){
			if(mc[i]._parent==mc){
				mc[i]._visible=true;
			}
		}
		scale9MC._visible=false;
		scale9MC._width=scale9MC._height=1;
		var bd:BitmapData=MIBitmapUtil.getBitmapFromMC(mc);
		scale9MC._xscale=scale9MC._yscale=100;
		for(var i in mc){
			if(mc[i]._parent==mc){
				mc[i]._visible=false;
			}
		}
		scale9MC._visible=true;
		var mcS9Rect:Rectangle=mc.scale9Grid;
		
		var x0Ini:Number=0;
		var x1Ini:Number=mcS9Rect.x;
		var x2Ini:Number=mcS9Rect.x+mcS9Rect.width;
		var y0Ini:Number=0;
		var y1Ini:Number=mcS9Rect.y;
		var y2Ini:Number=mcS9Rect.y+mcS9Rect.height;
		
		var x0Width:Number=mcS9Rect.x;
		var x1Width:Number=mcS9Rect.width;
		x2Width=bd.width-(mcS9Rect.x+mcS9Rect.width);
		var y0Height:Number=mcS9Rect.y;		var y1Height:Number=mcS9Rect.height;		y2Height=bd.height-(mcS9Rect.y+mcS9Rect.height);
		
		for(var ix=0,iy,fragmentBD:BitmapData;ix<3;ix++){
			for(iy=0;iy<3;iy++){
				switch(ix){
					case 0:
						switch(iy){
							case 0: //x0 y0
								fragmentBD=new BitmapData(x0Width, y0Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x0Ini, y0Ini, x0Width, y0Height), new Point(0, 0));
							break;
							case 1: //x0 y1
								fragmentBD=new BitmapData(x0Width, y1Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x0Ini, y1Ini, x0Width, y1Height), new Point(0, 0));
							break;
							case 2: //x0 y2
								fragmentBD=new BitmapData(x0Width, y2Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x0Ini, y2Ini, x0Width, y2Height), new Point(0, 0));
							break;
						}
					break;
					case 1:
						switch(iy){
							case 0: //x1 y0
								fragmentBD=new BitmapData(x1Width, y0Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x1Ini, y0Ini, x1Width, y0Height), new Point(0, 0));
							break;
							case 1: //x1 y1
								fragmentBD=new BitmapData(x1Width, y1Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x1Ini, y1Ini, x1Width, y1Height), new Point(0, 0));
							break;
							case 2: //x1 y2
								fragmentBD=new BitmapData(x1Width, y2Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x1Ini, y2Ini, x1Width, y2Height), new Point(0, 0));
							break;
						}
					break;
					case 2:
						switch(iy){
							case 0: //x2 y0
								fragmentBD=new BitmapData(x2Width, y0Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x2Ini, y0Ini, x2Width, y0Height), new Point(0, 0));
							break;
							case 1: //x2 y1
								fragmentBD=new BitmapData(x2Width, y1Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x2Ini, y1Ini, x2Width, y1Height), new Point(0, 0));
							break;
							case 2: //x2 y2
								fragmentBD=new BitmapData(x2Width, y2Height, true, 0x00FFFF00);
								fragmentBD.copyPixels(bd, new Rectangle(x2Ini, y2Ini, x2Width, y2Height), new Point(0, 0));
							break;
						}
					break;
				}
				MIBitmapUtil.pasteBitmap(fragmentBD, scale9MCS[ix][iy]);
			}
		}
		
		resetScale9MCSXYWH();
		
	}//<<
	
	private function resetScale9MCSXYWH(Void):Void {
		//TODO only on enter frame 
		var mcS9Rect:Rectangle=mc.scale9Grid;
		
		vi2SX.setupSide0Length.v=mcS9Rect.x;		vi2SX.setupSide1Length.v=x2Width;		vi2SX.setupLength.v=width;
		
		vi2SY.setupSide0Length.v=mcS9Rect.y;
		vi2SY.setupSide1Length.v=y2Height;
		vi2SY.setupLength.v=height;
		
		scale9MCS[1][0]._width=scale9MCS[1][1]._width=scale9MCS[1][2]._width=Math.round(vi2SX.getMidLength());
		scale9MCS[0][1]._height=scale9MCS[1][1]._height=scale9MCS[2][1]._height=Math.round(vi2SY.getMidLength());
		
		scale9MCS[0][0]._width=scale9MCS[0][1]._width=scale9MCS[0][2]._width=Math.round(vi2SX.getSide0Length());
		scale9MCS[2][0]._width=scale9MCS[2][1]._width=scale9MCS[2][2]._width=Math.round(vi2SX.getSide1Length());
		
		scale9MCS[0][0]._height=scale9MCS[1][0]._height=scale9MCS[2][0]._height=Math.round(vi2SY.getSide0Length());
		scale9MCS[0][2]._height=scale9MCS[1][2]._height=scale9MCS[2][2]._height=Math.round(vi2SY.getSide1Length());
		
		scale9MCS[1][0]._x=scale9MCS[1][1]._x=scale9MCS[1][2]._x=Math.round(vi2SX.getMidIniPos());
		scale9MCS[0][1]._y=scale9MCS[1][1]._y=scale9MCS[2][1]._y=Math.round(vi2SY.getMidIniPos());
		
		scale9MCS[2][0]._x=scale9MCS[2][1]._x=scale9MCS[2][2]._x=Math.round(vi2SX.getSide1IniPos());
		scale9MCS[0][2]._y=scale9MCS[1][2]._y=scale9MCS[2][2]._y=Math.round(vi2SY.getSide1IniPos());
		
	}//<<
	
	static public function forInstance(mc:MovieClip):MCScale9 {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(mc);
		if(!milibObjObj.serviceByMIScale9){ milibObjObj.serviceByMIScale9=new MCScale9(mc); }
		return milibObjObj.serviceByMIScale9;
	}//<<
	
}