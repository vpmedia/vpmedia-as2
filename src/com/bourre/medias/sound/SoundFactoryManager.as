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

/**
 * {@code SoundFactoryManager} defines access point to a {@code unique} {@code SoundFactory} instance.
 * 
 * <p>Extends {@link SoundFactory} class and deploy {@code Singleton} design pattern.
 * 
 * <p>Take a look at {@link SoundFactory} to get example.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.PixlibStringifier;
import com.bourre.medias.sound.SoundFactory;

class com.bourre.medias.sound.SoundFactoryManager 
	extends SoundFactory
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private static var _oI:SoundFactoryManager;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns {@code SoundFactoryManager} instance.
	 * 
	 * <p>Always return same instance.
	 * 
	 * @return {@code SoundFactoryManager} instance
	 */
	public static function getInstance() : SoundFactoryManager
	{
		return (SoundFactoryManager._oI instanceof SoundFactoryManager) ? SoundFactoryManager._oI : SoundFactoryManager._buildInstance();
	}
	
	/**
	 * Clears and deletes {@code SoundFactoryManager} instance.
	 * 
	 * <p>Call {@link SoundFactory#clear} method to release 
	 * internal properties.
	 */
	public static function release() : Void
	{
		_oI.clear();
		delete _oI;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function SoundFactoryManager()
	{
		super();
	}
	
	private static function _buildInstance() : SoundFactoryManager
	{
		SoundFactoryManager._oI = new SoundFactoryManager();
		return _oI;
	}
	
}