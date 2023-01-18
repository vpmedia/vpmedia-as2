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
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.core.HashCodeFactory;
import com.bourre.data.libs.GraphicLib;
import com.bourre.data.libs.GraphicLibLocator;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.OrphanGraphicLib 
	extends GraphicLib
{
	private var _sParentLocatorKey : String;
	private var _nDepth : Number;
	
	private static var _sROOTKEY : String = "root";
	private static var _bIS_ROOT_IS_INITIALIZED : Boolean = false;
	
	public function OrphanGraphicLib( parentLocatorKey : String, nDepth:Number, bAutoShow:Boolean ) 
	{
		super( null, nDepth, bAutoShow );
		
		_sParentLocatorKey =  ( parentLocatorKey.length>0 ) ? parentLocatorKey :  OrphanGraphicLib._sROOTKEY;
		_nDepth = nDepth;
	}
	
	// overwrite
	public function getContainer() : MovieClip
	{
		return null;
	}
	
	public function onLoadInit() : Void
	{
		super.onLoadInit();
	}
	
	private function _getContainer( mcTarget : MovieClip, depth : Number ) : MovieClip
	{
		if (mcTarget == undefined) 
		{
			PixlibDebug.FATAL( this + " MovieClip target is undefined." );
			return null;
		} else
		{
			return OrphanGraphicLib._getMovieClipContainer( mcTarget, depth );
		}
	}
	
	public function load( sURL: String ) : Void
	{
		if (!OrphanGraphicLib._bIS_ROOT_IS_INITIALIZED) setRootTarget();
		
		var mcTarget : MovieClip;
		if ( GraphicLibLocator.getInstance().isRegistered(_sParentLocatorKey) )
			mcTarget = GraphicLibLocator.getInstance().getGraphicLib( _sParentLocatorKey ).getView();
			
		_mcContainer = _getContainer( mcTarget, _nDepth );
		
		super.load( sURL );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	/*
	 * static methods
	 */
		public static function getRootLib() : GraphicLib
	{
		return GraphicLibLocator.getInstance().getGraphicLib( OrphanGraphicLib._sROOTKEY );
	}
	
	public static function setRootLib( gl : GraphicLib ) : Void
	{
		if (OrphanGraphicLib._bIS_ROOT_IS_INITIALIZED)
		{
			PixlibDebug.WARN( "You can't overwrite OrphanGraphicLib.ROOT property" );
		} else
		{
			GraphicLibLocator.getInstance().register( OrphanGraphicLib._sROOTKEY, gl );
			OrphanGraphicLib._bIS_ROOT_IS_INITIALIZED = true;
		}
	}
	
	public static function setRootTarget( mcTarget, depth : Number ) : Void
	{
		var gl : OrphanGraphicLib = new OrphanGraphicLib();
		var container : MovieClip = OrphanGraphicLib._getMovieClipContainer(mcTarget?mcTarget:_level0,depth?depth:0);
		gl.setContent( container.createEmptyMovieClip("__mc", 1) );
		setRootLib( gl );
	}
	
	private static function _getMovieClipContainer( mcTarget : MovieClip, depth : Number ) : MovieClip
	{
		var mc : MovieClip = mcTarget.createEmptyMovieClip("__c" + HashCodeFactory.getNextName(), (depth>=0)?depth:1);
		HashCodeFactory.getKey( mc );
		return mc;
	}
}