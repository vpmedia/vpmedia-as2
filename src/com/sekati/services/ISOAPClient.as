/**
 * com.sekati.services.ISOAPClient
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreInterface;

/**
 * Interface describing {@link SOAPClient}.
 */
interface com.sekati.services.ISOAPClient extends CoreInterface {

	function connect(wsdl:String, port:String):Void;

	function call(method:String, args:Array):Void;
}