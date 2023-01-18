/*
* The contents of this file are subject to the Mozilla Public
* License Version 1.1 (the "License"); you may not use this
* file except in compliance with the License. You may obtain a
* copy of the License at http://www.mozilla.org/MPL/
* 
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
* or implied. See the License for the specific language
* governing rights and limitations under the License.
* 
* The Original Code is 'Movie Masher'. The Initial Developer
* of the Original Code is Doug Anarino. Portions created by
* Doug Anarino are Copyright (C) 2007 Syntropo.com, Inc. All
* Rights Reserved.
*/



/** This code appears on frame 1 of control/player.fla
*/
stop();

function initPlayer() 
{ 
	if (! app_mc)
	{
		var depth = 1 + getNextHighestDepth();
		attachMovie('FontManager', 'font_manager_mc', depth + 1);
		attachMovie('LoadManager', 'load_manager_mc', depth + 2);
		load_manager_mc._y = Stage.height * 2;
		font_manager_mc._y = Stage.height * 2;
		attachMovie('App', 'app_mc', depth);
		app_mc.setSize(Stage.width, Stage.height);
		app_mc.onResize = function() 
		{
			this.setSize(Stage.width, Stage.height);
		}
	}
}
initPlayer();

