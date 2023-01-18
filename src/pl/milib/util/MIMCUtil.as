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
import pl.milib.util.MILibUtil;


class pl.milib.util.MIMCUtil
{
	
	static public function getYRoot(mc:MovieClip, $plusY:Number):Number{
		var obj={y:$plusY==null ? 0 : $plusY, x:0};
		mc.localToGlobal(obj);
		return obj.y;
	}//<<
	
	static public function setYRoot(mc, val){
		var obj={x:mc._xRoot, y:val};
		mc._parent.globalToLocal(obj);
		mc._x=obj.x;
		mc._y=obj.y;
	}//<<
	
	static public function getXRoot(mc:MovieClip, $plusX:Number):Number{
		var obj={x:$plusX==null ? 0 : $plusX, y:0};
		mc.localToGlobal(obj);
		return obj.x;
	}//<<
	
	static public function setXRoot(mc, val){
		var obj={x:val, y:mc._yRoot};
		mc._parent.globalToLocal(obj);
		mc._x=obj.x;
		mc._y=obj.y;
	}//<<
	
	static public function mcPosXToMcPosX(mcFrom:MovieClip, mcTo:MovieClip):Number {
		var obj={y:0, x:0};
		mcFrom.localToGlobal(obj);
		mcTo.globalToLocal(obj);
		return obj.x;
	}//<<
	
	static public function mcPosYToMcPosY(mcFrom:MovieClip, mcTo:MovieClip):Number {
		var obj={y:0, x:0};
		mcFrom.localToGlobal(obj);
		mcTo.globalToLocal(obj);
		return obj.y;
	}//<<
	
	static public function snapMCPosToPixels(mc:MovieClip):Void {
		var obj={y:0, x:0};
		mc.localToGlobal(obj);
		obj.x=Math.round(obj.x);		obj.y=Math.round(obj.y);
		mc.globalToLocal(obj);		mc._x=mc._x+obj.x;		mc._y=mc._y+obj.y;
	}//<<
	
//	static public function setInStage(boundInfo, margX, margY):Boolean{
//		var mc=boundInfo.mc;
//		var inRoot0={x:mc._x+boundInfo.x0, y:mc._y+boundInfo.y0};
//		mc._parent.localToGlobal(inRoot0);
//		var inRoot1={x:mc._x+boundInfo.x1, y:mc._y+boundInfo.y1};
//		mc._parent.localToGlobal(inRoot1);
//		var isXYChanged:Boolean=false;
//		
//		if(inRoot0.x<margX){ setXRoot(mc, getXRoot(mc)-inRoot0.x+margX); isXYChanged=true; }
//		if(inRoot0.y<margY){ setYRoot(mc, getYRoot(mc)-inRoot0.y+margY); isXYChanged=true; }
//		var sw=Stage.width-margX;
//		var sh=Stage.height-margY;
//		if(inRoot1.x>sw){ setXRoot(mc, getXRoot(mc)-(inRoot1.x-sw)); isXYChanged=true; }
//		if(inRoot1.y>sh){ setYRoot(mc, getYRoot(mc)-(inRoot1.y-sh)); isXYChanged=true; }
//		return isXYChanged;
//	}//<<
	
	static public function setRGB(mc:MovieClip, color:Number){
		(new Color(mc)).setRGB(color);
	}//<<
	
	static public function getMC(mc:MovieClip):MovieClip{
		for(var i in mc){
			if(mc[i]._parent==mc){
				return mc[i];
			}
		}
	}//<<
	
	static public function createRectangle(mc:MovieClip, instanceName:String, $isFill:Boolean, $fillColor:Number, $lineStyleArgs:Array):MovieClip{
		var rectmc:MovieClip=mc.createEmptyMovieClip(instanceName, mc.getNextHighestDepth());
		$isFill=$isFill==null ? true : $isFill;
		if($isFill){ rectmc.beginFill($fillColor==null ? 0x00FF33 : $fillColor); }
		if($lineStyleArgs){ rectmc.lineStyle.apply(rectmc, $lineStyleArgs); }
		rectmc.lineTo(100, 0);
		rectmc.lineTo(100, 100);
		rectmc.lineTo(0, 100);
		rectmc.lineTo(0, 0);
		if($isFill){ rectmc.endFill(); }		
		return rectmc;
	}//<<
	
	static public function gotoFlag(mc:MovieClip, flagName:String):Boolean{
		mc.gotoAndStop(mc._totalframes);
		mc.gotoAndStop(flagName);
		return (mc._currentframe!=mc._totalframes);
	}//<<
	
	static public function gotoAndStopByTurn(mc:MovieClip, turn:Number):Void{
		if(turn==1){
			if(mc._currentframe==mc._totalframes){ mc.gotoAndStop(1); }
			else{ mc.nextFrame(); } 
		}else{
			if(mc._currentframe==1){ mc.gotoAndStop(mc._totalframes); }
			else{ mc.prevFrame(); }
		}
	}//<<
	
	static public function gotoFlagAndGetMC(mc:MovieClip, flagName:String):MovieClip{
		if(gotoFlag(mc, flagName)){
			return getMC(mc);
		}else{
			return null;
		}
	}//<<
	
	static public function gotoFrameAndGetMC(mc:MovieClip, frame:Number):MovieClip{
		mc.gotoAndStop(frame);
		return getMC(mc);
	}//<<
	
	/** @return Array of MovieClip */
	static public function getMCS(mc:MovieClip, iniName:String):Array{
		var mcs:Array=[];
		for(var i=0,eleMC:MovieClip;eleMC=mc[iniName+i];i++){
			mcs.push(eleMC);
		}
		return mcs;
	}//<<
	
	/** @return Array of MovieClip */
	static public function setMCS(mc0:MovieClip, sum:Number):Array {
		var mcs:Array=[];
		var iniName:String=mc0._name.substr(0, mc0._name.length-1);
		for(var i=0;i<sum;i++){
			if(!mc0._parent[iniName+i]){
				mc0.duplicateMovieClip(iniName+i, mc0._parent.getNextHighestDepth());
			}
			mcs.push(mc0._parent[iniName+i]);
		}
		return mcs;
	}//<<
	
	/** @return Array of MovieClip */
	static public function getMCS2Level(mc:MovieClip, iniName:String, iniSubName:String):Array{
		var mcs:Array=[];
		for(var i=0,eleMC:MovieClip;eleMC=mc[iniName+i];i++){
			mcs.push(eleMC[iniSubName]);
		}
		return mcs;
	}//<<
	
	static public function isAtFrame(mc:MovieClip, frame):Boolean{
		return (mc._currentframe==getFrameNumber(frame));
	}//<<
	
	static public function isBetweenFrames(mc:MovieClip, frameIni, frameEnd):Boolean{
		return (mc._currentframe>=getFrameNumber(mc, frameIni) && mc._currentframe<=getFrameNumber(mc, frameEnd));
	}//<<
	
	/**
	 * @param frame anchor label name or number of frame
	 * @return number of frame
	 */
	static public function getFrameNumber(mc:MovieClip, frame):Number {
		if(!isNaN(frame)){ return frame; }
		var anchor:String=frame;
		var gettMCName:String=mc._name+'AnchorNumberGetter';
		
		if(!mc._parent[gettMCName]){
			mc._parent[gettMCName]=mc.duplicateMovieClip(gettMCName, getNextLowestDepth(mc._parent));
			MILibUtil.hideVariables(mc._parent, [gettMCName]);
			disableMC(mc._parent[gettMCName]);
			mc._parent[gettMCName].gotoAndStop(1);
			mc._parent[gettMCName].anchors={};
		}
		var gettMC:MovieClip=mc._parent[gettMCName];
		
		if(!gettMC.anchors[frame]){
			gettMC.gotoAndStop(frame);
			gettMC.anchors[frame]=gettMC._currentframe;
			gettMC.gotoAndStop(1);
		}
		
		if(isNaN(gettMC.anchors[frame])){
			_root.log('MIMCUtil.getFrameNumber: get anchor ('+anchor+') frame number isNaN()>'+_root.link(gettMC.anchors[frame]));
		}
		
		return gettMC.anchors[frame];
	}//<<
	
	static public function getNextLowestDepth(mc:MovieClip):Number {
		var depth:Number=1;
		while(mc.getInstanceAtDepth(depth)){
			depth++;
			if(depth>10000){ _root.log('getNextLowestDepth for mc>'+_root.link(mc)+' <b>depth>10000</b>'); break; }
		}
		return depth;
	}//<<
	
	static public function setBtnWithNoHandCursor(mc:Object):Void {
		mc.onPress=function(){};
		mc.useHandCursor=false;
	}//<<
	
	static public function swapDepthToUp(mc:MovieClip):Void{		
		if(mc._parent.getNextHighestDepth()-1>mc.getDepth()){
			mc.swapDepths(mc._parent.getInstanceAtDepth(mc._parent.getNextHighestDepth()-1));
		}
	}//<<
	
	static public function swapDepthToUpWith(mc:MovieClip, withMC:MovieClip):Void{		
		if(withMC.getDepth()>mc.getDepth()){ mc.swapDepths(withMC); }
	}//<<
	
	static public function swapDepthToDownWith(mc:MovieClip, withMC:MovieClip):Void{		
		if(withMC.getDepth()<mc.getDepth()){ mc.swapDepths(withMC); }
	}//<<
	
	static public function swapDepthToDown(mc:MovieClip){
		for(var i in mc._parent){
			if(mc._parent[i]._parent==mc._parent){
				if(mc._parent[i].getDepth()<mc.getDepth()){
					mc.swapDepths(mc._parent[i]);
				}
			}
		}
	}//<<
	
	static public function getLowestDepth(mc:MovieClip){
		var depth:Number=Infinity;
		for(var i in mc){
			if(mc[i].getDepth()<depth){ depth=mc[i].getDepth(); }
		}
		return depth-1;
	}//<<
	
	static public function unloadAllSubMCS(mc:MovieClip):Void {
		for(var i in mc){
			if(mc[i]._parent==mc){
				mc[i].unloadMovie();
			}
		}
	}//<<
	
	static public function disableMC(mc:MovieClip):Void {
		unloadAllSubMCS(mc);
		mc.stop();		mc._visible=false;
	}//<<
	
	static public function createDownUnvisibleNoPressRectMC(mc:MovieClip, name:String):MovieClip {
		var mc_noPress:MovieClip=MIMCUtil.createRectangle(mc, name);
		mc_noPress._alpha=0;
		MIMCUtil.setBtnWithNoHandCursor(mc_noPress);
		MIMCUtil.swapDepthToDown(mc_noPress);
		return mc_noPress;
	}//<<
	
	static public function getHighestMCFromMCS(mcs:Array):MovieClip {
		var highestMC:MovieClip=mcs[0];
		for(var i=1;i<mcs.length;i++){
			highestMC=getHighestMC(highestMC, mcs[i]);
		}
		return highestMC;
	}//<<
	
	static public function getHighestMC(mc0:MovieClip, mc1:MovieClip):MovieClip {
		if(mc0==mc1){ return mc0; }
		var mcs0:Array=getMCParents(mc0);		var mcs1:Array=getMCParents(mc1);
		var len:Number=Math.max(mcs0.length, mcs1.length);
		for(var i=0;i<len;i++){
			if(mcs0[i]!=mcs1[i]){
				if(!mcs1[i]){ return mc0; }
				if(!mcs0[i]){ return mc1; }
				if(mcs0[i].getDepth()>mcs1[i].getDepth()){
					return mc0;
				}else{
					return mc1;
				}
				break;
			}
		}
		return mc0;
	}//<<
	
	static public function getMCParents(mc:MovieClip):Array {
		var arr:Array=[];
		var mcTmp:MovieClip=mc;
		while(mcTmp._parent){
			arr.unshift(mcTmp._parent);
			mcTmp=mcTmp._parent;
		}
		return arr;
	}//<<
	
	static public function getMCParentsNames(mc:MovieClip):Array {
		return ['_root'].concat(mc._target.split('/'));
	}//<<
	
	static public function getMCByNames(names:Array):MovieClip {
		var mc:MovieClip=_root;
		names.shift();
		while(names.length){
			mc=mc[names.shift()];
		}
		return mc;
	}//<<
	
	static public function getMouseHITMCS(Void):Array {
		var mcs:Array=[];
		var cmc:MovieClip=_root;
		var isHit:Boolean;
		while(true){
			mcs.push(cmc);
			isHit=false;
			for(var i in cmc){
				if(cmc[i]._parent==cmc){
					var xy={x:cmc[i]._xmouse, y:cmc[i]._ymouse};
					cmc[i].localToGlobal(xy);
					if(cmc[i].hitTest(xy.x, xy.y, true) && i!='MCForCursorManager'){
						cmc=cmc[i];
						isHit=true;
						break;
					}
				}
				if(isHit){ break; }
			}
			if(!isHit){ break; }
		}
		return mcs;
	}//<<
	
}
