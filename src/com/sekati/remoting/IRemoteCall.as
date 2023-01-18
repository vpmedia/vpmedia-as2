/**
 * com.sekati.remoting.IRemoteCall
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreInterface;

/**
 * Interface describing {@link RemoteCall}. 
 */
interface com.sekati.remoting.IRemoteCall extends CoreInterface {

	public function call():Void;
}