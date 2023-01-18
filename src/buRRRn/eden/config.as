
/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is eden: ECMAScript data exchange notation AS2. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2004-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):

   		- ALCARAZ Marc (aka eKameleon) <vegas@ekameleon.net>   		 
   		Eden for VEGAS, use this version only with Vegas AS2 Framework Please.
  
*/

/**
	NameSpace: config
   	Configure the eden library.
*/
class buRRRn.eden.config extends Object
    {
    
    /**
       StaticProperty: compress
       Parameter to remove (true) or add (false) all unecessary spaces,
       tabs, carriages returns, lines feeds etc.
       to optimize (more or less) packets of datas when they are transfered.
       
       note:
       use "compress = false" when you want
       to have a better view or debug packets of datas.
    */
    static var compress:Boolean = true;
    
    /**
       StaticProperty: copyObjectByValue
       Parameter allowing to copy objects by value
       if true or by reference if false.
       
       exemple:
       foo = {a:1, b:2, c:3};
       bar = foo;
       
       in this case with copyObjectByValue = false
       bar will be a reference to the foo object
       but if copyObjectByValue = true
       bar will be an exact copy of foo object
    */
    static var copyObjectByValue:Boolean = false;
    
    /**
       StaticProperty: strictMode
       Allows to define the case-sensitivy of the parsers.
       If true, variable names that differ only in case are
       considered different.
    */
    static var strictMode:Boolean = true;
    
    /**
       StaticProperty: undefineable
       Value assigned to a variable
       when this one is not found or not authorized.
       
       note:
       Depending on your environment you can
       override it with a more suitable one
       for exemple on C# you could set it
       to null.
    */
    static var undefineable = undefined ;
    
    /**
       StaticProperty: verbose
       Parameter allowing to trace messages
       in the console if the environment permit it.
    */
    static var verbose:Boolean = true ;
    
    /**
       StaticProperty: security
       Parameter setting on (true) or off (false) the security.
       If true, all object path, function or constructor will
       be scanned at interpretation time against the
       authorized list (see: buRRRn.eden.config.authorized).
    */
    static var security:Boolean = true ;
    
    /**
    	StaticProperty: authorized
       	List of authorized keywords, objects path and constructors
       	that the parser is allowed to interpret.
	       
       	note:
       	you can add full path
       	ex: "blah.foobar"
       	and/or starting path
       	ex: "toto.titi.*"
	       
       	the difference is
       	with a full path you can only
       	create/use/define/assign value to this exact path
       	and
       	with a starting path you can
       	create/use/define/assign value to this path and its child paths
	       
       	attention:
       	special values as
       	NaN, true, false, null, undefined
       	are always authorized
    	*/
    static var authorized:Array = [ 
		"Array", "Boolean", "Date", "Error",
		"Math.*", "Number.*", "Object", "String.*",
        "Infinity" 
	] ;
    
    /**
     * StaticProperty: allowFunctionCall
     * Allows to execute function call is set to true,
     * set to false it blocks any functrion call and return undefined.
     *  
     * exemple:
     * "titi = \"hello world\";
     * toto = titi.toUpperCase();"
     *  
     * with allowFunctionCall= true
     * toto will equal "HELLO WORLD"
     * but with allowFunctionCall = false
     *  toto will equal undefined
     */
    static var allowFunctionCall:Boolean = false ;
    
    /* StaticProperty: autoAddScopePath
    */
    static var autoAddScopePath:Boolean = false;
    
    /* StaticProperty: arrayIndexAsBracket
       When set to false array index are evaluated without bracket
       eval( test.0 )
       for Flash ActionScript
       
       When set to true array index are evaluated with bracket
       eval( test[0] )
       for JavaScript, JScript, JSDB etc.
    */
    static var arrayIndexAsBracket:Boolean = false;
    
    }

