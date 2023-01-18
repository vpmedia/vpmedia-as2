/****************************************************************************************************************
 * XML.buildObject()												*
 * -----------------												*
 * James Gauld / 09.06.02											*
 *														*
 * ------------------------------------------------------------------------------------------------------------ *
 * Builds a JavaScript style Object from a piece of XML	data so each element can be accessed by using the	*
 * 'dot-syntax' as seen in JavaScript objects.									*
 *														*
 * This script adds a new function to the XML object called 'buildObject()'. You can then call this function on	*
 * your own XML objects:											*
 *	e.g	var myXML = new XML();										*
 *		myXML.load("data.xml");										*
 *		myXMLObject = myXML.buildObject();								*
 *														*
 * USAGE ------------------------------------------------------------------------------------------------------	*
 * 1.	Include this file in your flash FLA file:								*
 *		#include "XMLbuildObj.as"									*
 *														*
 * 2.	Create your XML object and load in the XML data as you would normally. The 'buildObject()' function	*
 *	will only be effective when all the XML data has been fully loaded into flash. For this reason you	*
 *	should use the 'XML.onLoad', 'XML.getBytesLoaded' or 'XML.getBytesTotal' functions to test for fully	*
 *	loaded data.												*
 *														*
 * 3.	Call this function:											*
 *		var myXMLObject = myXML.buildObject();								*
 *														*
 ****************************************************************************************************************/

XML.prototype.buildObject = function (xObj, obj) {
	//----- Initialise objects
	if(xObj==null) xObj = this;
	if(obj==null)  obj = {};
	var a, c, nName, nType, nValue, cCount;


	//----- Add attributes to the object
	for(a in xObj.attributes) {
		obj[a] = xObj.attributes[a];
	}


	//----- Build child nodes
	for(c in xObj.childNodes) {
		nName = xObj.childNodes[c].nodeName;
		nType = xObj.childNodes[c].nodeType;
		nValue = xObj.childNodes[c].nodeValue;
		
		if(nType==3) {
			obj._value = nValue;
			obj._type = 'text';
		}
		
		if(nType==1 && nName!=null) {
			if(obj[nName]==null) {
				obj[nName] = this.buildObject(xObj.childNodes[c], {});
			}
			else if(obj[nName]._type!='array') {
				obj[nName] = [ obj[nName] ];
				obj[nName]._type = 'array';
			}
			if(obj[nName]._type=='array') {
				obj[nName].unshift( this.buildObject(xObj.childNodes[c], {}) );
			}
		}
	}


	// Return object
	return obj;
}