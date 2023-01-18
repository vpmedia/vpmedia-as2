////////////////////////////////////////////////////////////////////////////////
//
// Ariaware RIA Platform (ARP)
// Copyright © 2004 Aral Balkan.
// Copyright © 2004 Ariaware Limited
// http://www.ariaware.com
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
// Project: ARP
// File: ArpForm.as
// Created by: Aral Balkan
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////

import mx.events.EventDispatcher;

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: ArpForm
//
// The base class that all forms should be based on. Provides simple event
// dispatching capabilities as well as methods for hiding or showing the form.
//
//
////////////////////////////////////////////////////////////////////////////////
class com.ariaware.arp.ArpForm extends MovieClip
{
	//
	// Properties
	//
	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function ArpForm()
	{
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Public methods
	////////////////////////////////////////////////////////////////////////////
	public function show()
	{
		_visible = true;		
	}
	
	public function hide() 
	{
		_visible = false;
	}
	
	function addEventListener()
	{
		// Used by EventDispather mixin
	}
	
	function removeEventListener()
	{
		// Used by EventDispather mixin
	}
	
	function dispatchEvent()
	{
		// Used by EventDispather mixin
	}
	
	function dispatchQueue()
	{
		// Used by EventDispather mixin
	}
}
