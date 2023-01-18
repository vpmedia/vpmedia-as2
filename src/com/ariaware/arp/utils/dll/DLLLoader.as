////////////////////////////////////////////////////////////////////////////////
//
// ARP (http://openarp.org)
// DLL Loader class
// *Experimental*
// 
// Author: Aral Balkan
//
// Copyright:
// Copyright  2005 Aral Balkan. All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
//
// Released under the open-source MIT license.  
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////

import mx.events.EventDispatcher;
import com.ariaware.arp.utils.dll.DLLEvent;

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: DLLLoader
//
// The base class that all forms should be based on. Provides simple event
// dispatching capabilities as well as methods for hiding or showing the form.
//
//
////////////////////////////////////////////////////////////////////////////////
class com.ariaware.arp.utils.dll.DLLLoader extends MovieClip
{
	//
	// Group: Properties
	//
	
	// On Stage
	var deadPreview:TextField; 
	
	// Dynamically created clips
	var loaderShell:MovieClip = null;
	
	//
	// Group: Events broadcast
	//
	// Event: progress - On load progress (every frame)
	// Event: complete - When DLL has completely loaded
	// 
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Constructor
	//
	////////////////////////////////////////////////////////////////////////////
	public function DLLLoader ()
	{
		EventDispatcher.initialize ( this );
	}
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Public methods
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	//
	// Method: loadDll()
	//
	// Starts loading the specified DLL (SWF) file. A valid DLL file is a 
	// SWF file that contains AS2 classes.
	//
	////////////////////////////////////////////////////////////////////////////	
	public function loadDll ( dll:String )
	{
		// Create shell movie clip to load DLL into if it doesn't already exist
		if ( loaderShell == null )
		{
			loaderShell = createEmptyMovieClip ( "loaderShell", getNextHighestDepth());
		}
		
		// Load the movie
		loaderShell.loadMovie ( dll );
		
		// Start the preloader
		onEnterFrame = preloader;
	}
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Private methods
	//
	////////////////////////////////////////////////////////////////////////////

	private function onLoad ()
	{
		deadPreview._visible = false;
	}
	
	// Preloader method called every frame after DLL starts loading
	private function preloader ()
	{
		var bytesLoaded:Number = getBytesLoaded();
		var bytesTotal:Number = getBytesTotal();
		if ( bytesLoaded == bytesTotal && bytesLoaded > 10 )
		{
			// Ok, DLL has loaded -- wait a frame for it
			// to initialize so the classes become available.
			onEnterFrame = waitForInit;
		}
		else
		{
			dispatchEvent ( new DLLEvent ( "progress", bytesLoaded, bytesTotal ) );
		}
	}
	
	// DLL has initialized. Broadcast the complete event
	private function waitForInit ()
	{
		onEnterFrame = null;
		dispatchEvent ( new DLLEvent ( "complete", getBytesLoaded(), getBytesTotal() ) );		
	}
	
	//
	// Note: Methods to be mixed in by the EventDispatcher
	//
	function addEventListener(){};
	function removeEventListener(){};
	function dispatchEvent(){};
}