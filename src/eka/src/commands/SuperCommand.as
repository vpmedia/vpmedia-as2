
/* ---------- interface SuperCommand 1.0.0

	Name : Command
	Package : eka.src.commands.Command
	Version : 1.0.0
	Date :  2004-12-21
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	THKS : Francis Bourre - www.tweenpix.net
	for Design Pattern Command concept
	
----------  */

import eka.src.commands.* ;

interface eka.src.commands.SuperCommand extends Command {
	
 	function addCommand(oC:Command):Void ;
  	
  	function removeCommand(oC:Command):Void ;

}
