﻿/** * XMLSurfer * @author tPS * @version 1 **/class com.tPS.xml.XMLSurfer{		static public function getNodeWithName($name:String,$xml:XML):XML{		var node:XML;				if($xml.attributes.name == $name){			return $xml;			break;		}else{			var i:Number = $xml.childNodes.length;			while ( --i > -1 ) {				var anode = getNodeWithName($name,$xml.childNodes[i]);				if(anode){					node = anode;					break;				}			}		}		return node;	}		static public function getNodeWithNodename($name:String, $xml:XML, $offset:Number):XML{		var node:XML;		if($xml.nodeName == $name){			return $xml;			break;		}else{			var i:Number = $xml.childNodes.length;			var j:Number = -1;			var o:Number = ($offset != undefined) ? $offset : 0;			var off:Number = -1;			while ( ++j < i ) {				var anode:XML = getNodeWithNodename($name,$xml.childNodes[j]);				if(anode){					off ++;					if(off == o){						node = anode;						break;					}				}			}		}		return node;	}		static public function getParentFromNodename($name:String,$xml:XML):XML{		var node:XML;				//check for all childs		var i:Number = $xml.childNodes.length;		while (--i > -1) {			if( $xml.childNodes[i].nodeName == $name ){				return $xml;				break;			}else{				var anode:XML = getParentFromNodename($name,$xml.childNodes[i]);				if(anode){					node = anode;					break;				}			}		}				return node;	}		static public function getNodePosition($nodename:String,$xml:XML):Number{		var nodePos:Number = -1;		var i:Number = -1;		while($xml.childNodes[++i]){			if($xml.childNodes[i].attributes.name == $nodename){				nodePos = i;				break;			}		}		return nodePos;	}		static public function getNodenamePosition($nodename:String,$xml:XML):Number{		var nodePos:Number = -1;		var i:Number = $xml.childNodes.length;		while(--i>-1){			if($xml.childNodes[i].nodeName == $nodename){				nodePos = i;				break;			}		}		return nodePos;	}}