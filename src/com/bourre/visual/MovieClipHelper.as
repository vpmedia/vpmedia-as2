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

import com.bourre.data.collections.Map;
import com.bourre.data.libs.GraphicLib;
import com.bourre.data.libs.GraphicLibLocator;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.Point;

class com.bourre.visual.MovieClipHelper 
{
	public var view : MovieClip;
	
	private static var _a : Map = new Map();
	
	private var _gl : GraphicLib;
	private var _sName:String;
	private var _oEB:EventBroadcaster;
	
	private function MovieClipHelper( name : String, mc : MovieClip ) 
	{
		_oEB = new EventBroadcaster( this );
		
		if (mc)
		{
			this.view = mc;
			
		} else
		{
			_gl = GraphicLibLocator.getInstance().getGraphicLib( name );
			if ( _gl )
			{
				this.view = _gl.getView();
			} else
			{
				PixlibDebug.ERROR( "Invalid arguments for " + this + " constructor." );
				return;
			}
		}
		
		_setName( name );
	}
	
	private function _getBroadcaster() : EventBroadcaster
	{
		return _oEB;
	}
	
	public function setVisible( b : Boolean ) : Void
	{
		if ( b )
		{
			show();
		} else
		{
			hide();
		}
	}
	
	public function show() : Void
	{
		if (_gl) 
		{
			_gl.show();
		} else 
		{
			view._visible = true;
		}
	}
	
	public function hide() : Void
	{
		if (_gl) 
		{
			_gl.hide();
		} else 
		{
			view._visible = false;
		}
	}
	
	public function move( x : Number, y : Number ) : Void
	{
		view._x = x;
		view._y = y;
	}
	
	public function getPosition() : Point
	{
		return new Point( view._x, view._y );
	}
	
	public function setSize( w : Number, h : Number ) : Void
	{
		view._width = w;
		view._height = h;
	}
	
	public function getSize() : Point
	{
		return new Point( view._width, view._height );
	}
	
	public function getName() : String
	{
		return _sName;
	}
	
	public function resolveUI ( label )
	{
		if ( view[ label ] )
		{
			return view[ label ];
			
		} else
		{
			PixlibDebug.ERROR( "Can't resolve '" + label + "' UI in " + this + ".view" );
		}
	}
	
	public function release() : Void
	{
		_getBroadcaster().removeAllListeners();
		MovieClipHelper._unregister( _sName );
		view.removeMovieClip();
		_gl.release();
		_sName = null;
	}
	
	public function addListener( oL ) : Void
	{
		_getBroadcaster().addListener(oL);
	}
	
	public function removeListener( oL ) : Void
	{
		_getBroadcaster().removeListener( oL );
	}
	
	public function addEventListener( e : EventType, oL, f : Function ) : Void
	{
		_getBroadcaster().addEventListener.apply( _getBroadcaster(), arguments );
	}
	
	public function removeEventListener( e : EventType, oL ) : Void
	{
		_getBroadcaster().removeEventListener( e, oL );
	}
	
	public function isVisible() : Boolean
	{
		if (_gl) 
		{
			return _gl.isVisible();
		} else 
		{
			return view._visible;
		}
	}
		
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	//
	public static function getMovieClipHelper( sName:String ) : MovieClipHelper
	{
		if (!MovieClipHelper._a.containsKey( sName ) ) 
		{
			PixlibDebug.ERROR( "Can't find MovieClipHelper instance with '" + sName + "' name." );
		}
		return _a.get( sName );
	}
	
	public static function isRegistered( sName:String ) : Boolean
	{
		return MovieClipHelper._a.containsKey( sName );
	}

	/*
	 * private methods
	 */
	private function _setName( name:String ) : Void
	{
		if ( MovieClipHelper._register( name, this ) ) _sName = name;
	}

	private static function _register( sName:String, oHelper:MovieClipHelper ) : Boolean
	{
		if ( MovieClipHelper._a.containsKey( sName ) )
		{
			PixlibDebug.ERROR( "MovieClipHelper instance is already registered with '" + sName + "' name." );
			return false;
		} else
		{
			MovieClipHelper._a.put( sName, oHelper );
			return true;
		}
	}
	
	private static function _unregister( sName:String ) : Void
	{
		MovieClipHelper._a.remove( sName );
	}
}