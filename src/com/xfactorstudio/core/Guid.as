/**
	Copyright (c) 2002 Neeld Tanksley.  All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	1. Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.
	
	2. Redistributions in binary form must reproduce the above copyright notice,
	this list of conditions and the following disclaimer in the documentation
	and/or other materials provided with the distribution.
	
	3. The end-user documentation included with the redistribution, if any, must
	include the following acknowledgment:
	
	"This product includes software developed by Neeld Tanksley
	(http://xfactorstudio.com)."
	
	Alternately, this acknowledgment may appear in the software itself, if and
	wherever such third-party acknowledgments normally appear.
	
	4. The name Neeld Tanksley must not be used to endorse or promote products 
	derived from this software without prior written permission. For written 
	permission, please contact neeld@xfactorstudio.com.
	
	THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES,
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
	FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL NEELD TANKSLEY
	BE LIABLE FOR ANY DIRECT, INDIRECT,	INCIDENTAL, SPECIAL, EXEMPLARY, OR 
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
	GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
	HOWEVER CAUSED AND ON ANY THEORY OF	LIABILITY, WHETHER IN CONTRACT, STRICT 
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT 
	OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

class com.xfactorstudio.core.Guid{
	private static var BYTE_MAX:Number = 255;
	private static var INT16_MAX:Number = 65535;
	private static var INT32_MAX:Number = 4294967295;
	public var _id:Array;
	
	public function get id(){
		return _id.join("-");
	}
	
	// CONSTUCTOR
	public function Guid(a,b,c,d,e,f,g,h,i,j,k){
		if(arguments.length == 11){
			this._id = generateGUID(a,b,c,d,e,f,g,h,i,j,k)
		}else if(arguments.length == 1 && typeof(arguments[0]) == "string"){
			this._id = parseGUID(arguments[0]);
		}else{
			this._id = generateGUID(0,0,0,0,0,0,0,0,0,0,0);
		}
	}
	
	/**
		Static method that returnes an instance of
		a Guid initialized to a random value
	**/
	public static function newGuid(){
		var ng = new Guid();
		ng._id = generateRandomGUID();
		return ng;
	}
	
	public function toString():String{
		return this.id;
	}
	
	/*************************
		Private Methods
	**************************/
	
	private static function parseGUID(strGuid:String){
		var wArr = strGuid.split("-");
		var arr = new Array();
		arr.push(int32toHex(parseInt("0x"+wArr[0])));
		arr.push(int16toHex(parseInt("0x"+wArr[1])));
		arr.push(int16toHex(parseInt("0x"+wArr[2])));
		arr.push(bytetoHex(parseInt("0x"+wArr[3].substring(0,2))) + bytetoHex(parseInt("0x"+wArr[3].substring(2,4))));
		arr.push(bytetoHex(parseInt("0x"+wArr[4].substring(0,2))) + 
				bytetoHex(parseInt("0x"+wArr[4].substring(2,4))) + 
				bytetoHex(parseInt("0x"+wArr[4].substring(4,6))) + 
				bytetoHex(parseInt("0x"+wArr[4].substring(6,8))) + 
				bytetoHex(parseInt("0x"+wArr[4].substring(8,10))) + 
				bytetoHex(parseInt("0x"+wArr[4].substring(10,12))));
		
		return arr;
	}
	
	private static function generateGUID(a,b,c,d,e,f,g,h,i,j,k){
		var arr = new Array();
		arr.push(int32toHex(a)); //32
		arr.push(int16toHex(b)); //16
		arr.push(int16toHex(c)); //16
		arr.push(bytetoHex(d) + bytetoHex(e)); //two bytes
		arr.push(bytetoHex(f) + bytetoHex(g) + bytetoHex(h) + bytetoHex(i) + bytetoHex(j) + bytetoHex(k));
		return arr;
	}
	
	private static function generateRandomGUID(){
		var arr = new Array();
		arr.push(randomHex(INT32_MAX)); //32
		arr.push(randomHex(INT16_MAX)); //16
		arr.push(randomHex(INT16_MAX)); //16
		arr.push(randomHex(BYTE_MAX) + randomHex(BYTE_MAX)); //two bytes
		arr.push(randomHex(BYTE_MAX) + randomHex(BYTE_MAX) + randomHex(BYTE_MAX) + randomHex(BYTE_MAX) + randomHex(BYTE_MAX) + randomHex(BYTE_MAX));
		return arr;
	}
	
	static function randomHex(size:Number){
		switch(size){
			case BYTE_MAX:
				return bytetoHex((Math.random()*BYTE_MAX));
				break;
			case INT16_MAX:
				return int16toHex((Math.random()*INT16_MAX));
				break;
			case INT32_MAX:
				return int32toHex((Math.random()*INT32_MAX));
				break;
		}
	}
	

	static function enHex(aDigit){
    	return("0123456789ABCDEF".substring(aDigit, aDigit+1))
	}
	

	static function deHex(aDigit){
		return("0123456789ABCDEF".indexOf(aDigit))
	}
	
	static function int16toHex(n){
		var ret = (enHex((0xf000 & n) >> 12) +
				enHex((0x0f00 & n) >>  8) +
				enHex((0x00f0 & n) >>  4) +
				enHex((0x000f & n) >>  0))
		//trace(ret);
		return ret;
	}
	
	
	static function int32toHex(n){
		var ret =  (enHex((0xf0000000 & n) >> 28) +
				enHex((0x0f000000 & n) >> 24) +
				enHex((0x00f00000 & n) >> 20) +
				enHex((0x000f0000 & n) >> 16) +
				enHex((0x0000f000 & n) >> 12) +
				enHex((0x00000f00 & n) >> 8) +
				enHex((0x000000f0 & n) >> 4) +
				enHex((0x0000000f & n) >> 0))
		
		if(String(ret).length<8)
			ret="0"+ret;
		//trace(ret);
		return ret;
	}
	
	static function bytetoHex(n){
		return ( enHex((0xf0 & n) >>  4) + enHex((0x0f & n) >>  0))
	}

	
	
}