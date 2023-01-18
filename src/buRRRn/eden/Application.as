
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

import buRRRn.eden.config;
import buRRRn.eden.ECMAScript;

import vegas.util.ArrayUtil;
import vegas.util.serialize.Serializer;
import vegas.util.StringUtil;

/**
 * The eden application.
 */
class buRRRn.eden.Application
    {
    
    /* StaticProperty: logs
    */
    static var logs:Array = [];
    
    /* PrivateStaticMethod: _trace
       Allows to display messages in the console.
    */
    static function _trace( message:String )
    {
        trace( message );
    }
    
    /* StaticMethod: log
       Add a message to the logs queue.
    */
    static function log( message:String )
    {
        logs.push( message );
        
        if( config.verbose )
        {
            _trace( message );
        }
	}
    
    /** 
    * StaticMethod: showLogs
    * Display all the logs in the console.
    */
    static function showLogs()
        {
        for( var i=0; i<logs.length; i++ )
            {
            _trace( logs[i] );
            }
        }

    
    /**
     * StaticEvent: onParsed
     * To override.
     */
    static function onParsed( value )
        {
        return value;
        }
    
    /* StaticMethod: deserialize
       Dynamically interpret a source string.
       That's it, a small and fast ECMAScript parser.
    */
    static function deserialize( source:String, scope, callback )
        {
        return ECMAScript.evaluate( source, scope, callback );
        }
    
    /* StaticMethod: serialize
       Takes an object reference
       and serialize it as an ECMAScript string.
    */
    static function serialize( reference, indent:Number ):String
        {
        
        if( !config.compress )
            {
            if( indent == null )
                {
                indent = 0;
                }
            }
        
        if( reference === _global )
            {
            return Serializer.globalToSource( indent );
            }
        
        if( reference === undefined )
            {
            return config.undefineable;
            }
        
        if( reference === null )
            {
            return "null";
            }
        
        return Serializer.toSource( reference, indent );
        }
    
    /* StaticMethod: addAuthorized
       
    */
    static function addAuthorized( path:String, /*...*/ pathN )
    {
        
        var l:Number = arguments.length ;
        
        for( var i:Number = 0 ; i<l; i++ )
    	{
            if( ! ArrayUtil.contains(config.authorized, arguments[i] ) )
            {
                config.authorized.push( arguments[i] );
            }
        }
    }
    
    /* StaticMethod: removeAuthorized
       
    */
    static function removeAuthorized( path:String, /*...*/ pathN )
        {
        var paths, i, found;
        paths = ArrayUtil.fromArguments( arguments );
        
        for( i=0; i<paths.length; i++ )
            {
            found = ArrayUtil.indexOf( config.authorized, paths[i] );
            if( found > -1 )
                {
                config.authorized.splice( found, 1 );
                }
            }
        }
    
    /* StaticMethod: isAuthorized
       
    */
    static function isAuthorized( path:String )
        {
        
        var strictMode:Boolean  = config.strictMode ;
        var pathMode:Boolean    = false ;
        
        var firstLetter:String = path.charAt( 0 ) ;
        
        if( path.indexOf( "." ) > -1 )
            {
            pathMode = true;
            }

        if( !strictMode )
            {
            firstLetter = firstLetter.toLowerCase();
            }
        
        var filterFirstLetter = function( value, index, arrObj )
            {
            
            if( !strictMode )
                {
                value = value.toLowerCase();
                }
           
            return ( StringUtil.startsWith( value, firstLetter ) ) ;
            
            } ;
        
        var whiteList:Array = ArrayUtil.filter( config.authorized, filterFirstLetter ) ;

        if( whiteList.length == 0 ) return false ;
        
        var whiteListPath:String ;

        var len:Number = whiteList.length ;
		
        for( var i:Number = 0 ; i<len; i++ )
        {
            whiteListPath = whiteList[i];
            if( 
            	pathMode &&
                	StringUtil.endsWith( whiteListPath, "*" ) && 
                		StringUtil.startsWith( path, StringUtil.replace( whiteListPath, "*", "" )  )
            )
            {
                return true;
			}
            else if( path == StringUtil.replace( whiteListPath, ".*", "" ) )
            {
                return true;
			}
		}
        
        return false;
	}
    
}

