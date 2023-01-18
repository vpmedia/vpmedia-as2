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
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.static_.MIEase extends MIBroadcastClass {
	
	public var event_Changed:Object={name:'Changed'};
	
	private var setupParams : Array;	private var easeFunction : Function;
	private var easeProps : Array;	private var curr01 : Number;
	public var name : String;	
	public function MIEase($name:String) {
		easeProps=[];
		setupEaseSin();
		if($name){
			name=$name;
			_global.pl.milib.anim.dbg.AnimationsDBG.getInstance().regEase(this);
		}
	}//<>
	
	public function ease01(n01:Number):Number {
		curr01=n01;
		return Number(easeFunction.apply(this, easeProps));
	}//<<
	public function ease01WithMirrorEase(n01:Number):Number {
		return 1-ease01(1-n01);
	}//<<
	
	public function setupEaseNone(Void):MIEase { return setupEaseFunctionAndAruments(none); }//<<
	public function setupEaseLog(Void):MIEase { return setupEaseFunctionAndAruments(Log); }//<<
	public function setupEaseSin(Void):MIEase { return setupEaseFunctionAndAruments(sin); }//<<
	public function setupEaseCirc(Void):MIEase { return setupEaseFunctionAndAruments(circ); }//<<
	public function setupEaseCircHard(Void):MIEase { return setupEaseFunctionAndAruments(circHard); }//<<
	
	public function setupEasePow(num:Number):MIEase {
		return setupEaseFunctionAndAruments(pow, [num]);
	}//<<
	public function setupEaseBezier(n0:Number, n1:Number):MIEase {
		return setupEaseFunctionAndAruments(bezier, [n0, n1]);
	}//<<
	public function setupEaseBezier2(n0:Number, n05:Number, n1:Number):MIEase {
		return setupEaseFunctionAndAruments(bezier2, [n0, n05, n1]);
	}//<<
	public function setupEaseBounce(garby:Number, moc:Number, tar:Number):MIEase {
		return setupEaseFunctionAndAruments(bounce, [garby, moc, tar]);
	}//<<
	public function setupEaseElastic(garby:Number, dyn:Number, moc:Number, tar:Number):MIEase {
		return setupEaseFunctionAndAruments(elastic, [garby, dyn, moc, tar]);
	}//<<
	private function setupEaseFunctionAndAruments(func:Function, args:Array):MIEase {
		easeFunction=func;
		easeProps=args==null ? [] : args;
		bev(event_Changed);
		return this;
	}//<<
	
	public function getEaseName(Void):String {
		var name:String=MILibUtil.getMethodName(this, easeFunction);
		return name.substr(0, 1).toUpperCase()+name.substr(1);
	}//<<
	
	public function getEaseProps(Void):Array {
		return easeProps;
	}//<<
	
	public function setupEaseProp(value:Number, propIndex:Number):Void {
		easeProps[propIndex]=value;
		bev(event_Changed);
	}//<<
	
	private function none(Void):Number { return curr01; }//<<
	
	private function Log(Void):Number {return -Math.log(1-curr01)*.2; }//<<
	
	private function sin(Void):Number {return Math.sin(curr01*1.57); }//<<
	
	private function pow(num:Number):Number {
		num=Math.pow(curr01, num);
		if(num<0.0000108){return 0;}
		return num;
	}//<<
	
	private function dist(n0:Number, n1:Number):Number {
		return Math.max(n0, n1)-Math.min(n0, n1); 
	}//<<
	
	private function circ(Void):Number {
		return -(Math.sqrt(1 - curr01*curr01) - 1);
	}//<<
	
	private function circHard(Void):Number {
		var c:Number=circ();
		c-=(c*.8)*(1-c);
		return c;
	}//<<
	
	private function bezier(n0:Number, n1:Number):Number {
		return 1-bezierALG(curr01, 0, n0, n1, 1);
	}//<<
	
	private function bezier2(n0:Number, n05:Number, n1:Number):Number {
		return 1-bezier2ALG(curr01, 0, n0, n05, n1, 1);
	}//<<
	
	//ob-->garby:1|40, moc:0|3, tar:0|3
	private function bounce(garby:Number, moc:Number, tar:Number):Number {
		var dzi01:Number=1/(int(garby)+.5);
		var gln:Number=(-Math.log(1-curr01)*.2)/dzi01;
		var glp:Number=gln-int(gln);
		var gln2:Number=gln*2;
		var part4:Number=(gln2+6)%4;
		var part4P:Number=part4-int(part4);
		if(gln2<1){
			return 1+Math.sin(-(1-part4P)*1.57);
		}else{
			var skokSpow:Number=spow(moc, gln/tar);
			if(part4>=0 && part4<1){//_______0
				return 1-Math.sin((1-part4P)*1.57)*skokSpow;
			}else if(part4>=1 && part4<2){//_1
				return 1+Math.sin(-part4P*1.57)*skokSpow;
			}else if(part4>=2 && part4<3){//_2
				return 1+Math.sin(-(1-part4P)*1.57)*skokSpow;
			}else if(part4>=3 && part4<4){//_3
				return 1-Math.sin(part4P*1.57)*skokSpow;
			}
		}
	}//<<
	
	//garby:1|40, dyn:0|5, moc:0|3, tar:0|3
	private function elastic(garby:Number, dyn:Number, moc:Number, tar:Number):Number {
		var dzi01=1/(int(garby)+.5);
		var gln=Math.pow(curr01, dyn)/dzi01;
		var glp=gln-int(gln);
		var gln2=gln*2;
		var part4=(gln2+6)%4;
		var part4P=part4-int(part4);
		var skokSpow=spow(moc, gln/tar);
		if(gln<1){
			return Math.sin(glp*1.57)*(1+skokSpow);
		}else{
			if(part4>=0 && part4<1){//_______0
				return 1+Math.sin((1-part4P)*1.57)*skokSpow;
			}else if(part4>=1 && part4<2){//_1
				return 1+Math.sin(-part4P*1.57)*skokSpow;
			}else if(part4>=2 && part4<3){//_2
				return 1+Math.sin(-(1-part4P)*1.57)*skokSpow;
			}else if(part4>=3 && part4<4){//_3
				return 1+Math.sin(part4P*1.57)*skokSpow;
			}
		}
	}//<<
	
	private function bezierALG1(t:Number):Number { return t*t*t; }
	private function bezierALG2(t:Number):Number { return 3*t*t*(1-t); }
	private function bezierALG3(t:Number):Number { return 3*t*(1-t)*(1-t); }
	private function bezierALG4(t:Number):Number { t=1-t;return t*t*t; }
	private function bezierALG(cou:Number, n1:Number, n2:Number, n3:Number, n4:Number):Number {
		return	n1*bezierALG1(cou)+ n2*bezierALG2(cou)+ n3*bezierALG3(cou)+ n4*bezierALG4(cou);
	}//<<
	
	private function bezier2ALG1(t:Number):Number { return t*t*t*t; }
	private function bezier2ALG2(t:Number):Number { return 4*t*t*t*(1-t); }
	private function bezier2ALG3(t:Number):Number { return 6*t*t*(1-t)*(1-t); }
	private function bezier2ALG4(t:Number):Number { return 4*t*(t-=1)*t*t; }
	private function bezier2ALG5(t:Number):Number { t=1-t;return t*t*t*t; }
	private function bezier2ALG(cou:Number, n1:Number, n2:Number, n3:Number, n4:Number, n5:Number):Number {
		return n1*bezier2ALG1(cou)+ n2*bezier2ALG2(cou)+ n3*bezier2ALG3(cou)+ n4*bezier2ALG4(cou)+ n5*bezier2ALG5(cou);
	}//<<
	
	private function spow(n:Number, spow:Number):Number {
		return n/Math.pow(2,spow-1);
	}//<<
	
	private function getContextText(Void):String {
		return 'ease_'+name;
	}//<<
	
	public function getDebugContents(Void):Array {
		return super.getDebugContents().concat([
			_global.pl.milib.anim.dbg.DBGWindowMIEaseContent.forInstance(this)
		]);
	}//<<
	
}