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

import flash.geom.Point;

class pl.milib.tools.math.Vector {

	public var x : Number;
	public var y : Number;
	
	public function Vector($x:Number, $y:Number) { 
	    x=$x==null ? 0 : $x;
	    y=$y==null ? 0 : $y;
	}//<>
	
	public function getLength(Void):Number { 
	    var ret:Number=Math.sqrt(x*x+y*y); 
		if(isNaN(ret)){
			return 0;
		}else{
			return ret;
		}
	}//<<
	public function setLength(newLength:Number):Void {
		var length:Number=getLength();
	  	if(length){ scale(newLength/length); }else{ x=newLength; }
	}//<<
	
	public function getAngle(Void):Number { 
	    return Math.atan2(y, x); 
	}//<<
	public function setAngle(newAngle:Number) { 
        var length:Number=getLength(); 
        x=length*Math.cos(newAngle); 
        y=length*Math.sin(newAngle);
	}//<<
	
	public function scale(newScale:Number):Void {
        x*=newScale;
        y*=newScale;
	}//<<
	
	public function movePoint(point:Point, moveScale01:Number):Void {
		point.x+=x*moveScale01;		point.y+=y*moveScale01;
	}//<<
	
	public function plus(vector:Vector) {
        x+=vector.x;
        y+=vector.y;
	}//<<
	
}

////////////////////////////////////////////////////// 
/*
mi.Vector = function (x, y) { 
    this.x = x 
    this.y = y 
}
var ct=mi.Vector.prototype
ct.isVector=true

ct.toString = function () { 
    var rx = Math.round (this.x * 1000) / 1000 
    var ry = Math.round (this.y * 1000) / 1000 
    return "[" + rx + ", " + ry + "]" 
} 

ct.reset = function (x, y) { 
    this.constructor (x, y) 
} 

ct.getClone = function () { 
    return new this.constructor (this.x, this.y) 
} 

ct.plus = function (v) { 
    with (this) { 
        x += v.x 
        y += v.y 
    } 
} 

ct.plusNew = function (v) { 
    with (this) return new constructor (x + v.x, y + v.y)    
} 

ct.minus = function (v) { 
    with (this) { 
        x -= v.x 
        y -= v.y 
    } 
} 

ct.minusNew = function (v) { 
    with (this) return new constructor (x - v.x, y - v.y)    
} 

ct.negate = function () { 
    with (this) { 
        x = -x 
        y = -y 
    } 
} 

ct.negateNew = function (v) { 
    with (this) return new constructor (-x, -y)    
} 

ct.scale = function (s) { 
    with (this) { 
        x *= s 
        y *= s 
    } 
} 

ct.scaleNew = function (s) { 
    with (this) return new constructor (x * s, y * s) 
} 

ct.getLength = function () { 
    var ret=Math.sqrt(this.x*this.x + this.y*this.y) 
	if(isNaN(ret)){
		return 0
	}else{
		return ret
	}
} 

ct.setLength = function (len) { 
   var r = this.getLength() 
   if (r) this.scale (len / r) 
   else this.x = len 
} 

ct.getAngle = function () { 
    return Math.atan2(this.y, this.x) 
} 

ct.setAngle = function (ang) { 
    with (this) { 
        var r = getLength() 
        x = r * Math.cos(ang) 
        y = r * Math.sin(ang) 
    } 
} 

ct.rotate = function (ang) { 
    with (Math) { 
        var ca = cos(ang) 
        var sa = sin(ang) 
    } 
    with (this) { 
        var rx = x * ca - y * sa 
        var ry = x * sa + y * ca 
        x = rx 
        y = ry 
    } 
} 

ct.rotateNew = function (ang) { 
    with (this) var v = new constructor (x, y, z) 
    v.rotate (ang) 
    return v 
} 

ct.dot = function (v) { 
    with (this) return x * v.x + y * v.y 
} 

ct.getNormal = function () { 
    with (this) new constructor (-y, x) 
} 

ct.isNormalTo = function (v) { 
    return (this.dot (v) == 0) 
} 

ct.angleBetween = function (v) { 
    var dp = this.dot (v) // find dot product 
    // divide by the lengths of the two vectors 
    var cosAngle = dp / (this.getLength() * v.getLength()) 
    return Math.acos(cosAngle) // take the inverse cosine 
} 

ct.getPVN=function(radPoz){
	//Poziomy Vektor i Natrcie
	var v=this.getClone()
	v.angle=v.angle-(radPoz+Math.PI)
	var natarcie=Math.sin(v.angle)
	var vRet=new this.constructor(0, 0)
	vRet.length=v.y
	vRet.angle=radPoz-Math.PI/2
	return {v:vRet, natarcie:natarcie}
}//<<

// getter/setter properties for length and angle 
with(ct){
   addProperty ("length", getLength, setLength) 
   addProperty ("angle", getAngle, setAngle) 
} 

//#include "mi\multi\class\Vector.as"
*/

