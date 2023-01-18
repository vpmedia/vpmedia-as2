/*
* parses the output from:
* http://staff.dasdeck.de/valentin/midi/mid2xml.php
* into valid GSequencer Data (absolute)
*/

class org.audiopackage.util.GMidiXML
{
	private var format: Number;
	private var TrackCount: Number;
	private var TicksPerBeat: Number;
	private var TimestampType: String;
	
	private var track: Array;
	
	var onLoad: Function;
	
	function GMidiXML()
	{
		track = new Array();
	}
	
	function loadXML( url: String ): Void
	{
		var o: GMidiXML = this;
		
		var xml: XML = new XML();
		
		xml.ignoreWhite = true;
		
		xml.onLoad = function()
		{
			o.parseXML( this );
		}
		
		xml.load( url );
	}
	
	function parseXML( xml: XML ): Void
	{
		var midiNode: XMLNode = xml.firstChild;
		
		var midiNodes = midiNode.childNodes;
		
		for( var n = 0 ; n < midiNodes.length ; n++ )
		{
			var node = midiNodes[n];
			
			var nodeName = node.nodeName;
			
			switch( nodeName )
			{
				case 'Format':
				
					format = parseInt( node.firstChild.nodeValue );
					break;
					
				case 'TrackCount':
				
					TrackCount = parseInt( node.firstChild.nodeValue );
					break;
					
				case 'TicksPerBeat':
				
					TicksPerBeat = parseInt( node.firstChild.nodeValue );
					break;
					
				case 'TimestampType':
				
					TimestampType = node.firstChild.nodeValue;
					break;
					
				case 'Track':
					parseTrackXML( node );
					break;
					
				default:
				
					trace( "invalid data found." );
				
			}			
		}
		
		onLoad();
	}
	
	function parseTrackXML( node ): Void
	{
		//-- OVERJUMP SONG SETTINGS --//
		if ( parseInt( node.attributes[ "Number" ] ) == 0 ) return;
		
		//var track: Object = Track[ parseInt( node.attributes[ "Number" ] ) ] = [];
		
		var eventNodes = node.childNodes;
		
		for ( var e = 0 ; e < eventNodes.length ; e++ )
		{
			var eventNode = eventNodes[e];
			
			var taskNodes = eventNode.childNodes;
			
			var time: Number;
			
			for ( var t = 0 ; t < taskNodes.length ; t++ )
			{
				var taskNode = taskNodes[t];
				
				var nodeName = taskNode.nodeName;
				
				if( nodeName == 'Absolute' )
				{
					time = parseInt( taskNode.firstChild.nodeValue );
				}
				else if ( nodeName == 'NoteOn' )
				{
					var note: Number = parseInt( taskNode.attributes[ 'Note'] );
					var vel: Number  = parseInt( taskNode.attributes[ 'Velocity'] );
					
					if ( track[ time ] == undefined ) track[ time ] = new Array();
					
					track[ time ].push( { note: note, vel: vel / 127 * 100 } );
				}
			}
		}
	}
	
	function getTrack(): Array
	{
		return track;
	}
}


























