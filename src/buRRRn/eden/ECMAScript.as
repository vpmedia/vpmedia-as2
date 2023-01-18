
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
import buRRRn.eden.strings;

import vegas.util.ConstructorUtil;
import vegas.util.StringUtil;

/**
 * The ECMAScript parser of eden.
 */
class buRRRn.eden.ECMAScript extends buRRRn.eden.GenericParser
{
    
	/**
	 * Creates a new ECMAScript instance.
	 */
    function ECMAScript( source:String, scope, callback )
	{
        
        super( source, callback ) ;
        
        if( scope == null )
        {
            scope = _global; //default assignment scope
        }
        
        var scopepath;
        
        if( scope != _global )
		{
            scopepath = ConstructorUtil.getPath( scope );
		}
        
        if( config.autoAddScopePath && (scopepath != undefined) && (scopepath != "_global") )
		{
			addAuthorized( scopepath + ".*" );
		}
        
        this._ORC          = "\uFFFC" ; // Object Replacement Character
        this.inAssignement = false ;
        this.inConstructor = false ;
        this.inFunction    = false ;
        this.scope         = scope ;
        this.scopepath     = scopepath ;
	}
   
   	/**
   	 * Specified if the source is in assignement.
   	 */
    public var inAssignement:Boolean;

    /**
     * Specified if the source is in a constructor.
     */
	public var inConstructor:Boolean;
    
    /**
     * Specified if the source is in Function.
     */
    public var inFunction:Boolean;
    
    /**
     * The source of the parser.
     */
    public var source:String;
    
    /**
     * The scope used in the parser.
     */
    public var scope;
    
    /**
     * The path of the scope.
     */
    public var scopepath ; 
  
    /**
     * Evaluates the source of this parser.
     */
    public function eval()
	{
        var value, tmp;
        value = _ORC;
        while( hasMoreChar() )
		{
            next();
            scanSeparators();
            tmp = scanValue();
            if( tmp != _ORC )
			{
                value = tmp ;
			}
            /* note: poor man semicolon auto-insertion */
            if( ch == " ")
			{
                ch = ";";
			}
		}
        
        return onParsed( value );
	}
    
    /**
     * Evaluate the specified source value with the ECMAScript parser.
     */
    static public function evaluate( source:String, scope, callback )
	{
        var parser = new buRRRn.eden.ECMAScript( source, scope, callback );
        return parser.eval() ;
	}
    
    /**
     * Returns {@code true} if the specified value is an octal number.
     */
    public function isOctalNumber( num ):Boolean
	{
        
        if( ( num.indexOf( "." ) > -1) || (num.indexOf( "e" ) > -1) || (num.indexOf( "E" ) > -1) )
		{
            return false;
		}
        
        num = num.split("") ;
        
        var l:Number = num.length ;
        for( var i:Number = 0 ; i<l ; i++ )
		{
            if( !isOctalDigit( num[i] ) )
			{
                return false;
			}
		}
		
		return true;
	}
    
    /* Method: isDigitNumber
    */
    function isDigitNumber( num:String ):Boolean
        {
        var i, numarr;
        numarr = num.split( "" );
        
        for( i=0; i<numarr.length; i++ )
            {
            if( !this.isDigit( numarr[i] ) )
                {
                return false;
                }
            }
        
        return true;
        }
    
    /* Method: isIdentifierStart
       
       note:
       identifiers
       see: ECMA-262 spec 7.6 (PDF p26/188)
    */
    function isIdentifierStart( /*char*/ c:String ):Boolean
            {
            if( isAlpha( c ) || (c == "_") || (c == "$" ) )
                {
                return true;
                }
            
            if( c.charCodeAt( 0 ) < 128 )
                {
                return false;
                }
            
            return false;
            }
    
    /* Method: isIdentifierPart
    */
    function isIdentifierPart( /*char*/ c:String ):Boolean
        {
        if( isIdentifierStart( c ) )
            {
            return true;
            }
        
        if( isDigit( c ) )
            {
            return true;
            }
        
        if( c.charCodeAt( 0 ) < 128 )
            {
            return false;
            }
        
        return false;
        }
    
    /* Method: isLineTerminator
       
       note:
       line terminators
       "\n" - \u000A - LF
       "\R" - \u000D - CR
       ???  - \u2028 - LS
       ???  - \u2029 - PS
       see: ECMA-262 spec 7.3 (PDF p24/188)
    */
    function isLineTerminator( /*char*/ c:String ):Boolean
        {
        switch( c )
            {
            case "\u000A": case "\u000D": case "\u2028": case "\u2029":
            return true;
            
            default:
            return false;
            }
        }
    
    /* Method: isReservedKeyword
       
       note:
       Reserved Keywords
       see: ECMA-262 spec 7.5.2 p13 (PDF p25/188)
    */
    function isReservedKeyword( identifier:String ):Boolean
        {
        if( !config.strictMode )
            {
            identifier = identifier.toLowerCase();
            }
        
        switch( identifier )
            {
            case "break":
            case "case": case "catch": case "continue":
            case "default": case "delete": case "do":
            case "else":
            case "finally": case "for": case "function":
            case "if": case "in": case "instanceof":
            case "new":
            case "return":
            case "switch":
            case "this": case "throw": case "try": case "typeof":
            case "var": case "void":
            case "while": case "with":
            
            	var formatter = new vegas.string.StringFormatter( strings.reservedKeyword ) ;
            	log( formatter.format( identifier ) ) ;
	            return true;
            
            default:
            return false;
            }
        }
    
    /* Method: isFutureReservedKeyword
       
       note:
       Future Reserved Keywords
       see: ECMA-262 spec 7.5.3
    */
    function isFutureReservedKeyword( identifier:String ):Boolean
        {
        if( !config.strictMode )
            {
            identifier = identifier.toLowerCase();
            }
        
        switch( identifier )
            {
            case "abstract":
            case "boolean": case "byte":
            case "char": case "class": case "const":
            case "debugger": case "double":
            case "enum": case "export": case "extends":
            case "final": case "float":
            case "goto":
            case "implements": case "import": case "int": case "interface":
            case "long":
            case "native":
            case "package": case "private": case "protected": case "public":
            case "short": case "static": case "super": case "synchronized":
            case "throws": case "transient":
            case "volatile":
            
            	var formatter = new vegas.string.StringFormatter( strings.futurReservedKeyword ) ;
            	log( formatter.format( identifier ) ) ;
	            return true;
            
            default:
            return false;
            }
        }
    
    /* Method: isValidpath
    */
    function isValidPath( path:String ):Boolean
        {
        var i, paths, subpath;
        
        if( path.indexOf( "." ) > -1 )
            {
            paths = path.split( "." );
            }
        else
            {
            paths = [ path ];
            }
        
        for( i=0; i<paths.length; i++ )
            {
            subpath = paths[i];
            
            if( isReservedKeyword( subpath ) ||
                isFutureReservedKeyword( subpath ) )
                {
            	var formatter = new vegas.string.StringFormatter( strings.notValidPath ) ;
            	log( formatter.format( path ) ) ;
                return false;
                }
            }
        
        if( config.autoAddScopePath &&
            (scopepath != undefined) && (scope != _global) )
            {
            path = scopepath + "." + path;
            }
        
        if( config.security && !isAuthorized( path ) )
            {
            var formatter = new vegas.string.StringFormatter( strings.notAuthorizedPath ) ;
            log( formatter.format( path ) ) ;
            return config.undefineable;
            }
//         else
//             {
//             trace( path + " is authorized (isValidPath)" );
//             }
        
        return true;
        }
    
    /* Method: doesExistInGlobal
    */
    function doesExistInGlobal( path:String ):Boolean
        {
        var i, paths, subpath, scope;    
        scope = _global;
        
        if( path.indexOf( "." ) > -1 )
            {
            paths = path.split( "." );
            }
        else
            {
            paths = [ path ];
            }
        
        for( i=0; i<paths.length; i++ )
            {
            subpath = paths[i];
            
            if( isDigitNumber( subpath ) )
                {
                subpath = parseInt( subpath );
                }
            
            if( scope[ subpath ] == undefined )
                {
                return false;
                }
            
            scope = scope[ subpath ];
            }
        
        return true;
        }
    
    /* Method: createPath
    */
    function createPath( path:String )
        {
        var i, scope, paths;
        scope = this.scope;
        
        if( path.indexOf( "." ) > -1 )
            {
            paths = path.split( "." );
            }
        else
            {
            paths = [ path ];
            }
        
        for( i=0; i<paths.length; i++ )
            {
            path = paths[i];
            
            if( scope[path] == undefined )
                {
                scope[path] = {};
                }
            
            scope = scope[path];
            }
        }
    
    /* Method: scanComments
    */
    function scanComments()
        {
        next();
        
        switch( ch )
            {
            case "/":
            while( !isLineTerminator( ch ) )
                {
                next();
                }
            break;
            
            case "*":
            var ch_ = next();
            
            while( (ch_ != "*") && (ch != "/") )
                {
                ch_ = ch;
                next();
                
                if( ch == "" )
                    {
                    log( strings.unterminatedComment );
                    break;
                    }
                }
    
            next();
            delete ch_;
            break;
            
            case "":
            default:
            log( strings.errorComment );
            }
        }
    
    /* Method: scanWhiteSpace
       
       note:
       White Space
       "\t" - \u0009 - TAB
       "\v" - \u000B - VT
       "\f" - \u000C - FF
       " "  - \u0020 - SP
       ???  - \u00A0 - NBSP
       see: ECMA-262 spec 7.2 (PDF p23/188)
    */
    function scanWhiteSpace()
        {
        var scan = true;
        
        while( scan )
            {
            switch( ch )
                {
                case "\u0009": case "\u000B": case "\u000C": case "\u0020": case "\u00A0":
                next();
                break;
                
                case "/":
                scanComments();
                break;
                
                default:
                scan = false;
                }
            }
        }
    
    /* Method: scanSeparators
    */
    function scanSeparators()
        {
        var scan = true;
        
        while( scan )
            {
            switch( ch )
                {
                /* note:
                   White Space
                   "\t" - \u0009 - TAB
                   "\v" - \u000B - VT
                   "\f" - \u000C - FF
                   " "  - \u0020 - SP
                   ???  - \u00A0 - NBSP
                   see: ECMA-262 spec 7.2 (PDF p23/188)
                */
                case "\u0009": case "\u000B": case "\u000C": case "\u0020": case "\u00A0":
                next();
                break;
                
                /* note:
                   line terminators
                   "\n" - \u000A - LF
                   "\R" - \u000D - CR
                   ???  - \u2028 - LS
                   ???  - \u2029 - PS
                   see: ECMA-262 spec 7.3 (PDF p24/188)
                */
                case "\u000A": case "\u000D": case "\u2028": case "\u2029":
                next();
                break;
                
                case "/":
                scanComments();
                break;
                
                default:
                scan = false;
                }
            }
        }
    
    /* Method: scanIdentifier
    */
    function scanIdentifier():String
        {
        var id = "";
        
        if( isIdentifierStart( ch ) )
            {
            id += ch;
            next();
            
            while( isIdentifierPart( ch ) )
                {
                id += ch;
                next();
                }
            }
        else
            {
            log( strings.errorIdentifier );
            }
        
        return id;
        }
    
    /* Method: scanPath
    */
    function scanPath():String
        {
        var path, subpath;
        path = "";
        
        if( isIdentifierStart( ch ) )
            {
            path += ch;
            next();
            
            while( isIdentifierPart( ch ) ||
                   (ch == ".") ||
                   (ch == "[") )
                {
                
                if( ch == "[" )
                    {
                    next();
                    scanWhiteSpace();
                    
                    if( isDigit( ch ) )
                        {
                        subpath = String( scanNumber() );
                        scanWhiteSpace();
                        path += "." + subpath;
                        }
                    else if( (this.ch == "\"") || (this.ch == "\'") )
                        {
                        subpath = scanString( ch );
                        scanWhiteSpace();
                        path += "." + subpath;
                        }
                    
                    if( ch == "]" )
                        {
                        next();
                        continue;
                        }
                    }
                
                
                path += ch;
                next();
                
                }
            }
        
        if( path.startsWith( "_global." ) )
            {
            path = path.substr( "_global.".length );
            }
        
        if( !inConstructor && ch == "(" )
            {
            inFunction = true;
            return scanFunction( path );
            }
        
        return path;
        }
    
    /* Method: scanFunction
    */
    function scanFunction( fcnPath:String )
        {
        var args, fcnName, fcnObj, fcnObjScope;
        
        if( fcnPath.indexOf( "." ) > -1 )
            {
            fcnName = fcnPath.split( "." ).pop();
            }
        else
            {
            fcnName = fcnPath;
            }
        
        scanWhiteSpace();
        
        args = [];
        
        next();
        scanSeparators();
        
        while( ch != "" )
            {
            if( ch == ")" )
                {
                next();
                break;
                }
            
            args.push( scanValue() );
            scanSeparators();
            
            if( ch == "," )
                {
                next();
                scanSeparators();
                }
            }
        
        if( !config.allowFunctionCall )
            {
            var formatter = new vegas.string.StringFormatter( strings.notFunctionCallAllowed ) ;
            log( formatter.format( fcnPath, args ) ) ;
            return config.undefineable;
            }
        
        if( !isReservedKeyword( fcnPath ) && !isFutureReservedKeyword( fcnPath ) )
		{
            fcnObj = eval( "_global." + fcnPath );
            
            if( fcnPath.indexOf( "." ) > -1 )
			{
                fcnObjScope = eval( "_global." + StringUtil.replace( fcnPath, "."+fcnName, "" ) );
            }
            else
            {
                fcnObjScope = null;
            }
		}
        else
		{
            var formatter = new vegas.string.StringFormatter( strings.notValidFunction) ;
            log( formatter.format( fcnPath ) ) ;
            return config.undefineable;
		}
        
        if( config.security && !isAuthorized( fcnPath ) )
		{
            var formatter = new vegas.string.StringFormatter( strings.notAuthorizedFunction ) ;
            log( formatter.format( fcnPath ) ) ;
            return config.undefineable;
		}
//      else
//      {
//          trace( fcnPath + " is authorized (scanFunction)" );
//      }
        
        if( fcnObj == undefined )
        {
            var formatter = new vegas.string.StringFormatter( strings.doesNotExist ) ;
            log( formatter.format( fcnPath ) ) ;
            return config.undefineable;
        }
        else
            {
            return fcnObj.apply( fcnObjScope, args );
            
//             switch( args.length )
//             {
//                 case 9:
//                 return fcnObj( args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8] );
//                 case 8:
//                 return fcnObj( args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7] );
//                 case 7:
//                 return fcnObj( args[0], args[1], args[2], args[3], args[4], args[5], args[6] );
//                 case 6:
//                 return fcnObj( args[0], args[1], args[2], args[3], args[4], args[5] );
//                 case 5:
//                 return fcnObj( args[0], args[1], args[2], args[3], args[4] );
//                 case 4:
//                 return fcnObj( args[0], args[1], args[2], args[3] );
//                 case 3:
//                 return fcnObj( args[0], args[1], args[2] );
//                 case 2:
//                 return fcnObj( args[0], args[1] );
//                 case 1:
//                 return fcnObj( args[0] );
//                 case 0:
//                 default:
//                 return fcnObj();
//             }
	}
        
        log( strings.errorFunction );
	}
    
    /* Method: scanConstructor
    */
    function scanConstructor()
        {
        var ctor, args, ctorObj;
        scanWhiteSpace();
        
        inConstructor = true;
        ctor = scanPath();
        args = [];
        inConstructor = false;
        
        if( ch == "(" )
            {
            next();
            scanSeparators();
            
            while( ch != "" )
                {
                
                if( ch == ")" )
                    {
                    next();
                    break;
                    }
                
                args.push( scanValue() );
                scanSeparators();
                
                if( ch == "," )
                    {
                    next();
                    scanSeparators();
                    }
                }
            }
        
        if( !isReservedKeyword( ctor ) &&
            !isFutureReservedKeyword( ctor ) )
            {
            ctorObj = eval( "_global." + ctor );
            }
        else
            {
            var formatter = new vegas.string.StringFormatter(strings.notValidConstructor) ;
            log( formatter.format( ctor ) ) ;
            return config.undefineable;
            }
        
        if( config.security && !this.isAuthorized( ctor ) )
            {
            var formatter = new vegas.string.StringFormatter(strings.notAuthorizedConstructor) ;
            log( formatter.format( ctor ) ) ;
            return config.undefineable;
            }
//         else
//             {
//             trace( ctor + " is authorized (scanConstructor)" );
//             }
        
        if( ctorObj == undefined )
            {
            var formatter = new vegas.string.StringFormatter(strings.doesNotExist) ;
            log( formatter.format( ctor ) ) ;
            return config.undefineable;
            }
        else
            {
            switch( args.length )
                {
                case 9:
                return new ctorObj( args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8] );
                case 8:
                return new ctorObj( args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7] );
                case 7:
                return new ctorObj( args[0], args[1], args[2], args[3], args[4], args[5], args[6] );
                case 6:
                return new ctorObj( args[0], args[1], args[2], args[3], args[4], args[5] );
                case 5:
                return new ctorObj( args[0], args[1], args[2], args[3], args[4] );
                case 4:
                return new ctorObj( args[0], args[1], args[2], args[3] );
                case 3:
                return new ctorObj( args[0], args[1], args[2] );
                case 2:
                return new ctorObj( args[0], args[1] );
                case 1:
                return new ctorObj( args[0] );
                case 0:
                default:
                return new ctorObj();
                }
            }
        
        log( strings.errorConstructor );
        }
    
    /* Method: scanString
    */
    function scanString( quote:String ):String
        {
        var str = "";
        
        if( ch == quote )
            {
            while( next() )
                {
                switch( ch )
                {
                    
                    case quote:
                    	
                    	next() ;
                    	return str;
                    
                    case "\\":
                    	/* note:
                       		Escape Sequence
                       		\ followed by one of ' " \ b f n r t v
                       		or followed by x hexdigit hexdigit
                       		or followed by u hexdigit hexdigit hexdigit hexdigit
                       		see: ECMA-262 specs 7.8.4 (PDF p30 to p32/188)
                    	*/
                    
                    	switch( next() )
                    	{
                    		case "b": //backspace       - \u0008
                        		str += "\b";
	                        	break;
                        	
                        	case "t": //horizontal tab  - \u0009
	                        	str += "\t";
                        		break;
	                        
                        	case "n": //line feed       - \u000A
                        		str += "\n";
                        		break;
                        
	                       //TODO check \v bug 
	                       case "v" : //vertical tab    - \u000B
                        		
                        		//str += "\v";
                        		break;
                        
                        	case "f" : //form feed       - \u000C
                        		str += "\f";
                        		break;
                        
                       		 case "r": //carriage return - \u000D
                        		str += "\r";
                        		break;
                        
                        	case "\"": //double quote   - \u0022
                        		str += "\"";
                        		break;
                        
		                    case "\'": //single quote   - \u0027
                        		str += "\'";
                        		break;
                        
                        	case "\\": //backslash      - \u005c
                        		str += "\\";
                        		break;
                        
                        	case "u": //unicode escape sequence \uFFFF
                        		var ucode = source.substring( pos, pos+4 );
                        		str  += String.fromCharCode( parseInt( ucode, 16 ) );
                        		pos      += 4;
                        		break;
                        
	                        case "x": //hexadecimal escape sequence \xFF
                        		var xcode = source.substring( pos, pos+2 );
                        		str      += String.fromCharCode( parseInt( xcode, 16 ) );
                        		pos      += 2;
                        		break;
                        
                        	default:
                        		str += ch;
                        }
                    	break;
                    
                    default:
                    	
                    	if( !isLineTerminator( ch ) )
                        {
                        	str += ch;
                        }
                    	else
                        {
                        	log( strings.errorLineTerminator );
                        }
                    }
                
                }
            }
        
        log( strings.errorString );
        }
    
    /* Method: scanArray
    */
    function scanArray():Array
        {
        var arr = [];
        
        if( ch == "[" )
            {
            next();
            scanSeparators();
            
            if( ch == "]" )
                {
                next();
                return arr;
                }
            
            while( ch != "" )
                {
                arr.push( scanValue() );
                scanSeparators();
                
                if( ch == "]" )
                    {
                    next();
                    return arr;
                    }
                else if( ch != "," )
                    {
                    break;
                    }
                
                next();
                scanSeparators();
                }
            }
        
        log( strings.errorArray );
        }
    
    /* Method: scanObject
    */
    function scanObject():Object
        {
        var member, value, obj;
        obj = {};
        
        if( ch == "{" )
            {
            next();
            scanSeparators();
            
            if( ch == "}" )
                {
                next();
                return obj;
                }
            
            while( ch != "" )
                {
                member = scanIdentifier();
                scanWhiteSpace();
                //scanSeparators(); // FIXME : test scanSeparator to use return after a {
                
                if( ch != ":" )
                    {
                    break;
                    }
                
                next();
                inAssignement = true;
                value = scanValue();
                inAssignement = false;
                
                if( !isReservedKeyword( member ) &&
                    !isFutureReservedKeyword( member ) )
                    {
                    obj[member] = value;
                    }
                
                scanSeparators();
                
                if( ch == "}" )
                    {
                    next();
                    return obj;
                    }
                else if( ch != "," )
                    {
                    break;
                    }
                
                next();
                scanSeparators();
                }
            }
        
        log( strings.errorObject );
	}
    
	/**
	 * Scans all numbers in the source.
	 */
	public function scanNumber():Number
    {
    	var value, isSignedExp ;
    	var num:String  = "" ;
    	var oct:String  = "" ; 
    	var hex:String  = "" ;
    	var sign:String = "" ;

	    if( ch == "-" )
        {
        	sign = "-";
	        next();
        }

		if( ch == "0" )
		{
    	    next();
        
        	if( (ch == "x") || (ch == "X") )
        	{
            	next() ; 
				while( isHexDigit( ch ) )
            	{
					hex += ch;
					next() ;
				}
				if( hex == "" )
				{
					log( strings.malformedHexadecimal ) ;
					return NaN ;
				}
				else
				{
					return Number( sign + "0x" + hex );
				}	
			}
			else
			{
				num += "0";
			}
		}
    
    	while( isDigit( ch ) )
        {
        	num += ch;
        	next();
        }
    
    	if( ch == "." )
        {
			num += "." ;
        	next() ;
			while( isDigit( ch ) )
			{
				num += ch ;
				next() ;
			}
        }

    	if( ch == "e" )
        {
			num += "e" ;
			isSignedExp = next() ;
			if( (isSignedExp == "+") || (isSignedExp == "-") )
			{
				num += isSignedExp ;
				next() ;
            }
        	while( isDigit( ch ) )
            {
            	num += ch;
            	next();
			}
		}
    
		if( (num.charAt(0) == "0") && isOctalNumber( num ) )
		{
			value = parseInt( sign + num ) ;
		}
		else
		{
			value = Number( sign + num ) ;
		}
		
		if( !isFinite( value ) )
		{
			log( strings.errorNumber );
			return NaN;
		}
		else
		{
        	return value ;
        }
    
    }
 
    /**
     * Scan all assignements in the specified path.
     */
    public function scanAssignement( path:String )
	{
        var basescope, scope, obj, value;
        basescope = scope = this.scope ;
        if( path.indexOf( "." ) > -1 )
		{
			var objPath:Array = path.split( "." );
			var l:Number = objPath.length ;
			for( var i:Number = 0; i < l ; i++ )
			{
                path = objPath[i];
                if( i == objPath.length-1 )
				{
					break ;
				}
				if( scope[path] == undefined )
				{
					scope[path] = {} ;
				}
                scope = scope[path];
			}
		}
        scanWhiteSpace();
		if( ch == "=" )
		{
            inAssignement = true;
            next();
			scanWhiteSpace();
			if( isLineTerminator( ch ) )
			{
                return ;
			}
			
			value = scanValue();
			scope[path] = value;
            
			inAssignement = false;
		}
        
        this.scope = basescope;
	}
    
    /**
     * Insert bracket for number index.
     */
    public function _insertBracketForNumberIndex( path:String )
	{
		if( !config.arrayIndexAsBracket )
		{
			return path;
		}
    	    
		var paths = path.split( "." );
		var l:Number = paths.length ;
		for( var i:Number = 0 ; i < l ; i++ )
		{
			if( isDigitNumber( paths[i] ) )
			{
				paths[i] = "[" + paths[i] + "]" ;
			}
			else if( i != 0 )
			{
				paths[i] = "." + paths[i] ;
			}
		}
		
		return paths.join( "" ) ;
	}

    /**
     * Scan all external references in the specified path.
     */
	public function scanExternalReference( path:String )
	{
        var check, sign, target, valueTest;
        
		check = false;
		sign  = "";
		
		switch( path.charAt( 0 ) )
		{
			
            case "-" :
            {
            	sign = "-";
            	path = path.substr( 1 );
            	break;
            }
            
            case "+":
            {
            	path = path.substr( 1 );
            	break;
            }
		}
        
		check = doesExistInGlobal( path );
		
		if( check )
		{
			
			if( config.security && !isAuthorized( path ) )
			{
				var formatter = new vegas.string.StringFormatter(strings.notAuthorizedExternalReference) ;
				log( formatter.format( path ) ) ;
				return config.undefineable;
			}
//          else
//          {
//          	trace( path + " is authorized (scanExternalReference)" );
//          }
            
            path = this._insertBracketForNumberIndex( path );
            
            valueTest = eval( "_global." + path );
            
            if( valueTest != undefined )
                {
                if( config.copyObjectByValue && (typeof( valueTest ) == "object") )
                    {
                    valueTest = valueTest.copy();
                    }
                
                if( sign == "-" )
				{
					return -valueTest;
                }
				
            	return valueTest;
        	}
		}
		var formatter = new vegas.string.StringFormatter(strings.extRefDoesNotExist) ;
		log( formatter.format( path ) ) ;
		return config.undefineable;
	}
    
    /**
     * Scan all keywords in the source.
     */
    public function scanKeyword( pre:String )
	{
		if( pre == null )
		{
			pre = "" ;
		}
		
		var word, baseword;
		baseword = scanPath() ;
        if( inFunction )
		{
			inFunction = false;
			return baseword ;
		}
		
		word = pre + baseword;
        
		if( word == undefined )
		{
			return _ORC ;
		}
        
        switch( word )
		{
            
            case "" :
            case "_global" :
            case "undefined" :
            {
            	return config.undefineable;
            }
            
            // Null literal
            
            case "null" :
            {
            	return null;
            }
            
            // Boolean literals
            
            case "true" :
            {
            	return true ;
            }
            
            case "false":
            {
            	return false;
            }
            
            // Number literals
            
            case "NaN":
            {
            	return NaN;
            }
            
            case "new" :
            {
            	return scanConstructor() ;
            }
            
            default:
            {
            	var externalReference = config.undefineable;
				/* coded in the train listening RUN-DMC "It's Tricky" ;) */
            	if( !doesExistInGlobal( baseword ) )
				{
	                if( isValidPath( baseword ) )
                	{
	                    createPath( baseword );
                	}
                	else
                	{
	                    return config.undefineable;
            		}
            	}
            	else
				{            
	                externalReference = scanExternalReference( word );
                	
                	if( (externalReference != config.undefineable) && inAssignement )
                	{
	                    return externalReference;
            		}
            	}
	            
            	if( !inAssignement )
            	{
                	scanAssignement( baseword );
            	}
				    	
        		if( externalReference != config.undefineable )
            	{
                	return externalReference;
            	}
            	
            	return config.undefineable ; 
            }
    	}
        
		log( strings.errorKeyword );
	}
    
    /**
     * Scans all values.
     */
    public function scanValue()
	{
        
        // FIXME : use a clear white space before launch the deserialize ??
        scanSeparators(); // FIXME : i have change the scanWhite with a scanSeperators
        
        switch( ch )
        {
            
            case "{" :
            {
            	return scanObject();
            }
            
            case "[" :
            {
            	return scanArray();
            }
            
            case "\"" : case "\'" :
            {
            	return scanString( ch );
            }
            
            case "-" : case "+" :
            {
            	if( isDigit( source.charAt( pos+1 ) ) )
				{
	                return scanNumber();
				}
            	else
	            {
    	            var ch_ = ch;
        	        next();
            	    return scanKeyword( ch_ );
                }
            }
            
            default :
            {
            	return isDigit( ch ) ? scanNumber() : scanKeyword();
            }
        }
    
    }

	private var _ORC:String ;
	
}
