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


import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.util.MIArrayUtil;

/**
 * @often_name km
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.managers.KeyManager extends MIBroadcastClass implements EnterFrameReciver {
		
	public var event_DownAuto:Object={name:'DownAuto'};
	
	//DATA:	name:String
	//		isNumber:Boolean
	//		isDown:Boolean
	//		isNumPad:Boolean
	//		code:Number
	public var event_Down:Object={name:'Down'};
	
	public var event_Up:Object={name:'Up'};
	
	public var event_Hold:Object={name:'Hold'};
		public var enterFrame_WhenKeyDown:Object={name:'WhenKeyDown'};
	
	static public var KEY_BACK:Number=8;
	static public var KEY_SPACE:Number=32;
	static public var KEY_LEFT:Number=37;
	static public var KEY_RIGHT:Number=39;
	static public var KEY_UP:Number=38;
	static public var KEY_DOWN:Number=40;
	static public var KEY_ENTER:Number=13;
	static public var KEY_CTRL:Number=17;
	static public var KEY_SHIFT:Number=16;
	static public var KEY_ESC:Number=27;
	static public var KEY_A:Number=65;
	static public var KEY_B:Number=66;
	static public var KEY_C:Number=67;
	static public var KEY_D:Number=68;
	static public var KEY_E:Number=69;
	static public var KEY_F:Number=70;
	static public var KEY_G:Number=71;
	static public var KEY_H:Number=72;
	static public var KEY_I:Number=73;
	static public var KEY_J:Number=74;
	static public var KEY_K:Number=75;
	static public var KEY_L:Number=76;
	static public var KEY_M:Number=77;
	static public var KEY_N:Number=78;
	static public var KEY_O:Number=79;
	static public var KEY_P:Number=80;
	static public var KEY_Q:Number=81;
	static public var KEY_R:Number=82;
	static public var KEY_S:Number=83;
	static public var KEY_T:Number=84;
	static public var KEY_U:Number=85;
	static public var KEY_V:Number=86;
	static public var KEY_W:Number=87;
	static public var KEY_X:Number=88;
	static public var KEY_Y:Number=89;
	static public var KEY_Z:Number=90;
	static public var KEY_0:Number=48;
	static public var KEY_TILDE:Number=192;
	static public var KEY_1:Number=49;
	static public var KEY_2:Number=50;
	static public var KEY_3:Number=51;
	static public var KEY_4:Number=52;
	static public var KEY_5:Number=53;
	static public var KEY_6:Number=54;
	static public var KEY_7:Number=55;
	static public var KEY_8:Number=56;
	static public var KEY_9:Number=57;
	static public var KEY_COMMA:Number=188;
	static public var KEY_DOT:Number=190;
	static public var KEY_F1:Number=112;
	static public var KEY_F2:Number=113;
	static public var KEY_F3:Number=114;
	static public var KEY_F4:Number=115;
	static public var KEY_F5:Number=116;
	static public var KEY_F6:Number=117;
	static public var KEY_F7:Number=118;
	static public var KEY_F8:Number=119;
	static public var KEY_F9:Number=120;
	static public var KEY_PAUSE:Number=19;
	static public var KEY_NUM_0:Number=96;
	static public var KEY_NUM_1:Number=97;
	static public var KEY_NUM_2:Number=98;
	static public var KEY_NUM_3:Number=99;
	static public var KEY_NUM_4:Number=100;
	static public var KEY_NUM_5:Number=101;
	static public var KEY_NUM_6:Number=102;
	static public var KEY_NUM_7:Number=103;
	static public var KEY_NUM_8:Number=104;
	static public var KEY_NUM_9:Number=105;
	
	static public var numsAndNames:Array=[
		[8,'Back'],
		[32,'Space'],
		[37,'Left'],
		[39,'Right'],
		[38,'Up'],
		[40,'Down'],
		[13,'Enter'],
		[65,'A'],
		[66,'B'],
		[67,'C'],
		[68,'D'],
		[69,'E'],
		[70,'F'],
		[71,'G'],
		[72,'H'],
		[73,'I'],
		[74,'J'],
		[75,'K'],
		[76,'L'],
		[77,'M'],
		[78,'N'],
		[79,'O'],
		[80,'P'],
		[81,'Q'],
		[82,'R'],
		[83,'S'],
		[84,'T'],
		[85,'U'],
		[86,'V'],
		[87,'W'],
		[88,'X'],
		[89,'Y'],
		[90,'Z'],
		[48,'0'],
		[49,'1'],
		[50,'2'],
		[51,'3'],
		[52,'4'],
		[53,'5'],
		[54,'6'],
		[55,'7'],
		[56,'8'],
		[57,'9'],
		[188,','],
		[190,'.'],
		[112,'F1'],
		[113,'F2'],
		[114,'F3'],
		[115,'F4'],
		[116,'F5'],
		[117,'F6'],
		[118,'F7'],
		[119,'F8'],
		[120,'F9'],
		[19,'Pause'],
		[96,'0'],
		[97,'1'],
		[98,'2'],
		[99,'3'],
		[100,'4'],
		[101,'5'],
		[102,'6'],
		[103,'7'],
		[104,'8'],
		[105,'9']
	];
	
	private static var instance:KeyManager;
	private var keyListener:Object;
	private var downs:Array;
	private var nums:Array;
	private var names:Array;
	private var namesByCodes : Array;
	
	private function KeyManager(){
		Key.addListener(this);
		
		downs=[];
		nums=[];
		names=[];
		var str='';
		var numsAndNames=KeyManager.numsAndNames;
		for(var i=0,vl;vl=numsAndNames[i];i++){
			names[vl[1]]=
			nums[vl[0]]={
				name:vl[1]==int(vl[1]) ? int(vl[1]) : vl[1],
				isNumber:(vl[1]==int(vl[1])),
				isDown:false,
				isNumPad:(int(vl[0])>=96 && int(vl[0])<=105),
				code:vl[0]
			};
			str+=vl[1]+' ';
		}
		
		namesByCodes=MIArrayUtil.getByProp(KeyManager.numsAndNames, 0);
		
	}//<>
	
	static public function getInstance():KeyManager{
		if(instance == null){ instance = new KeyManager(); }
		return instance;
	}//<<
	
	public function getKeyNameByCode(code:Number):String{
		return namesByCodes[code][1];
	}//<<
	
	public function getKeysNamesByCodes(keyCodes:Array):Array{
		var tab:Array=[];
		for(var i=0;i<keyCodes.length;i++){
			tab.push(getKeyNameByCode(keyCodes[i]));
		}
		return tab;
	}//<<

	private function setKeyDown(obj){
		obj.isDown=true;
		obj.timeDown=getTimer();
		downs.push(obj);
		bev(event_Down, obj);
		return obj.name;
	}//<<
	
	private function setKeyUp(obj){
		obj.isDown=false;
		obj.timeUp=getTimer();
		obj.timeDowned=obj.timeUp-obj.timeDown;
		for(var i=0;i<downs.length;i++){
			if(!Key.isDown(downs[i].code)){
				downs.splice(i, 1);
				i--;
			}
		}
		bev(event_Up, obj);
		return obj.name;
	}//<<
	
//****************************************************************************
// EVENTS for KeyManager
//****************************************************************************
	public function onEnterFrame(id) : Void {
		for(var i=0,vl;vl=downs[i];i++){
			bev(event_Hold, vl);
		}
	}//<<
	
	private function onKeyDown(){
		EnterFrameBroadcaster.start(this, enterFrame_WhenKeyDown);
		var obj=nums[Key.getCode()];
		if(obj){
			if(!obj.isDown){
				setKeyDown(obj);
			}else{
				bev(event_DownAuto, obj);
			}
		}
	}//<<
	
	private function onKeyUp(){
		var obj=nums[Key.getCode()];
		if(obj){
			if(obj.isDown){
				setKeyUp(obj);
			}
		}
		if(!downs.length){
			EnterFrameBroadcaster.stop(this, enterFrame_WhenKeyDown);
		}
	}//<<

}
