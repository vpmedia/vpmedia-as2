/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASTUce: ActionScript Test Unit compact edition. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2004-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):
   
   	- Marc ALCARAZ (aka eKameleon) : adaptation to VEGAS framework.
     
*/

import buRRRn.ASTUce.Config;
import buRRRn.ASTUce.MiniRunner;

/**
 * You must defined the unittests classpath to localize the Application class of your application.
 * @author eKameleon
 */
class buRRRn.ASTUce.Application 
{

	static public var separator:String = "----------------------------------------------------------------";

	/**
	 * Returns information about the ASTUce framework.
	 */
	static public function getInfo():String
	{
		var str:String = "" ;
		var CRLF:String = "\n" ;
    
    	if( Config.verbose )
        {
        	str += _name + ": " + _fullName + " v" + _version;
        }
    	else
        {
        	str += _name + " v" + _version;
        }
    
		if( Config.verbose )
        {
        	str += CRLF;
        	str += "Copyright (c) 2004-2007 Zwetan Kjukov, All right reserved." + CRLF ;
        	str += "Made in the EU.";
        }
    
    	return str;
	}
	
	/**
	 * Execute the main process of the ASTUce framework.
	 */
	static public function main():Void
	{
		
		trace( separator );
    
    	var runner:MiniRunner = new MiniRunner( "Main Tests" );
    
    	if( Config.testMyself )
        {
        
        	runner.setUp = function()
            {
            	// this.suite.addTest( Tests.AllTests.suite() );
            } ;
        
        }
    
    	if( arguments.length > 0 )
        {
        	for( var i=0; i<arguments.length; i++ )
            {
            	runner.suite.addTest( arguments[i] );
            }
        }
    
    	trace( getInfo() );
    	
    	trace( separator );
    	
    	runner.run();
    	
    	trace( separator );
    
    	if( Config.showConstructorList )
        {
        	trace( runner.suite );
        	trace( separator );
        }
	}

    /**
     * The language extension.
     */
    static private var _ext:String = "AS2";

	/**
	 * The code name of the framework.
 	 */
	static public var _name:String = "ASTUce";
		
	/***
	 * The full name of the framework.
	 */
	static public var _fullName:String = "ActionScript Test Unit compact edition";

    /**
     * The target platform of the framework.
     */
    static private var _platform:String = "Flash ActionScript v2.0";
    	
	/**
	 * The version as string of the framework.
	 */
	static public var _version:String = "1.0.0.0 (VEGAS version)";
	
}