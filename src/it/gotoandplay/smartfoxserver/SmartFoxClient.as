import mx.utils.Delegate
import it.gotoandplay.smartfoxserver.*
import it.gotoandplay.smartfoxserver.http.*

/**
 * SmartFoxClient is the main class in the SmartFoxServer API.
 * This class is responsible for connecting to the server and handling all related events.
 * 
 * @usage	The following example show to instantiate the <b>SmartFoxClient</b> class and how to register an event handler.
 * 			<code>
 *			import it.gotoandplay.smartfoxserver.SmartFoxClient
 *			
 *			// Create instance
 *			var smartFox:SmartFoxClient = new SmartFoxClient()
 *			
 *			// Add event handler for connection 
 *			smartFox.onConnection = onConnectionHandler
 *			
 *			// Connect to server
 *			smartFox.connect("127.0.0.1", 9339)
 *					
 *			// Handle connection event
 *			function onConnectionHandler(success:Boolean):Void
 *			{
 *				if (success)
 *					trace("Connection successful")
 *				else
 *					trace("Connection failed")
 *			}
 * 			</code>
 * 			<b>NOTE</b>: in the following examples, {@code smartFox} always indicates a SmartFoxClient instance.
 * 
 * @version	1.5.8
 * 
 * @author	The gotoAndPlay() Team
 * 			{@link http://www.smartfoxserver.com}
 * 			{@link http://www.gotoandplay.it}
 *	
 */
class it.gotoandplay.smartfoxserver.SmartFoxClient extends XMLSocket
{
	// -------------------------------------------------------
	// Constants
	// -------------------------------------------------------
	
	private static var MIN_POLL_SPEED:Number = 0
	private static var DEFAULT_POLL_SPEED:Number = 750
	private static var MAX_POLL_SPEED:Number = 10000
	private static var HTTP_POLL_REQUEST:String = "poll"
	
	/**
	 * Moderator message type: "to user".
	 * The Moderator message is sent to a single user.
	 * 
	 * @see	#sendModeratorMessage
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public static var MODMSG_TO_USER:String = "u"
	
	/**
	 * Moderator message type: "to room".
	 * The Moderator message is sent to all the users in a room.
	 * 
	 * @see	#sendModeratorMessage
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public static var MODMSG_TO_ROOM:String = "r"
	
	/**
	 * Moderator message type: "to zone".
	 * The Moderator message is sent to all the users in a zone.
	 * 
	 * @see	#sendModeratorMessage
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public static var MODMSG_TO_ZONE:String = "z"
	
	/**
	 * Server-side extension request/response protocol: XML.
	 * 
	 * @see	#sendXtMessage
	 * @see #onExtensionResponse
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public static var PROTOCOL_XML:String = "xml"
	
	/**
	 * Server-side extension request/response protocol: String (aka "raw protocol").
	 * 
	 * @see	#sendXtMessage
	 * @see #onExtensionResponse
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public static var PROTOCOL_STR:String = "str"
	
	/**
	 * Server-side extension request/response protocol: JSON.
	 * 
	 * @see	#sendXtMessage
	 * @see #onExtensionResponse
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public static var PROTOCOL_JSON:String = "json"
	
	/**
	 * Connection mode: "disconnected".
	 * The client is currently disconnected from SmartFoxServer.
	 * 
	 * @see	#getConnectionMode
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public static var CONNECTION_MODE_DISCONNECTED:String = "disconnected"
	
	/**
	 * Connection mode: "socket".
	 * The client is currently connected to SmartFoxServer via socket.
	 * 
	 * @see	#getConnectionMode
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public static var CONNECTION_MODE_SOCKET:String = "socket"
	
	/**
	 * Connection mode: "http".
	 * The client is currently connected to SmartFoxServer via http.
	 * 
	 * @see	#getConnectionMode
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public static var CONNECTION_MODE_HTTP:String = "http"
	
	// -------------------------------------------------------
	// Properties
	// -------------------------------------------------------
	
	private var DEFAULT_CONFIG_FILE = "config.xml"
	private var DEFAULT_AUTO_CONNECT = true
	
	private var objRef:Object
	private var t1:Number, t2:Number
	private var isConnected:Boolean
	private var changingRoom:Boolean
	
	private var majVersion:Number = 1
	private var minVersion:Number = 5
	private var subVersion:Number = 8
	
	private var arrayTags:Object
	private var messageHandlers:Object
	private var os:it.gotoandplay.smartfoxserver.ObjectSerializer
	
	private var configLoader:XML 
	private var autoConnectOnConfigSuccess:Boolean = true
	
	/**
	 * The SmartFoxServer IP address.
	 * 
	 * @see	#connect
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var ipAddress:String
	
	/**
	 * The SmartFoxServer connection port.
	 * 
	 * @see	#connect
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var port:Number
	
	/**
	 * The default login zone.
	 * 
	 * @see	#loadConfig
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var defaultZone:String = ""
	
	/**
	 * The TCP port used by the embedded webserver.
	 * The default port is <b>8080</b>; if the webserver is listening on a different port number, this property should be set to that value.
	 * 
	 * @example	The following example shows how to retrieve the webserver's current http port.
	 * 			<code>
	 * 			trace("HTTP port is: " + smartfox.httpPort)
	 * 			</code>
	 * 
	 * @see		#uploadFile
	 * 
	 * @since	SmartFoxServer Pro v1.5.0
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var httpPort:Number = 8080
	
	/**
	 * The list of rooms in the current zone.
	 * Unlike the {@link #getRoomList} method, this property returns the list of {@link Room} objects already stored on the client, so no request is sent to the server.
	 * 
	 * @example	The following example shows how to iterate in the room list.
	 * 			<code>
	 * 			for (var r:String in smartFox.roomList)
	 * 			{
	 * 				var room:Room = smartFox.roomList[r]
	 * 				trace("Room: " + room.getName())
	 * 			}
	 * 			</code>
	 * 
	 * @see		#getRoomList
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var roomList:Object
	
	/**
	 * An array containing the objects representing each buddy of the user's buddy list.
	 * The buddy list can be iterated with a <i>for-in</i> loop, or a specific object can be retrieved by means of the {@link #getBuddyById} and {@link #getBuddyByName} methods.
	 * 
	 * <b>NOTE</b>: this property and all the buddy-related method are available only if the buddy list feature is enabled for the current zone. Check the SmartFoxServer server-side configuration.
	 * 
	 * Each element in the buddy list is an object with the following properties:
	 * @param	id:			(<b>Number</b>) the buddy id.
	 * @param	name:		(<b>String</b>) the buddy name.
	 * @param	isOnline:	(<b>Boolean</b>) the buddy online status: {@code true} if the buddy is online; {@code false} if the buddy is offline.
	 * @param	isBlocked:	(<b>Boolean</b>) the buddy block status: {@code true} if the buddy is blocked; {@code false} if the buddy is not blocked; when a buddy is blocked, SmartFoxServer does not deliver private messages from/to that user.
	 * @param	variables:	(<b>Object</b>) an object with extra properties of the buddy (Buddy Variables); see also {@link #setBuddyVariables}.
	 * 
	 * @example	The following example shows how to retrieve the properties of each buddy in the buddy list.
	 * 			<code>
	 * 			for (var b:String in smartFox.buddyList)
	 * 			{
	 * 				var buddy:Object = smartFox.buddyList[b]
	 * 				
	 * 				// Trace buddy properties
	 * 				trace("Buddy id: " + buddy.id)
	 * 				trace("Buddy name: " + buddy.name)
	 * 				trace("Is buddy online? " + buddy.isOnline ? "Yes" : "No")
	 * 				trace("Is buddy blocked? " + buddy.isBlocked ? "Yes" : "No")
	 * 				
	 * 				// Trace all Buddy Variables
	 * 				for (var v:String in buddy.variables)
	 * 					trace("\t" + v + " --> " + buddy.variables[v])
	 * 			}
	 * 			</code>
	 * 
	 * @see		#myBuddyVars
	 * @see		#loadBuddyList
	 * @see		#getBuddyById
	 * @see		#getBuddyByName
	 * @see		#removeBuddy
	 * @see		#setBuddyBlockStatus
	 * @see		#setBuddyVariables
	 * @see		#onBuddyList
	 * @see		#onBuddyListUpdate
	 * 
	 * @history	SmartFoxServer Pro v1.6.0 - Buddy's <i>isBlocked</i> property added.
	 * 
	 * @version	SmartFoxServer Basic (except block status) / Pro
	 */
	public var buddyList:Array
	
	/**
	 * The current user's Buddy Variables.
	 * This is an associative array containing the current user's properties when he/she is present in the buddy lists of other users.
	 * See the {@link #setBuddyVariables} method for more details.
	 * 
	 * @example	The following example shows how to read the current user's own Buddy Variables.
	 * 			<code>
	 * 			for (var v:String in smartFox.myBuddyVars)
	 * 				trace("Variable " + v + " --> " + smartFox.myBuddyVars[v])
	 * 			</code>
	 * 
	 * @see		#setBuddyVariables
	 * @see		#getBuddyById
	 * @see		#getBuddyByName
	 * @see		#onBuddyList
	 * @see		#onBuddyListUpdate
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var myBuddyVars:Array
	
	/**
	 * The property stores the id of the last room joined by the current user.
	 * In most multiuser applications users can join one room at a time: in this case this property represents the id of the current room.
	 * If multi-room join is allowed, the application should track the various id(s) in an array (for example) and this property should be ignored.
	 * 
	 * @example	The following example shows how to retrieve the current room object (as an alternative to the {@link #getActiveRoom} method).
	 * 			<code>
	 * 			var room:Room = smartFox.getRoom(smartFox.activeRoomId)
	 * 			trace("Current room is: " + room.getName())
	 * 			</code>
	 * 
	 * @see		#getActiveRoom
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var activeRoomId:Number
	
	/**
	 * The current user's SmartFoxServer id.
	 * The id is assigned to a user on the server-side as soon as the client connects to SmartFoxServer successfully.
	 * 
	 * <b>NOTE:</b> client-side, the <b>myUserId</b> property is available only after a successful login is performed using the default login procedure.
	 * If a custom login process is implemented, this property must be manually set after the successful login! If not, various client-side modules (SmartFoxBits, RedBox, etc.) may not work properly.
	 * 
	 * @example	The following example shows how to retrieve the user's own SmartFoxServer id.
	 * 			<code>
	 * 			trace("My user ID is: " + smartFox.myUserId)
	 * 			</code>
	 * 
	 * @see		#myUserName
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var myUserId:Number
	
	/**
	 * The current user's SmartFoxServer username.
	 * 
	 * <b>NOTE</b>: client-side, the <b>myUserName</b> property is available only after a successful login is performed using the default login procedure.
	 * If a custom login process is implemented, this property must be manually set after the successful login! If not, various client-side modules (SmartFoxBits, RedBox, etc.) may not work properly.
	 * 
	 * @example	The following example shows how to retrieve the user's own SmartFoxServer username.
	 * 			<code>
	 * 			trace("I logged in as: " + smartFox.myUserName)
	 * 			</code>
	 * 
	 * @see		#myUserId
	 * @see		#login
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var myUserName:String
	
	/**
	 * Toggle the client-side debugging informations.
	 * When turned on, the developer is able to inspect all server messages that are sent and received by the client in the Flash authoring environment.
	 * This allows a better debugging of the interaction with the server during application developement.
	 * 
	 * @example	The following example shows how to turn on SmartFoxServer API debugging.
	 * 			<code>
	 * 			var smartFox:SmartFoxClient = new SmartFoxClient()
	 * 			var runningLocally:Boolean = true
	 * 			
	 * 			var ip:String
	 * 			var port:Number
	 * 			
	 * 			if (runningLocally)
	 * 			{
	 * 				smartFox.debug = true
	 * 				ip = "127.0.0.1"
	 * 				port = 9339
	 * 			}
	 * 			else
	 * 			{
	 * 				smartFox.debug = false
	 * 				ip = "100.101.102.103"
	 * 				port = 9333
	 * 			}
	 * 			
	 * 			smartFox.connect(ip, port)
	 * 			</code>
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var debug:Boolean
	
	/**
	 * The current user's id as a player in a game room.
	 * The <b>playerId</b> is available only after the user successfully joined a game room. This id is 1-based (player 1, player 2, etc.), but if the user is a spectator or the room is not a game room, its value is -1.
	 * When a user joins a game room, a player id (or "slot") is assigned to him/her, based on the slots available in the room at the moment in which the user entered it; for example:
	 * <ul>
	 * 	<li>in a game room for 2 players, the first user who joins it becomes player one (playerId = 1) and the second user becomes player two (player = 2);</li>
	 * 	<li>in a game room for 4 players where only player three is missing, the next user who will join the room will be player three (playerId = 3);</li>
	 * </ul>
	 * 
	 * <b>NOTE</b>: if multi-room join is allowed, this property contains only the last player id assigned to the user, and so it's useless.
	 * In this case the {@link Room#getMyPlayerIndex} method should be used to retrieve the player id for each joined room.
	 * 
	 * @example	The following example shows how to retrieve the user's own player id.
	 * 			<code>
	 * 			trace("I'm player " + smartFox.playerId)
	 * 			</code>
	 * 
	 * @see		Room#getMyPlayerIndex
	 * @see		Room#isGame
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var playerId:Number
	
	/**
	 * A boolean flag indicating if the user is recognized as Moderator.
	 * 
	 * @example	The following example shows how to check if the current user is a Moderator in the current SmartFoxServer zone.
	 * 			<code>
	 * 			if (smartfox.amIModerator)
	 * 				trace("I'm a Moderator in this zone")
	 * 			else
	 * 				trace("I'm a standard user")
	 * 			</code>
	 * 
	 * @see		#sendModeratorMessage
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var amIModerator:Boolean
	
	/**
	 * Get/set the character used as separator for the String (raw) protocol.
	 * The default value is <b>%</b> (percentage character).
	 * 
	 * <b>NOTE</b>: this separator must match the one set in the SmartFoxServer server-side configuration file through the {@code <RawProtocolSeparator>} parameter.
	 * 
	 * @example	The following example shows how to set the raw protocol separator.
	 * 			<code>
	 * 			smartFox.rawProtocolSeparator = "|"
	 * 			</code>
	 * 
	 * @see		#PROTOCOL_STR
	 * @see		#sendXtMessage
	 * 
	 * @since	SmartFoxServer Pro v1.5.5
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var rawProtocolSeparator:String = "%"
	
	//--- BlueBox settings (start) ---------------------------------------------------------------------
	
	/**
	 * The BlueBox IP address.
	 * 
	 * @see	#smartConnect
	 * @see	#loadConfig
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var blueBoxIpAddress:String
	
	/**
	 * The BlueBox connection port.
	 * 
	 * @see	#smartConnect
	 * @see	#loadConfig
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var blueBoxPort:Number = 0
	
	/**
	 * A boolean flag indicating if the BlueBox http connection should be used in case a socket connection is not available.
	 * The default value is {@code true}.
	 * 
	 * @see	#loadConfig
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var smartConnect:Boolean = true

	/**
	 * The amount of milliseconds to wait before attempting a BlueBox connection.
	 * The default value is <b>5000</b> milliseconds.
	 * 
	 * @example	The following example shows how to set the socket connection timeout.
	 * 			<code>
	 * 			smartfox.socketConnectionTimeout = 2000
	 * 			</code>
	 * 
	 * @see	#smartConnect
	 * @see	#loadConfig
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var socketConnectionTimeout:Number = 5000
	
	
	private var isHttpMode:Boolean = false								// connection mode
	private var _httpPollSpeed:Number = DEFAULT_POLL_SPEED				// bbox poll speed
	private var httpConnection:HttpConnection							// http connection
	private var pollingThread:Number = -1								// pause thread
	private var pollingDelayFn:Function									// delay function type
	private var fpMajorVersion:Number									// player maj. version
	private var preConnection:Boolean = true							// pre-connection flag
	private var socketConnectionTimeoutThread:Number
	
	/**
	 * The minimum interval between two polling requests when connecting to SmartFoxServer via BlueBox module.
	 * The default value is 750 milliseconds. Accepted values are between 0 and 10000 milliseconds (10 seconds).
	 * 
	 * @usageNote	<i>Which is the optimal value for polling speed?</i>
	 * 				A value between 750-1000 ms is very good for chats, turn-based games and similar kind of applications. It adds minimum lag to the client responsiveness and it keeps the server CPU usage low.
	 * 				Lower values (200-500 ms) can be used where a faster responsiveness is necessary. For super fast real-time games values between 50 ms and 100 ms can be tried.
	 * 				With settings < 200 ms the CPU usage will grow significantly as the http connection and packet wrapping/unwrapping is more expensive than using a persistent connection.
	 * 				Using values below 50 ms is not recommended.
	 * 
	 * @example	The following example shows how to set the polling speed.
	 * 			<code>
	 * 			smartFox.httpPollSpeed = 200
	 * 			</code>
	 * 
	 * @see		#smartConnect
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function get httpPollSpeed():Number
	{
		return this._httpPollSpeed
	}
	
	public function set httpPollSpeed(sp:Number):Void
	{
		// Acceptable values: 0 <= sp <= 10sec
		if (sp >= MIN_POLL_SPEED && sp <= MAX_POLL_SPEED)
			this._httpPollSpeed = sp
	}	
		
	// -------------------------------------------------------
	// Event Handlers Methods
	// -------------------------------------------------------
	
	private var onConnect:Function
	
	/**
	 * Called when a response to the {@link #connect} request is received.
	 * The connection to SmartFoxServer may have succeeded or failed: the <i>success</i> parameter must be checked.
	 * 
	 * The following parameters are passed to this function.
	 * @param	success:	(<b>Boolean</b>) the connection result: {@code true} if the connection succeeded, {@code false} if the connection failed.
	 * 
	 * @example	The following example shows how to handle the connection result.
	 * 			<code>
	 * 			smartFox.onConnect = onConnectionHandler
	 *						
	 *			smartFox.connect("127.0.0.1", 9339)
	 *					
	 *			function onConnectionHandler(success:Boolean):Void
	 *			{
	 *				if (success)
	 *					trace("Connection successful")
	 *				else
	 *					trace("Connection failed")
	 *			}
	 * 			</code>
	 * 
	 * @see		#connect
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onConnection:Function
	
	/**
	 * Called when the connection with SmartFoxServer is closed (either from the client or from the server).
	 * 
	 * No parameters are provided.
	 * 
	 * @example	The following example shows how to handle a "connection lost" event.
	 * 			<code>
	 * 			smartFox.onConnectionLost = onConnectionLostHandler
	 * 			
	 * 			function onConnectionLostHandler():Void
	 * 			{
	 * 				trace("Connection lost!")
	 * 				
	 * 				// TODO: disable application interface
	 * 			}
	 * 			</code>
	 * 
	 * @see		#disconnect
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onConnectionLost:Function
	
	/**
	 * Called when an error occurs during the creation of a room.
	 * Usually this happens when a client tries to create a room but its name is already taken.
	 * 
	 * The following parameters are passed to this function.
	 * @param	error:	(<b>String</b>) the error message.
	 * 
	 * @example	The following example shows how to handle a potential error in room creation.
	 * 			<code>
	 * 			smartFox.onCreateRoomError = onCreateRoomErrorHandler
	 * 			
	 * 			var roomObj:Object = new Object()
	 * 			roomObj.name = "The Entrance"
	 * 			roomObj.maxUsers = 50
	 * 			
	 * 			smartFox.createRoom(roomObj)
	 * 			
	 * 			function onCreateRoomErrorHandler(error:String):Void
	 * 			{
	 * 				trace("Room creation error; the following error occurred: " + error)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#createRoom
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onCreateRoomError:Function
	
	/**
	 * Called when a room is joined successfully.
	 * 
	 * The following parameters are passed to this function.
	 * @param	room:	(<b>Room</b>) the {@link Room} object representing the joined room.
	 * 
	 * @example	The following example shows how to handle an successful room joining.
	 * 			<code>
	 * 			smartFox.onJoinRoom = onJoinRoomHandler
	 * 			
	 * 			smartFox.joinRoom("The Entrance")
	 * 			
	 * 			function onJoinRoomHandler(room:Room):Void
	 * 			{
	 * 				trace("Room " + room.getName() + " joined successfully")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onJoinRoomError
	 * @see		#joinRoom
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onJoinRoom:Function
	
	/**
	 * Called when an error occurs while joining a room.
	 * This error could happen, for example, if the user is trying to join a room which is currently full.
	 * 
	 * The following parameters are passed to this function.
	 * @param	error:	(<b>String</b>) the error message.
	 * 
	 * @example	The following example shows how to handle a potential error in room joining.
	 * 			<code>
	 * 			smartFox.onJoinRoomError = onJoinRoomErrorHandler
	 * 			
	 * 			smartFox.joinRoom("The Entrance")
	 * 			
	 * 			function onJoinRoomErrorHandler(error:String):Void
	 * 			{
	 * 				trace("Room join error; the following error occurred: " + error)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onJoinRoom
	 * @see		#joinRoom
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onJoinRoomError:Function
	
	/**
	 * Called when the login to a SmartFoxServer zone has been attempted.
	 * 
	 * The following parameters are passed to this function.
	 * @param	response:	(<b>Object</b>) an object containing the login result data.
	 * <hr />
	 * The <i>response</i> object contains the following properties:
	 * @param	success:	(<b>Boolean</b>) the login result: {@code true} if the login to the provided zone succeeded; {@code false} if login failed.
	 * @param	name:		(<b>String</b>) the user's actual username.
	 * @param	error:		(<b>String</b>) the error message in case of login failure.
	 * 
	 * <b>NOTE 1</b>: the server sends the username back to the client because not all usernames are valid: for example, those containing bad words may have been filtered during the login process.
	 * 
	 * <b>NOTE 2</b>: for SmartFoxServer PRO. If the Zone you are accessing uses a custom login the login-response will be sent from server side and you will need to handle it using the <b>onExtensionResponse</b> handler.
	 * Additionally you will need to manually set the myUserId and myUserName properties if you need them. (This is automagically done by the API when using a <em>default login</em>)
	 *
	 * @example	The following example shows how to handle the login result.
	 * 			<code>
	 * 			smartFox.onLogin = onLoginHandler
	 * 			
	 * 			smartFox.login("simpleChat", "jack")
	 * 			
	 * 			function onLoginHandler(response:Object):Void
	 * 			{
	 * 				if (response.success)
	 * 					trace("Successfully logged in as " + response.name)
	 * 				else
	 * 					trace("Zone login error; the following error occurred: " + response.error)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onLogout
	 * @see		#login
	 * @see		#onExtensionResponse
	 *
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onLogin:Function
	
	/**
	 * Called when the user logs out successfully.
	 * After a successful logout the user is still connected to the server, but he/she has to login again into a zone, in order to be able to interact with the server.
	 * 
	 * No parameters are provided.
	 * 
	 * @example	The following example shows how to handle the "logout" event.
	 * 			<code>
	 * 			smartFox.onLogout = onLogoutHandler
	 * 			
	 * 			smartFox.logout()
	 * 			
	 * 			function onLogoutHandler():Void
	 * 			{
	 * 				trace("Logged out successfully")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onLogin
	 * @see		#logout
	 * 
	 * @since	SmartFoxServer Pro v1.5.5
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onLogout:Function
	
	/**
	 * Called when an Actionscript object is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	obj:	(<b>Object</b>) the Actionscript object received.
	 * @param	sender:	(<b>User</b>) the {@link User} object representing the user that sent the Actionscript object.
	 * 
	 * @example	The following example shows how to handle an Actionscript object received from a user.
	 * 			<code>
	 * 			smartFox.onObjectReceived = onObjectReceivedHandler
	 * 			
	 * 			function onObjectReceivedHandler(obj:Object, sender:User):Void
	 * 			{
	 * 				// Assuming another client sent his X and Y positions in two properties called px, py
	 * 				trace("Data received from user: " + sender.getName())
	 * 				trace("X = " + obj.px + ", Y = " + obj.py)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#sendObject
	 * @see		#sendObjectToGroup
	 * @see		User
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onObjectReceived:Function
	
	/**
	 * Called when a public chat message is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	message:	(<b>String</b>) the public message received.
	 * @param	sender:		(<b>User</b>) the {@link User} object representing the user that sent the message.
	 * @param	roomId:		(<b>Number</b>) the id of the room where the sender is.
	 * 
	 * @example	The following example shows how to handle a public message.
	 * 			<code>
	 * 			smartFox.onPublicMessage = onPublicMessageHandler
	 * 			
	 * 			smartFox.sendPublicMessage("Hello world!")
	 * 			
	 * 			function onPublicMessageHandler(message:String, sender:User, roomId:Number):Void
	 * 			{
	 * 				trace("User " + sender.getName() + " said: " + message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onPrivateMessage
	 * @see		#sendPublicMessage
	 * @see		User
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onPublicMessage:Function
	
	/**
	 * Called when a private chat message is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	message:	(<b>String</b>) the private message received.
	 * @param	sender:		(<b>User</b>) the {@link User} object representing the user that sent the message; this property is undefined if the sender isn't in the same room of the recipient.
	 * @param	userId:		(<b>Number</b>) the user id of the sender (useful in case of private messages across different rooms, when the {@code sender} object is not available).
	 * @param	roomId:		(<b>Number</b>) the id of the room where the sender is.
	 * 
	 * @example	The following example shows how to handle a private message.
	 * 			<code>
	 * 			smartFox.onPrivateMessage = onPrivateMessageHandler
	 * 			
	 * 			smartFox.sendPrivateMessage("Hallo Jack!", 22)
	 * 			
	 * 			function onPrivateMessageHandler(message:String, sender:User, roomId:Number, userId:Number):Void
	 * 			{
	 * 				trace("User " + evt.params.sender.getName() + " sent the following private message: " + evt.params.message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onPublicMessage
	 * @see		#sendPrivateMessage
	 * @see		User
	 *
	 * @history	SmartFoxServer Pro v1.5.0 - <i>roomId</i> and <i>userId</i> parameters added.
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onPrivateMessage:Function
	
	/**
	 * Called when a message from the Administrator is received.
	 * Admin messages are special messages that can be sent by an Administrator to a user or group of users.
	 * All client applications should implement this handler, or users won't be be able to receive important admin notifications!
	 * 
	 * The following parameters are passed to this function.
	 * @param	message:	(<b>String</b>) the Administrator's message.
	 * 
	 * @example	The following example shows how to handle a message coming from the Administrator.
	 * 			<code>
	 * 			smartFox.onAdminMessage = onAdminMessageHandler
	 * 			
	 * 			function onAdminMessageHandler(message:String):Void
	 * 			{
	 * 				trace("Administrator said: " + message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onModeratorMessage
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onAdminMessage:Function
	
	/**
	 * Called when a message from a Moderator is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	message:	(<b>String</b>) the Moderator's message.
	 * @param	sender:		(<b>User</b>) the {@link User} object representing the Moderator.
	 * 
	 * @example	The following example shows how to handle a message coming from a Moderator.
	 * 			<code>
	 * 			smartFox.onModeratorMessage = onModeratorMessageHandler
	 * 			
	 * 			function onModeratorMessageHandler(message:String, sender:User):Void
	 * 			{
	 * 				trace("Moderator " + sender.getName() + " said: " + message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onAdminMessage
	 * @see		#sendModeratorMessage
	 * @see		User
	 * 
	 * @since	SmartFoxServer Pro v1.4.5
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onModeratorMessage:Function
	
	/**
	 * Called when a new room is created in the zone where the user is currently logged in.
	 * 
	 * The following parameters are passed to this function.
	 * @param	room:	(<b>Room</b>) the {@link Room} object representing the room that was created.
	 * 
	 * @example	The following example shows how to handle a new room being created in the zone.
	 * 			<code>
	 * 			smartFox.onRoomAdded = onRoomAddedHandler
	 * 			
	 * 			var roomObj:Object = new Object()
	 * 			roomObj.name = "The Entrance"
	 * 			roomObj.maxUsers = 50
	 * 			
	 * 			smartFox.createRoom(roomObj)
	 * 			
	 * 			function onRoomAddedHandler(room:Room):Void
	 * 			{
	 * 				trace("Room " + room.getName() + " was created")
	 * 				
	 * 				// TODO: update available rooms list in the application interface
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onRoomDeleted
	 * @see		#createRoom
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onRoomAdded:Function
	
	/**
	 * Called when a room is removed from the zone where the user is currently logged in.
	 * 
	 * The following parameters are passed to this function.
	 * @param	room:	(<b>Room</b>) the {@link Room} object representing the room that was removed.
	 * 
	 * @example	The following example shows how to handle a new room being removed in the zone.
	 * 			<code>
	 * 			smartFox.onRoomDeleted = onRoomDeletedHandler
	 * 			
	 * 			function onRoomDeletedHandler(room:Room):Void
	 * 			{
	 * 				trace("Room " + room.getName() + " was removed")
	 * 				
	 * 				// TODO: update available rooms list in the application interface
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onRoomAdded
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onRoomDeleted:Function
	
	/**
	 * Called when a room is left in multi-room mode, after a response to a {@link #leaveRoom} request is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	roomId:	(<b>Number</b>) the id of the room that was left.
	 * 
	 * @example	The following example shows how to handle the "room left" event.
	 * 			<code>
	 * 			smartFox.onRoomLeft = onRoomLeftHandler
	 * 			
	 * 			function onRoomLeftHandler(roomId:Number):Void
	 * 			{
	 * 				trace("You left room " + roomId)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#leaveRoom
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onRoomLeft:Function
	
	/**
	 * Called when the list of rooms available in the current zone is received.
	 * If the default login mechanism provided by SmartFoxServer is used, then this handler is called right after a successful login.
	 * This is because the SmartFoxServer API, internally, call the {@link #getRoomList} method after a successful login is performed.
	 * If a custom login handler is implemented, the room list must be manually requested to the server by calling the mentioned method.
	 * 
	 * The following parameters are passed to this function.
	 * @param	roomList:	(<b>Object</b>) an object containing all the {@link Room} objects for the zone logged in by the user.
	 * 
	 * @example	The following example shows how to handle the list of rooms sent by SmartFoxServer.
	 * 			<code>
	 * 			smartFox.onRoomListUpdate = onRoomListUpdateHandler
	 * 			
	 * 			smartFox.login("simpleChat", "jack")
	 * 			
	 * 			function onRoomListUpdateHandler(roomList:Object):Void
	 * 			{
	 * 				// Dump the names of the available rooms in the "simpleChat" zone
	 * 				for (var r:String in roomList)
	 * 					trace(roomList[r].getName())
	 * 			}
	 * 			</code>
	 * 
	 * @see		#roomList
	 * @see		#getRoomList
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onRoomListUpdate:Function
	
	/**
	 * Called when Room Variables are updated.
	 * A user receives this notification only from the room(s) where he/she is currently logged in. Also, only the variables that changed are transmitted.
	 * 
	 * The following parameters are passed to this function.
	 * @param	room:			(<b>Room</b>) the {@link Room} object representing the room where the update took place.
	 * @param	changedVars:	(<b>Array</b>) an associative array with the names of the changed variables as keys. The array can also be iterated through numeric indexes (0 to {@code changedVars.length}) to get the names of the variables that changed.
	 * <hr />
	 * <b>NOTE</b>: the {@code changedVars} array contains the names of the changed variables only, not the actual values. To retrieve them the {@link Room#getVariable} / {@link Room#getVariables} methods can be used.
	 * 
	 * @example	The following example shows how to handle an update in Room Variables.
	 * 			<code>
	 * 			smartFox.onRoomVariablesUpdate = onRoomVariablesUpdateHandler
	 * 			
	 * 			function onRoomVariablesUpdateHandler(room:Room, changedVars:Array):Void
	 * 			{
	 * 				// Iterate on the 'changedVars' array to check which variables were updated
	 * 				for (var v:String in changedVars)
	 * 					trace(v + " room variable was updated; new value is: " + room.getVariable(v))
	 * 			}
	 * 			</code>
	 * 
	 * @see		#setRoomVariables
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */	
	public var onRoomVariablesUpdate:Function
	
	/**
	 * Called when a response to the {@link #roundTripBench} request is received.
	 * The "roundtrip time" represents the number of milliseconds that it takes to a message to go from the client to the server and back to the client.
	 * A good way to measure the network lag is to send continuos requests (every 3 or 5 seconds) and then calculate the average roundtrip time on a fixed number of responses (i.e. the last 10 measurements).
	 * 
	 * The following parameters are passed to this function.
	 * @param	elapsed:	(<b>Number</b>) the roundtrip time.
	 * 
	 * @example	The following example shows how to check the average network lag time.
	 * 			<code>
	 * 			smartFox.onRoundTripResponse = onRoundTripResponseHandler
	 * 			
	 * 			var totalPingTime:Number = 0
	 * 			var pingCount:Number = 0
	 * 			
	 * 			smartFox.roundTripBench() // TODO: this method must be called repeatedly every 3-5 seconds to have a significant average value
	 * 			
	 * 			function onRoundTripResponseHandler(elapsed:Number):Void
	 * 			{
	 * 				// We assume that it takes the same time to the ping message to go from the client to the server
	 * 				// and from the server back to the client, so we divide the elapsed time by 2.
	 * 				totalPingTime += elapsed / 2
	 * 				pingCount++
	 * 				
	 * 				var avg:Number = Math.round(totalPingTime / pingCount)
	 * 				
	 * 				trace("Average lag: " + avg + " milliseconds")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#roundTripBench
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onRoundTripResponse:Function
	
	/**
	 * Called when the number of users and/or spectators changes in a room within the current zone.
	 * This event allows to keep track in realtime of the status of all the zone rooms in terms of users and spectators.
	 * In case many rooms are used and the zone handles a medium to high traffic, this notification can be turned off to reduce bandwidth consumption, since a message is broadcasted to all users in the zone each time a user enters or exits a room.
	 * 
	 * The following parameters are passed to this function.
	 * @param	room:	(<b>Room</b>) the {@link Room} object representing the room where the change occurred.
	 * 
	 * @example	The following example shows how to check the handle the spectator switch notification.
	 * 			<code>
	 * 			smartFox.onUserCountChange = onUserCountChangeHandler
	 * 			
	 * 			function onUserCountChangeHandler(room:Room):Void
	 * 			{
	 * 				// Assuming this is a game room
	 * 				
	 * 				var roomName:String = room.getName()
	 * 				var playersNum:Number = room.getUserCount()
	 * 				var spectatorsNum:Number = room.getSpectatorCount()
	 * 				
	 * 				trace("Room " + roomName + "has " + playersNum + " players and " + spectatorsNum + " spectators")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onUserEnterRoom
	 * @see		#onUserLeaveRoom
	 * @see		#createRoom
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onUserCountChange:Function
	
	/**
	 * Called when another user joins the current room.
	 * 
	 * The following parameters are passed to this function.
	 * @param	roomId:	(<b>Number</b>) the id of the room joined by a user (useful in case multi-room presence is allowed).
	 * @param	user:	(<b>User</b>) the {@link User} object representing the user that joined the room.
	 * 
	 * @example	The following example shows how to check the handle the user entering room notification.
	 * 			<code>
	 * 			smartFox.onUserEnterRoom = onUserEnterRoomHandler
	 * 			
	 * 			function onUserEnterRoomHandler(roomId:Number, user:User):Void
	 * 			{
	 * 				trace("User " + user.getName() + " entered the room")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onUserLeaveRoom
	 * @see		#onUserCountChange
	 * @see		User
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onUserEnterRoom:Function
	
	/**
	 * Called when a user leaves the current room.
	 * This handler is also called when a user gets disconnected from the server.
	 * 
	 * The following parameters are passed to this function.
	 * @param	roomId:		(<b>Number</b>) the id of the room left by a user (useful in case multi-room presence is allowed).
	 * @param	userId:		(<b>Number</b>) the id of the user that left the room (or got disconnected).
	 * @param	userName:	(<b>String</b>) the name of the user.
	 * 
	 * @example	The following example shows how to check the handle the user leaving room notification.
	 * 			<code>
	 * 			smartFox.onUserLeaveRoom = onUserLeaveRoomHandler
	 * 			
	 * 			function onUserLeaveRoomHandler(roomId:Number, userId:Number, userName:String):Void
	 * 			{
	 * 				trace("User " + userName + " left the room")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onUserEnterRoom
	 * @see		#onUserCountChange
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onUserLeaveRoom:Function
	
	/**
	 * Called when a user in the current room updates his/her User Variables.
	 * 
	 * The following parameters are passed to this function.
	 * @param	user:			(<b>User</b>) the {@link User} object representing the user who updated his/her variables.
	 * @param	changedVars:	(<b>Array</b>) an associative array with the names of the changed variables as keys. The array can also be iterated through numeric indexes (0 to {@code changedVars.length}) to get the names of the variables that changed.
	 * <hr />
	 * <b>NOTE</b>: the {@code changedVars} array contains the names of the changed variables only, not the actual values. To retrieve them the {@link User#getVariable} / {@link User#getVariables} methods can be used.
	 * 
	 * @example	The following example shows how to handle an update in User Variables.
	 * 			<code>
	 * 			smartFox.onUserVariablesUpdate = onUserVariablesUpdateHandler
	 * 			
	 * 			function onUserVariablesUpdateHandler(user:User, changedVars:Array):Void
	 * 			{
	 * 				// We assume that each user has px and py variables representing the users's avatar coordinates in a 2D environment
	 * 				
	 * 				if (changedVars["px"] != null || changedVars["py"] != null)
	 * 				{
	 * 					trace("User " + user.getName() + " moved to new coordinates:")
	 * 					trace("\t px: " + user.getVariable("px"))
	 * 					trace("\t py: " + user.getVariable("py"))
	 * 				}
	 * 			}
	 * 			</code>
	 * 
	 * @see		#setUserVariables
	 * @see		User
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public var onUserVariablesUpdate:Function
	
	/**
	 * Called when a command/response from a server-side extension is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	dataObj:	(<b>Object</b>) an object containing all the data sent by the server-side extension; by convention, a String property called <b>_cmd</b> should always be present, to distinguish between different responses coming from the same extension.
	 * @param	type:		(<b>String</b>) one of the following response protocol types: {@link #PROTOCOL_XML}, {@link #PROTOCOL_STR}, {@link #PROTOCOL_JSON}. By default {@link #PROTOCOL_XML} is used.
	 * 
	 * @example	The following example shows how to handle an extension response.
	 * 			<code>
	 * 			smartFox.onExtensionResponse = onExtensionResponseHandler
	 * 			
	 * 			function onExtensionResponseHandler(dataObj:Object, type:String):Void
	 * 			{
	 * 				var command:String = dataObj._cmd
	 * 				
	 * 				// Handle XML responses
	 * 				if (type == SmartFoxClient.PROTOCOL_XML)
	 * 				{
	 * 					// TODO: check command and perform required actions
	 * 				}
	 * 				
	 * 				// Handle RAW responses
	 * 				else if (type == SmartFoxClient.PROTOCOL_STR)
	 * 				{
	 * 					// TODO: check command and perform required actions
	 * 				}
	 * 				
	 * 				// Handle JSON responses
	 * 				else if (type == SmartFoxClient.PROTOCOL_JSON)
	 * 				{
	 * 					// TODO: check command and perform required actions
	 * 				}
	 * 			}
	 * 			</code>
	 * 
	 * @see		#PROTOCOL_XML
	 * @see		#PROTOCOL_STR
	 * @see		#PROTOCOL_JSON
	 * @see		#sendXtMessage
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var onExtensionResponse:Function
	
	/**
	 * Called when a response to the {@link #switchSpectator} request is received.
	 * The request to turn a spectator into a player may fail if another user did the same before your request, and there was only one player slot available.
	 * 
	 * The following parameters are passed to this function.
	 * @param	success:	(<b>Boolean</b>) the switch result: {@code true} if the spectator was turned into a player, otherwise {@code false}.
	 * @param	newId:		(<b>Number</b>) the player id assigned by the server to the user.
	 * @param	room:		(<b>Room</b>) the {@link Room} object representing the room where the switch occurred.
	 * 
	 * @example	The following example shows how to check the handle the spectator switch.
	 * 			<code>
	 * 			smartFox.onSpectatorSwitched = onSpectatorSwitchedHandler
	 * 			
	 * 			smartFox.switchSpectator()
	 * 			
	 * 			function onSpectatorSwitchedHandler(success:Boolean, newId:Number, room:Room):Void
	 * 			{
	 * 				if (success)
	 * 					trace("You have been turned into a player; your id is " + newId)
	 * 				else
	 * 					trace("The attempt to switch from spectator to player failed")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#switchSpectator
	 * @see		User#getPlayerId
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onSpectatorSwitched:Function
	
	/**
	 * Called in response to the {@link #switchPlayer} request.
	 * The request to turn a player into a spectator may fail if another user did the same before your request, and there was only one spectator slot available.
	 * 
	 * The following parameters are passed to this function.
	 * @param	success:	(<b>Boolean</b>) the switch result: {@code true} if the player was turned into a player, otherwise {@code false}.
	 * @param	newId:		(<b>int</b>) the player id assigned by the server to the user. (-1 when successful)
	 * @param	room:		(<b>Room</b>) the {@link Room} object representing the room where the switch occurred.
	 * 
	 * @example	The following example shows how to turn a player into a spectator.
	 * 			<code>
	 * 			smartFox.onPlayerSwitched = onPlayerSwitchedHandler
	 * 			
	 * 			smartFox.switchPlayer()
	 * 			
	 * 			function onPlayerSwitchedHandler(success:Boolean, newId:Number):Void
	 * 			{
	 * 				if (success)
	 * 					trace("You have been turned into a spectator; your id is: " + newId)
	 * 				else
	 * 					trace("The attempt to switch from player to spectator failed!")
	 * 			}
	 * 			</code>
	 *
	 * 
	 * @see		User#getPlayerId
	 * @see		Room
	 * @see		#switchPlayer
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var onPlayerSwitched:Function
	
	/**
	 * Called when the buddy list for the current user is received or a buddy is added/removed.
	 * 
	 * The following parameters are passed to this function.
	 * @param	list:	(<b>Array</b>) the buddy list. Refer to the {@link #buddyList} property for a description of the buddy object's properties.
	 * 
	 * @example	The following example shows how to retrieve the properties of each buddy when the buddy list is received.
	 * 			<code>
	 * 			smartFox.onBuddyList = onBuddyListHandler
	 * 			
	 * 			smartFox.loadBuddyList()		
	 * 
	 * 			function onBuddyListHandler(list:Array):Void
	 * 			{
	 * 				for (var b:String in list)
	 * 				{
	 * 					var buddy:Object = list[b]
	 * 					
	 * 					trace("Buddy id: " + buddy.id)
	 * 					trace("Buddy name: " + buddy.name)
	 * 					trace("Is buddy online? " + buddy.isOnline ? "Yes" : "No")
	 * 					trace("Is buddy blocked? " + buddy.isBlocked ? "Yes" : "No")
	 * 					
	 * 					trace("Buddy Variables:")
	 * 					for (var v:String in buddy.variables)
	 * 						trace("\t" + v + " --> " + buddy.variables[v])
	 * 				}
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onBuddyListError
	 * @see		#onBuddyListUpdate
	 * @see		#onBuddyRoom
	 * @see		#buddyList
	 * @see		#loadBuddyList
	 * @see		#addBuddy
	 * @see		#removeBuddy
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onBuddyList:Function
	
	/**
	 * Called when the status or variables of a buddy in the buddy list change.
	 * 
	 * The following parameters are passed to this function.
	 * @param	buddy:	(<b>Object</b>) an object representing the buddy whose status or Buddy Variables have changed. Refer to the {@link #buddyList} property for a description of the buddy object's properties.
	 * 
	 * @example	The following example shows how to handle the online status change of a buddy.
	 * 			<code>
	 * 			smartFox.onBuddyListUpdate = onBuddyListUpdateHandler
	 * 			
	 * 			function onBuddyListUpdateHandler(buddy:Object):Void
	 * 			{
	 * 				var name:String = buddy.name
	 * 				var status:String = (buddy.isOnline) ? "online" : "offline"
	 * 
	 * 				trace("Buddy " + name + " is currently " + status)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onBuddyList
	 * @see		#buddyList
	 * @see		#setBuddyBlockStatus
	 * @see		#setBuddyVariables
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onBuddyListUpdate:Function
	
	/**
	 * Called when an error occurs while loading the buddy list.
	 * 
	 * The following parameters are passed to this function.
	 * @param	error:	(<b>String</b>) the error message.
	 * 
	 * @example	The following example shows how to handle a potential error in buddy list loading.
	 * 			<code>
	 * 			smartFox.onBuddyListError = onBuddyListErrorHandler
	 * 			
	 * 			function onBuddyListErrorHandler(error:String):Void
	 * 			{
	 * 				trace("An error occurred while loading the buddy list: " + error)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onBuddyList
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onBuddyListError:Function
	
	/**
	 * Called when a response to a {@link #getBuddyRoom} request is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	idList:	(<b>Array</b>) the list of id of the rooms in which the buddy is currently logged; if users can't be present in more than one room at the same time, the list will contain one room id only, at 0 index.
	 * 
	 * @example	The following example shows how to join the same room in which the buddy currently is.
	 * 			<code>
	 * 			smartFox.onBuddyRoom = onBuddyRoomHandler
	 * 			
	 * 			var buddy:Object = smartFox.getBuddyByName("jack")
	 * 			smartFox.getBuddyRoom(buddy)
	 * 			
	 * 			function onBuddyRoomHandler(idList:Array):Void
	 * 			{
	 * 				// Reach the buddy in his room
	 * 				smartFox.join(idList[0])
	 * 			}
	 * 			</code>
	 * 
	 * @see		#getBuddyRoom
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public var onBuddyRoom:Function
	
	/**
	 * Called when the current user receives a request to be added to the buddy list of another user.
	 * 
	 * The following parameters are passed to this function.
	 * @param	sender:		(<b>String</b>) the name of the user requesting to add the current user to his/her buddy list.
	 * @param	message:	(<b>String</b>) a message accompaining the permission request. This message can't be sent from the client-side, but it's part of the advanced server-side buddy list features.
	 * 
	 * @example	The following example shows how to handle the request to be added to a buddy list.
	 * 			<code>
	 * 			smartFox.onBuddyPermissionRequest = onBuddyPermissionRequestHandler
	 * 			
	 * 			function onBuddyPermissionRequestHandler(sender:String, message:String):Void
	 * 			{
	 * 				// Display an alert attaching a movieclip from the Flash library
	 * 				var alert_mc:MovieClip = attachMovie("customAlertPanel", "customAlertPanel", 100)
	 * 				
	 * 				alert_mc.name_lb.text = sender
	 * 				alert_mc.message_lb.text = message
	 * 			}
	 * 			</code>
	 * 
	 * @see		#addBuddy
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var onBuddyPermissionRequest:Function
	
	/**
	 * Called when a response to a {@link #getRandomKey} request is received.
	 * 
	 * The following parameters are passed to this function.
	 * @param	key:	(<b>String</b>) a unique random key generated by the server.
	 * 
	 * @example	The following example shows how to handle the key received from the server.
	 * 			<code>
	 * 			smartFox.onRandomKey = onRandomKeyHandler
	 * 			
	 * 			smartFox.getRandomKey()
	 * 			
	 * 			function onRandomKeyHandler(key:String):Void
	 * 			{
	 * 				trace("Random key received from server: " + key)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#getRandomKey
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var onRandomKey:Function
	
	/**
	 * Called when an error occurs while loading the external SmartFoxClient configuration file.
	 * 
	 * The following parameters are passed to this function.
	 * @param	message:	(<b>String</b>) the error message.
	 * 
	 * @example	The following example shows how to handle a potential error in configuration loading.
	 * 			<code>
	 * 			smartFox.onConfigLoadFailure = onConfigLoadFailureHandler
	 * 			
	 * 			smartFox.loadConfig("testEnvironmentConfig.xml")
	 * 			
	 * 			function onConfigLoadFailureHandler(message:String):Void
	 * 			{
	 * 				trace("Failed loading config file: " + message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onConfigLoadSuccess
	 * @see		#loadConfig
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var onConfigLoadFailure:Function
	
	/**
	 * Called when the external SmartFoxClient configuration file has been loaded successfully.
	 * This handler is called only if the <i>autoConnect</i> parameter of the {@link #loadConfig} method is set to {@code false}; otherwise the connection is made and the {@link #onConnection} event fired.
	 * 
	 * No parameters are provided.
	 * 
	 * @example	The following example shows how to handle a successful configuration loading.
	 * 			<code>
	 * 			smartFox.onConfigLoadSuccess = onConfigLoadSuccessHandler
	 * 			
	 * 			smartFox.loadConfig("testEnvironmentConfig.xml", false)
	 * 			
	 * 			function onConfigLoadSuccessHandler():Void
	 * 			{
	 * 				trace("Config file loaded, now connecting...")
	 * 				
	 * 				smartFox.connect(smartFox.ipAddress, smartFox.port)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onConfigLoadFailure
	 * @see		#loadConfig
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public var onConfigLoadSuccess:Function
	
	
	// -------------------------------------------------------
	// Constructor
	// -------------------------------------------------------
	
	/**
	 * The SmartFoxClient contructor.
	 * 
	 * @param	objRef:	a custom parameter to keep a reference to a parent object (optional).
	 *
	 * @example	The following example shows how to instantiate the SmartFoxClient class.
	 * 			<code>
	 * 			var smartFox:SmartFoxServer = new SmartFoxServer()
	 * 			</code>
	 */
	function SmartFoxClient(objRef:Object)
	{
		super()
		
		// Object Reference:
		// optional param to keep a reference to a parent object
		this.objRef 		= objRef
		this.os 			= it.gotoandplay.smartfoxserver.ObjectSerializer.getInstance()
		this.isConnected 	= false
		this.debug 			= false
		
		// Initialize data
		initialize()
		
		// Array of tag names that should transformed in arrays by the messag2Object method
		this.arrayTags		= { uLs:true, rmList:true, vars:true, bList:true, vs:true, mv:true }
	
		// Message Handlers
		this.messageHandlers = new Object();
		
		// Initialize HttpConnection
		httpConnection = new HttpConnection(Delegate.create(this, handleHttpConnect), Delegate.create(this, handleHttpClose), Delegate.create(this, handleHttpData), Delegate.create(this, handleHttpError))
		
		// Override default XMLSocket methods
		onConnect 	= connectionEstablished
		onData  	= gotData
		onXML   	= xmlReceived
		onClose 	= connectionClosed
		
		// Setup polling delay method
		this.fpMajorVersion = getFpMajorVersion()
		
		if ( this.fpMajorVersion < 8 )
			this.pollingDelayFn = _global.setInterval
		else
			this.pollingDelayFn = _global.setTimeout
		
		setupMessageHandlers()		
	}
	
	// -------------------------------------------------------
	// Methods
	// -------------------------------------------------------
	
	/**
	 * Get the Flash Player major version.
	 */
	private function getFpMajorVersion():Number
	{
		var p = System.capabilities.version.indexOf( "," )
		return Number( System.capabilities.version.substr( p - 1, 1) )
	}
	
	/**
	 * Initialize properties and data structures.
	 */
	private function initialize(isLogout:Boolean):Void
	{
		if (isLogout == undefined)
			isLogout = false
			
		// RoomList
		this.roomList		= {}
		
		// BuddyList
		this.buddyList		= []
		this.myBuddyVars	= []
		
		// The currently active room
		this.activeRoomId	= -1
		this.myUserId		= null
		this.myUserName		= ""
		this.playerId		= null
		
		this.changingRoom	= false
		this.amIModerator	= false
		
		if(!isLogout)
		{
			this.isConnected = false
			this.isHttpMode	= false
			this.preConnection	= true
		}
	}
	
	/**
	 * Load a client configuration file.
	 * The SmartFoxClient instance can be configured through an external xml configuration file loaded at run-time.
	 * By default, the <b>loadConfig</b> method loads a file named "config.xml", placed in the same folder of the application swf file.
	 * If the <i>autoConnect</i> parameter is set to {@code true}, on loading completion the {@link #connect} method is automatically called by the API, otherwise the {@link #onConfigLoadSuccess} handler is called.
	 * In case of loading error, the {@link #onConfigLoadFailure} handler id called.
	 * 
	 * <b>NOTE</b>: the SmartFoxClient configuration file (client-side) should not be confused with the SmartFoxServer configuration file (server-side).
	 * 
	 * @usageNote	The external xml configuration file has the following structure; ip, port and zone parameters are mandatory, all other parameters are optional.
	 * 				<code>
	 * 				<SmartFoxClient>
	 * 					<ip>127.0.0.1</ip>
	 * 					<port>9339</port>
	 * 					<zone>simpleChat</zone>
	 * 					<debug>true</debug>
	 * 					<blueBoxIpAddress>127.0.0.1</blueBoxIpAddress>
	 * 					<blueBoxPort>9339</blueBoxPort>
	 * 					<smartConnect>true</smartConnect>
	 * 					<socketConnectionTimeout>5000</socketConnectionTimeout>
	 * 					<httpPort>8080</httpPort>
	 * 					<httpPollSpeed>750</httpPollSpeed>
	 * 					<rawProtocolSeparator>%</rawProtocolSeparator>
	 * 				</SmartFoxClient>
	 * 				</code>
	 * 
	 * @param	configFile:		external xml configuration file name (optional).
	 * @param	autoConnect:	a boolean flag indicating if the connection to SmartFoxServer must be attempted upon configuration loading completion (optional).
	 * 
	 * @return	Nothing. Causes the {@link #onConfigLoadSuccess} or {@link #onConfigLoadFailure} handlers to be called.
	 * 
	 * @sends	#onConfigLoadSuccess
	 * @sends	#onConfigLoadFailure
	 * 
	 * @example	The following example shows how to load an external configuration file.
	 * 			<code>
	 * 			smartFox.onConfigLoadSuccess = onConfigLoadSuccessHandler
	 * 			smartFox.onConfigLoadFailure = onConfigLoadFailureHandler
	 * 			
	 * 			smartFox.loadConfig("testEnvironmentConfig.xml", false)
	 * 			
	 * 			function onConfigLoadSuccessHandler():Void
	 * 			{
	 * 				trace("Config file loaded, now connecting...")
	 * 				smartFox.connect(smartFox.ipAddress, smartFox.port)
	 * 			}
	 * 			
	 * 			function onConfigLoadFailureHandler(message:String):Void
	 * 			{
	 * 				trace("Failed loading config file: " + message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#ipAddress
	 * @see		#port
	 * @see		#defaultZone
	 * @see		#debug
	 * @see		#blueBoxIpAddress
	 * @see		#blueBoxPort
	 * @see		#smartConnect
	 * @see		#socketConnectionTimeout
	 * @see		#httpPort
	 * @see		#httpPollSpeed
	 * @see		#rawProtocolSeparator
	 * @see		#onConfigLoadSuccess
	 * @see		#onConfigLoadFailure
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function loadConfig(configFile:String, autoConnect:Boolean):Void
	{
		if ( configFile == undefined )
			configFile = DEFAULT_CONFIG_FILE
			
		if ( autoConnect == undefined )
			autoConnectOnConfigSuccess = DEFAULT_AUTO_CONNECT
		else
			autoConnectOnConfigSuccess = autoConnect
			
		configLoader = new XML()
		configLoader.ignoreWhite = true
		configLoader.onLoad = Delegate.create( this, onConfigLoadSucceeded )
		
		// This breaks compatibility with Flash Player 7, requires v. 8+
		// configLoader.onHTTPStatus = Delegate.create( this, onConfigLoadFailed )
		
		configLoader.load( configFile )
	}
	
	private function onConfigLoadSucceeded(ok:Boolean):Void
	{
		if (!ok)
		{
			onConfigLoadFailure("Could not load config file!")
			return
		}
		
		var rootNode = configLoader.childNodes[0].childNodes
		
		for (var i = 0; i < rootNode.length; i++)
		{
			var node = rootNode[i]
			var nodeName = node.nodeName.toLowerCase()
			var nodeValue = node.firstChild.nodeValue
			
			if ( nodeName == "ip" )
				this.ipAddress = this.blueBoxIpAddress = nodeValue
				
			else if ( nodeName == "port" )
				this.port = Number( nodeValue )
				
			else if ( nodeName == "zone" )
				this.defaultZone = nodeValue
			
			else if ( nodeName == "smartconnect" )
				this.smartConnect = nodeValue == "true" ? true : false
			
			else if ( nodeName == "blueboxipaddress" )
				this.blueBoxIpAddress = nodeValue
				
			else if ( nodeName == "blueboxport" )
				this.blueBoxPort = nodeValue
				
			else if ( nodeName == "debug" )
				this.debug = nodeValue == "true" ? true : false
				
			else if ( nodeName == "httpport" )
				this.httpPort = Number( nodeValue )
				
			else if ( nodeName == "httppollspeed" )
				this.httpPollSpeed = Number( nodeValue )
				
			else if ( nodeName == "socketconnectiontimeout")
				this.socketConnectionTimeout = Number ( nodeValue )
				
			else if ( nodeName == "rawprotocolseparator" )
				this.rawProtocolSeparator = nodeValue		
		}
		
		if ( autoConnectOnConfigSuccess )
			this.connect( ipAddress, port )
		else
		{
			// Dispatch onConfigLoadSuccess event
			this.onConfigLoadSuccess()
		}	
	}
	
	private function onConfigLoadFailed( code:Number ) : Void
	{
		if ( code == 404 )
			this.onConfigLoadFailure("Could not find configuration file.")
		else
			this.onConfigLoadFailure("Could not load configuration file. Http status = " + code)
	}
	
	/**
	 * Get the SmartFoxServer Flash API version.
	 * 
	 * @return	The current version of the SmartFoxServer client API.
	 * 
	 * @example	The following example shows how to trace the SmartFoxServer API version.
	 * 			<code>
	 * 			trace("Current API version: " + smartFox.getVersion())
	 * 			</code>
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function getVersion():String
	{
		return this.majVersion + "." + this.minVersion + "." + this.subVersion
	}
	
	/**
	 * Get the connection status.
	 * 
	 * @return	A boolean flag indicating if the current user is connected to the server.
	 * 
	 * @example	The following example shows how to check the connection status.
	 * 			<code>
	 * 			trace("My connection status: " + (smartFox.connected() ? "connected" : "not connected"))
	 * 			</code>
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function connected():Boolean
	{
		return this.isConnected
	}
	
	/**
	 * Get the current connection mode.
	 * 
	 * @return	The current connection mode, expressed by one of the following constants: {@link #CONNECTION_MODE_DISCONNECTED} (disconnected), {@link #CONNECTION_MODE_SOCKET} (socket mode), {@link #CONNECTION_MODE_HTTP} (http mode).
	 * 
	 * @example	The following example shows how to check the current connection mode.
	 * 			<code>
	 * 			smartFox.onConnection = onConnectionHandler
	 *						
	 *			smartFox.connect("127.0.0.1", 9339)
	 *					
	 *			function onConnectionHandler(success:Boolean):Void
	 *			{
	 *				trace("Connection mode: " + smartFox.getConnectionMode())
	 *			}
	 * 			</code>
	 * 
	 * @see		#CONNECTION_MODE_DISCONNECTED
	 * @see		#CONNECTION_MODE_SOCKET
	 * @see		#CONNECTION_MODE_HTTP
	 * @see		#connect
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function getConnectionMode():String
	{
		var mode:String = CONNECTION_MODE_DISCONNECTED
		
		if ( this.isConnected )
		{
			if ( this.isHttpMode )
				mode = CONNECTION_MODE_HTTP
			else
				mode = CONNECTION_MODE_SOCKET
		}

		return mode
	}
	
	/**
	 * Setup the core message handlers.
	 */
	private function setupMessageHandlers():Void
	{
		addMessageHandler("sys", this.handleSysMessages)
		addMessageHandler("xt", this.handleExtensionMessages)
	}
	
	/**
	 * Add more MessageHanlders to the MessageHandler collection.
	 * All MessageHandlers object must implement a handleMessage() method.
	 */
	private function addMessageHandler(handlerId:String, handlerMethod:Function):Void
	{
		// Add the new handler only if it does not exist already
		if (this.messageHandlers[handlerId] == undefined)
		{
			this.messageHandlers[handlerId] = new Object()
			this.messageHandlers[handlerId].handleMessage = handlerMethod
		}
		else
		{
			trace("Warning: [" + handlerId + "] handler could not be created. A handler with this name already exist!")
		}
	}
	
	/**
	 * @exclude
	 */
	public function isModerator():Boolean
	{
		return this.amIModerator
	}
	
	/**
	 * System Messages Handler.
	 */
	private function handleSysMessages(xmlObj:Object, scope:Object):Void
	{
		// get "action" and "r" attributes
		var action:String		= xmlObj.attributes.action
		var fromRoom			= xmlObj.attributes.r

		
		// apiOK 
		if (action == "apiOK")
		{
			scope.isConnected = true
			scope.onConnection(true)
		}
		
		// apiKO => Bad API version
		else if (action == "apiKO")
		{
			scope.onConnection(false)
			trace("--------------------------------------------------------")
			trace(" WARNING! The API you are using are not compatible with ")
			trace(" the SmartFoxServer instance you're trying to connect to")
			trace("--------------------------------------------------------")
		}
		
		// logOK => login successfull
		else if (action == "logOK")
		{
			// store the uid that was assigned by the server
			scope.myUserId 	= xmlObj.login.attributes.id
			scope.myUserName = xmlObj.login.attributes.n
			scope.amIModerator = (xmlObj.login.attributes.mod == "0") ? false : true

			scope.onLogin({success:true, name:scope.myUserName, error:""})
	
			// autoget RoomList
			scope.getRoomList()
		}
		
		// logKO => login failed
		else if (action == "logKO")
		{
			var errorMsg = xmlObj.login.attributes.e
			scope.onLogin({success:false, name:"", error: errorMsg})
		}
		
		else if (action == "logout")
		{
			// Do the necessary cleanup
			scope.initialize(true)
			scope.onLogout()
			
		}
		
		// rmList => list of active rooms coming from server
		else if (action == "rmList")
		{
			var roomList = xmlObj.rmList.rmList
	
			// Pack data into a simpler format
			scope.roomList = new Array()
	
			for (var i in roomList)
			{
				// get ID for curr room
				var currRoomId = roomList[i].attributes.id
				
				// Grab Room Data
				var serverData = roomList[i].attributes
				
				var id 			= serverData.id
				var name 		= roomList[i].n.value
				var maxUsers 	= Number(serverData.maxu)
				var maxSpect	= Number(serverData.maxs)
				var isTemp 		= (serverData.temp) ? true : false
				var isGame 		= (serverData.game) ? true : false
				var isPrivate	= (serverData.priv) ? true : false
				var userCount	= Number(serverData.ucnt)
				var specCount	= Number(serverData.scnt)
				var isLimbo 	= (serverData.lmb) ? true : false
				
				scope.roomList[currRoomId] = new it.gotoandplay.smartfoxserver.Room(id, name, maxUsers, maxSpect, isTemp, isGame, isPrivate)
				scope.roomList[currRoomId].userCount = userCount
				scope.roomList[currRoomId].specCount = specCount
				
				// Set Limbo flag
				scope.roomList[currRoomId].setIsLimbo(isLimbo)
				
				// Point to the <vars></vars> node
				var roomVars = roomList[i].vars.vars
	
				// Generate Room Variables
				// Cycle through all variables in the XML
				// and recreate them in the room casting them to the right datatype
				for (var j = 0; j < roomVars.length; j++)
				{
					var vName = roomVars[j].attributes.n 
					var vType = roomVars[j].attributes.t
					var vVal  = roomVars[j].value
					
					// Dynamically cast the variable value to its original datatype
					var fn:Function
					
					if (vType == "b")
					{
						fn = Boolean
						vVal = Number(vVal)
					}
					else if (vType == "n")
						fn = Number
					else if (vType == "s")
						fn = String
					else if (vType== "x")
						fn = function(x) { return null; }
					
					scope.roomList[currRoomId].variables[vName] = fn(vVal)
					
				}
			}
	
			// Fire event
			scope.onRoomListUpdate(scope.roomList)
		}
		
		// joinOK => room joined succesfully
		else if (action == "joinOK")
		{
			var roomId 		= xmlObj.uLs.attributes.r
			var userList 	= xmlObj.uLs.uLs
			var rVars		= xmlObj.vars.vars

			//
			// Set as the activeRoom the last joined room
			// -------------------------------------------
			// NOTE:
			// Since multiple room join is allowed the app. developer
			// has to specify the room in which the action takes place 
			// if it is different from the activeRoomId
			//
			scope.activeRoomId = Number(roomId)
	
			// get current Room and populates usrList
			var currRoom	= scope.roomList[roomId]
	
			currRoom.userList = new Object()
			
			// Get the playerId
			// -1 = no game room
			scope.playerId = xmlObj.pid.attributes.id
			
			// Also set the myPlayerId in the room
			// for multi-room applications
			currRoom.setMyPlayerIndex(xmlObj.pid.attributes.id)
			
			// Populate roomVariables
			currRoom.variables = new Object()
			
			for (var j = 0; j < rVars.length; j++)
			{
				var vName = rVars[j].attributes.n 
				var vType = rVars[j].attributes.t
				var vVal  = rVars[j].value
				
				// Dynamically cast the variable value to its original datatype
				var fn:Function
				
				if (vType == "b")
				{
					fn = Boolean
					vVal = Number(vVal)
				}
				else if (vType == "n")
					fn = Number
				else if (vType == "s")
					fn = String
				else if (vType== "x")
					fn = function(x) { return null; }
				
				currRoom.variables[vName] = fn(vVal)
			}
			
			var uCount:Number = 0
			var	sCount:Number = 0
			
			// Populate Room userList
			for (var i = 0; i < userList.length; ++i)
			{
				// grab the user properties
				var usrName	= userList[i].n.value
				var usrId  	= userList[i].attributes.i
				var isMod 	= userList[i].attributes.m
				var isSpec 	= userList[i].attributes.s
				var pid		= userList[i].attributes.p
				
				// new user	
				var theUser:User = new it.gotoandplay.smartfoxserver.User(usrId, usrName)
				currRoom.userList[usrId] = theUser
				
				// set user Object (id, name ...)
				theUser["isMod"] = (isMod == "1") ? true : false
				theUser["isSpec"] = (isSpec == "1") ? true : false
				theUser["pid"] = (pid == undefined) ? -1 : pid 
				
				// keep user counts
				if (currRoom.isGame() && isSpec == "1")
					sCount++
				else
					uCount++
				
				// Point to the <vars></vars> node
				var userVars = userList[i].vars.vars
				
				// Setup user variables Object
				currRoom.userList[usrId].variables = {}
		
				// Cycle through all variables in the XML
				// and recreate them in the user casting them to the right datatype
				for (var j = 0; j < userVars.length; j++)
				{
					var vName = userVars[j].attributes.n 
					var vType = userVars[j].attributes.t
					var vVal  = userVars[j].value
					
					// Dynamically cast the variable value to its original datatype
					var fn:Function
					
					if (vType == "b")
					{
						fn = Boolean
						vVal = Number(vVal)
					}
					else if (vType == "n")
						fn = Number
					else if (vType == "s")
						fn = String
					else if (vType== "x")
						fn = function(x) { return null; }
					
					theUser["variables"][vName] = fn(vVal)
				}
			}
			
			// Update room count
			currRoom.userCount = uCount
			currRoom.specCount = sCount
			
			// operation completed, release lock
			scope.changingRoom = false
	
			// Fire event!
			// Return a Room obj (with its id and name)
			scope.onJoinRoom(scope.roomList[roomId])
		}
		
		// joinKO => A problem was found when trying to join a room
		else if (action == "joinKO")
		{
			scope.changingRoom = false
			var error = xmlObj.error.attributes.msg
			scope.onJoinRoomError(error)
		}
		
		// userEntersRoom => a new user has joined the room
		else if (action == "uER")
		{
			// Get user param
			var usrId 	= xmlObj.u.attributes.i
			var usrName = xmlObj.u.n.value
			var isMod 	= xmlObj.u.attributes.m
			var isSpec 	= xmlObj.u.attributes.s
			var pid 	= xmlObj.u.attributes.p
			
			// get current Room and populates usrList
			var currRoom	= scope.roomList[fromRoom]
			
			// add new client	
			var theUser:User = new it.gotoandplay.smartfoxserver.User(usrId, usrName)
			currRoom.userList[usrId] = theUser
			
			theUser["isMod"] = (isMod == "1") ? true : false
			theUser["isSpec"] = (isSpec == "1") ? true : false
			theUser["pid"] = (pid == undefined) ? -1 : pid
			
			// keep counts
			if (currRoom.isGame() && isSpec == "1")
				currRoom.specCount++
			else
				currRoom.userCount++
				
			
			// Point to the <vars></vars> node
			var userVars = xmlObj.u.vars.vars
			
			// Setup user variables Object
			currRoom.userList[usrId].variables = {}
	
			// Cycle through all variables in the XML
			// and recreate them in the user casting them to the right datatype
			for (var j = 0; j < userVars.length; j++)
			{
				var vName = userVars[j].attributes.n 
				var vType = userVars[j].attributes.t
				var vVal  = userVars[j].value
				
				// Dynamically cast the variable value to its original datatype
				var fn:Function
					
				if (vType == "b")
				{
					fn = Boolean
					vVal = Number(vVal)
				}
				else if (vType == "n")
					fn = Number
				else if (vType == "s")
					fn = String
				else if (vType== "x")
					fn = function(x) { return null; }
				
				theUser["variables"][vName] = fn(vVal)
			}
			
			scope.onUserEnterRoom(fromRoom, currRoom.userList[usrId])
		}
		
		// A user has left the room
		else if (action == "userGone")
		{
			//var roomId 	= xmlObj.user.attributes.r
			var usrId 		= xmlObj.user.attributes.id
			
			// get current Room
			var currRoom = scope.roomList[fromRoom]
			var usrName	= currRoom.userList[usrId].name
			var isSpec = currRoom.userList[usrId].isSpec
			
			// remove from the room user-list
			delete currRoom.userList[usrId]
				
			if (currRoom.isGame() && isSpec)
			{
				currRoom.specCount--
			}
			else
				currRoom.userCount--
			
			// Send name and id to the application
			// because the user entry in the UserList has already been deleted
			
			scope.onUserLeaveRoom(fromRoom, usrId, usrName)
		}
		
		// You have a new public message
		else if (action == "pubMsg")
		{
			// sender id
			var usrId 	= xmlObj.user.attributes.id
			var textMsg	= xmlObj.txt.value
			
			textMsg		= scope.os.decodeEntities(textMsg.toString())
	
			// fire event 
			scope.onPublicMessage(textMsg.toString(), scope.roomList[fromRoom].userList[usrId], fromRoom)
		}
		
		// You have a new private message
		else if (action == "prvMsg")
		{
			// sender id
			var usrId 	= xmlObj.user.attributes.id
			var textMsg	= xmlObj.txt.value
	
			textMsg		= scope.os.decodeEntities(textMsg)
	
			// fire event 
			scope.onPrivateMessage(textMsg.toString(), scope.roomList[fromRoom].userList[usrId], usrId, fromRoom)
		}
		
		// You have a new Admin message
		else if (action == "dmnMsg")
		{
			// sender id
			var usrId 	= xmlObj.user.attributes.id
			var textMsg	= xmlObj.txt.value
	
			textMsg		= scope.os.decodeEntities(textMsg)
	
			// fire event 
			scope.onAdminMessage(textMsg.toString(), scope.roomList[fromRoom].userList[usrId])
		}
		
		// You have a new Admin message
		else if (action == "modMsg")
		{
			// sender id
			var usrId 	= xmlObj.user.attributes.id
			var textMsg	= xmlObj.txt.value
	
			textMsg		= scope.os.decodeEntities(textMsg)
	
			// fire event 
			scope.onModeratorMessage(textMsg.toString(), scope.roomList[fromRoom].userList[usrId])
		}
		
		// You have a new AS Object
		else if (action == "dataObj")
		{
			var senderId 	= xmlObj.user.attributes.id
			var obj		= xmlObj.dataObj.value
	
			var asObj	= scope.os.deserialize(obj)

			scope.onObjectReceived(asObj, scope.roomList[fromRoom].userList[senderId])			
		}
		
		// A user has changed his/her variables
		else if (action == "uVarsUpdate")
		{
			var usrId 	= xmlObj.user.attributes.id
			var variables 	= xmlObj.vars.vars
	
			var user = scope.roomList[fromRoom].userList[usrId]
			
			if (user.variables == undefined)
				user.variables = {}
				
			// A List of var names that changed in the last update
			var changedVars:Array = []
			
			for (var j = 0; j < variables.length; j++)
			{
				var vName = variables[j].attributes.n 
				var vType = variables[j].attributes.t
				var vVal  = variables[j].value
				
				// Add the vName to the list of changed vars
				// The changed List is an array that can contains all the
				// var names changed with numeric indexes but also contains
				// the var names as keys for faster search
				changedVars.push(vName)
				changedVars[vName] = true
				
				// Dynamically cast the variable value to its original datatype
				if (vType == "x")
				{
					delete user.variables[vName]
				}
				else
				{
					var fn:Function
					
					if (vType == "b")
					{
						fn = Boolean
						vVal = Number(vVal)
					}
					else if (vType == "n")
						fn = Number
					else if (vType == "s")
						fn = String
						
					user.variables[vName] = fn(vVal)
				}
			}
			
			/*
			* Update other user copies (for multi-room only)
			*
			* Since 1.5.6 (Aug 2008)
			* Now the server does not send multiple updates for each rooms
			*/
			scope.globalUserVariableUpdate(user)
			
			// Fire event
			scope.onUserVariablesUpdate(user, changedVars)
		}
		
		// Notifies the roomVars update
		else if (action == "rVarsUpdate")
		{
			var variables 	= xmlObj.vars.vars
			
			var currRoom = scope.roomList[fromRoom]
			
			// A List of var names that changed in the last update
			var changedVars:Array = []
					
			if (currRoom.variables == undefined)
				currRoom.variables = new Object()
			
			for (var j = 0; j < variables.length; j++)
			{
				var vName = variables[j].attributes.n 
				var vType = variables[j].attributes.t
				var vVal  = variables[j].value
				
				// Add the vName to the list of changed vars
				// The changed List is an array that can contains all the
				// var names changed with numeric indexes but also contains
				// the var names as keys for faster search
				changedVars.push(vName)
				changedVars[vName] = true
				
				if (vType == "x")
				{
					delete currRoom.variables[vName]
				}
				else
				{
					// Dynamically cast the variable value to its original datatype
					var fn:Function
					
					if (vType == "b")
					{
						fn = Boolean
						vVal = Number(vVal)
					}
					else if (vType == "n")
						fn = Number
					else if (vType == "s")
						fn = String
	
					currRoom.variables[vName] = fn(vVal)
				}
			}
			
			scope.onRoomVariablesUpdate(currRoom, changedVars)
		}
		
		// Room Create Request Failed
		else if (action == "createRmKO")
		{
			var errorMsg = xmlObj.room.attributes.e
			scope.onCreateRoomError(errorMsg)
		}
		
		// Receive and update about the user number in the other rooms
		else if (action == "uCount")
		{
			var uCount = xmlObj.attributes.u
			var sCount = xmlObj.attributes.s
			var room = scope.roomList[fromRoom]
			
			room.userCount = Number(uCount)
			room.specCount = Number(sCount)
			scope.onUserCountChange(room)
		}
		
		// A dynamic room was created
		else if (action == "roomAdd")
		{
			var xmlRoom 	= xmlObj.rm.attributes
			
			var rmId	= xmlRoom.id
			var rmName 	= xmlObj.rm.name.value
			var rmMax	= Number(xmlRoom.max)
			var rmSpec	= Number(xmlRoom.spec)
			var isTemp	= (xmlRoom.temp) ? true : false
			var isGame	= (xmlRoom.game) ? true : false
			var isPriv	= (xmlRoom.priv) ? true : false
			var isLimbo = (xmlRoom.limbo) ? true : false
			
			var newRoom 	= new it.gotoandplay.smartfoxserver.Room(rmId, rmName, rmMax, rmSpec, isTemp, isGame, isPriv)
			
			// set limbo
			newRoom.setIsLimbo(isLimbo)
				
			scope.roomList[rmId] = newRoom
			
			var variables 	= xmlObj.rm.vars.vars

			// A List of var names that changed in the last update
			newRoom.variables = new Object()
			
			for (var j = 0; j < variables.length; j++)
			{
				var vName = variables[j].attributes.n 
				var vType = variables[j].attributes.t
				var vVal  = variables[j].value
	
				// Dynamically cast the variable value to its original datatype
				var fn:Function
					
				if (vType == "b")
				{
					fn = Boolean
					vVal = Number(vVal)
				}
				else if (vType == "n")
					fn = Number
				else if (vType == "s")
					fn = String
		
				newRoom.variables[vName] = fn(vVal)
	
			}
			
			scope.onRoomAdded(newRoom)
		}
		
		// A dynamic room was deleted
		else if (action == "roomDel")
		{
			var deletedId = xmlObj.rm.attributes.id
			
			var almostDeleted = scope.roomList[deletedId]
			
			delete scope.roomList[deletedId]
			
			scope.onRoomDeleted(almostDeleted)
			
		}
		
		// A room was left by the user
		// Used in multi-room mode
		else if (action == "leaveRoom")
		{
			var roomLeft = xmlObj.rm.attributes.id
			scope.onRoomLeft(roomLeft)
		}
		
		// RoundTrip response, for benchmark purposes only!
		else if (action == "roundTripRes")
		{
			scope.t2 = getTimer()
			scope.onRoundTripResponse(scope.t2 - scope.t1)
		}
		
		// Switch spectator response
		else if (action == "swSpec")
		{
			var playerId:Number = Number(xmlObj.pid.attributes.id)
			var userId:Number = Number(xmlObj.pid.attributes.u)
			
			// Update room count values
			if (playerId > 0)
			{
				scope.roomList[fromRoom].userCount++
				scope.roomList[fromRoom].specCount--
			}
			
			// update is done behind the scenes, no event fired
			if (!isNaN(userId))
			{
				var currRoom = scope.roomList[fromRoom]
				currRoom.userList[userId].pid = playerId
				currRoom.userList[userId].isSpec = false
			}
			
			// this is the response to my request, let's fire an event
			else
			{
				scope.playerId = playerId
				scope.onSpectatorSwitched((scope.playerId > 0), scope.playerId, scope.roomList[fromRoom])
			}
		}
		
		// Switch player response
		else if (action == "swPl")
		{
			var playerId:Number = Number(xmlObj.pid.attributes.id)
			var isItMe:Boolean = (xmlObj.pid.attributes.u == undefined)
			
			// Success
			if (playerId == -1)
			{
				scope.roomList[fromRoom].userCount--
				scope.roomList[fromRoom].specCount++
				
				if (!isItMe)
				{
					var userId:Number = Number(xmlObj.pid.attributes.u)
					var user:User = scope.roomList[fromRoom].userList[userId]
					
					if (user != undefined)
					{
						user.isSpec = true
						user.pid = playerId
					}
				}
			}
		
			// this is the response to my request, let's fire an event
			if (isItMe)
			{
				scope.playerId = playerId
				scope.onPlayerSwitched((playerId == -1), playerId, scope.roomList[fromRoom])
			}
		}
		
		// full buddyList update
		else if (action == "bList")
		{
			var bList = xmlObj.bList.bList
			
			if (bList == undefined)
			{
				scope.onBuddyListError(xmlObj.err.value)
				return
			}
			
			// Get my buddy variables
			var myVars = xmlObj.mv.mv
			if (myVars != undefined)
			{
				for (var it:String in myVars)
				{
					var _vn = myVars[it].attributes.n
					var _vv = myVars[it].value
					scope.myBuddyVars[_vn] = _vv
				}
			}
			
			for (var i = 0; i < bList.length; i++)
			{
				var buddy = {}
				
				buddy.isOnline 	= (bList[i].attributes.s == "1") ? true : false
				buddy.name 	= bList[i].n.value
				buddy.id	= bList[i].attributes.i
				buddy.isBlocked = (bList[i].attributes.x == "1") ? true : false
				buddy.variables = {}
			
				var bVars = bList[i]["vs"].vs
				
				// Check buddy vars
				for (var j in bVars)
				{
					var vN:String = bVars[j].attributes.n
					var vV:String = bVars[j].value
					
					buddy.variables[vN] = vV
				}
				
				scope.buddyList.push(buddy)
			}
			
			scope.onBuddyList(scope.buddyList)
		}
		
		// buddyList update
		else if (action == "bUpd")
		{
			var found:Boolean = false
			var b = xmlObj.b
			
			if (b == undefined)
			{
				scope.onBuddyListError(xmlObj.err.value)
				return
			}
			
			var buddy = {}
			buddy.name = b["n"].value
			buddy.id = b.attributes.i
			buddy.isOnline = (b.attributes.s == "1") ? true : false
			buddy.isBlocked = (b.attributes.x == "1") ? true : false
			
			var bVars = b["vs"].vs
			var tempB:Object = null
			
			for (var it:String in scope.buddyList)
			{
				tempB = scope.buddyList[it]
				
				if (tempB.name == buddy.name)
				{
					// swap objects
					scope.buddyList[it] = buddy
					buddy.isBlocked = tempB.isBlocked
					buddy.variables = tempB.variables
					
					// add/modify variables
					for (var i:String in bVars)
					{
						var vN:String = bVars[i].attributes.n
						var vV:String = bVars[i].value

						buddy.variables[vN] = vV
					}
					
					found = true
					break
				}
			}
			
			if (found)
				scope.onBuddyListUpdate(buddy)
		}
		
		// buddyList Add ::HIDDEN::
		else if (action == "bAdd")
		{
			var b = xmlObj.b
			
			var buddy = {}
			buddy.name = b.n.value
			buddy.id = b.attributes.i
			buddy.isOnline = (b.attributes.s == "1") ? true : false
			buddy.isBlocked = (b.attributes.x == "1") ? true : false
			buddy.variables = {}
			
			var bVars = b["vs"].vs
			
			// Check buddy vars
			for (var i in bVars)
			{
				var vN:String = bVars[i].attributes.n
				var vV:String = bVars[i].value
				
				buddy.variables[vN] = vV
			}
			
			scope.buddyList.push(buddy)
			
			// Fire event
			scope.onBuddyList(scope.buddyList)
		}
		
		else if (action == "remB")
		{
			var buddyName:String = xmlObj.n.value
			var buddy:Object = null
				
			for (var it:String in scope.buddyList)
			{
				buddy = scope.buddyList[it]
				
				if (buddy.name == buddyName)
				{
					delete scope.buddyList[it]
					scope.onBuddyList(scope.buddyList)
			
					break
				}
			}
		}
		
		else if (action == "bPrm")
		{
			var sender:String = xmlObj.n.value
			var message:String = ""
			
			if (xmlObj.txt != undefined)
				message = scope.os.decodeEntities( message )
				
			scope.onBuddyPermissionRequest(sender, message)
		}
		
		// buddyList update
		else if (action == "roomB")
		{
			var roomIds = xmlObj.br.attributes.r
			
			var ids = roomIds.toString().split(",")
			
			for (var i in ids)
				ids[i] = Number(ids[i])
				
			scope.onBuddyRoom(ids)
		}
		
		// handle the randomKey reception
		else if (action == "rndK")
		{
			var key:String = xmlObj.k.value
			scope.onRandomKey(key)
		}
	}
	
	/**
	 * Extension Messages Handler.
	 * By default if type is omitted then >>> type = "xml".
	 */
	private function handleExtensionMessages(dataObj:Object, scope:Object, type:String):Void
	{
		if (type == undefined)
			type = "xml"
		
		// Handle and XML formatted object
		if (type == "xml")
		{
			// get "action" and "r" attributes
			var action   = dataObj.attributes.action
			var fromRoom = dataObj.attributes.r
			
			if (action == "xtRes")
			{
				//var senderId 		= dataObj.user.attributes.id
				//var obj			= dataObj.dataObj.value
				
				var obj				= dataObj.value
				var asObj:Object	= scope.os.deserialize(obj)

				scope.onExtensionResponse(asObj, type)	
			}
		}
		
		// Handle string formatted message
		else if (type == "str")
		{
			scope.onExtensionResponse(dataObj, type)
		}
		
		// Handle json message
		else if (type == "json")
		{
			scope.onExtensionResponse(dataObj.o, type)
		}
	}
	
	/**
	 * Send a request to a server side extension.
	 * The request can be serialized using three different protocols: XML, JSON and String-based (aka "raw protocol"). 
	 * XML and JSON can both serialize complex objects with any level of nested properties, while the String protocol allows to send linear data delimited by a separator (see the {@link #rawProtocolSeparator} property).
	 * 
	 * <b>NOTE</b>: the use JSON instead of XML is highly recommended, as it can save a lot of bandwidth. The String-based protocol can be very useful for realtime applications/games where reducing the amount of data is the highest priority.
	 * 
	 * @param	xtName:		the name of the extension (see also the {@link #createRoom} method).
	 * @param	cmdName:	the name of the action/command to execute in the extension.
	 * @param	paramObj:	an object containing the data to be passed to the extension (set to empty object if no data is required).
	 * @param	type:		the protocol to be used for serialization (optional, default value: {@link #PROTOCOL_XML}). The following constants can be passed: {@link #PROTOCOL_XML}, {@link #PROTOCOL_STR}, {@link #PROTOCOL_JSON}.
	 * @param	roomId:		the id of the room where the request was originated, in case of multi-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. May cause the {@link #onExtensionResponse} handler to be called in response (depending on the extension implementation).
	 * 
	 * @example	The following example shows how to notify a multiplayer game server-side extension that a game action occurred.
	 * 			<code>
	 * 			// A bullet is being fired
	 * 			var params:Object = {}
	 * 			params.type = "bullet"
	 * 			params.posx = 100
	 * 			params.posy = 200
	 * 			params.speed = 10
	 * 			params.angle = 45
	 * 			
	 * 			// Invoke "fire" command on the extension called "gameExt", using JSON protocol
	 * 			smartFox.sendXtMessage("gameExt", "fire", params, SmartFoxClient.PROTOCOL_JSON)
	 * 			</code>
	 * 
	 * @see		#rawProtocolSeparator
	 * @see		#PROTOCOL_XML
	 * @see		#PROTOCOL_JSON
	 * @see		#PROTOCOL_STR
	 * @see		#onExtensionResponse
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function sendXtMessage(xtName:String, cmdName:String, paramObj, type:String, roomId:Number):Void
	{
		if ( !checkRoomList() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
			
		// XML is default
		if (type == undefined)
			type = "xml"
			
		
		if (type == "xml")
		{
			var header:Object
			
			header 	= {t:"xt"}
			
			// Encapsulate message
			var xtReq:Object = {name: xtName, cmd: cmdName, param: paramObj}
			//var xmlmsg:String= "<dataObj><![CDATA[" + os.serialize(xtReq) + "]]></dataObj>"
			var xmlmsg:String= "<![CDATA[" + os.serialize(xtReq) + "]]>"
			
			this.send(header, "xtReq", roomId, xmlmsg)
		}
		
		else if (type == "str")
		{
			var hdr:String
			
			hdr = rawProtocolSeparator + "xt" + rawProtocolSeparator + xtName + rawProtocolSeparator + cmdName + rawProtocolSeparator + roomId + rawProtocolSeparator
			
			for (var i:Number = 0; i < paramObj.length; i++)
				hdr += paramObj[i].toString() + rawProtocolSeparator

			this.sendString(hdr)
		}
		
		else if (type == "json")
		{
			var body:Object = {}
			body.x = xtName
			body.c = cmdName
			body.r = roomId
			body.p = paramObj
			
			var obj:Object = {}
			obj.t = "xt"
			obj.b = body
			
			try 
			{
				var msg:String = it.gotoandplay.smartfoxserver.JSON.stringify(obj)
				this.sendJson(msg)
			} 
			catch(ex) 
			{
				if (this.debug)
				{
					trace("Error in sending JSON message.")
					trace(ex.name + " : " + ex.message + " : " + ex.at + " : " + ex.text)
				}
			}
		}
	}
	
	/**
	 * Debug ONLY.
	 * 
	 * @exclude
	 */
	public function dumpObj(obj:Object, depth:Number):Void
	{
		if (depth == undefined)
			depth = 0

		if (this.debug)
		{
			if (depth == 0)
			{
				trace("+-----------------------------------------------+")
				trace("+ Object Dump                                   +")
				trace("+-----------------------------------------------+")
			}
			
			for (var key in obj)
			{
				var item = obj[key]
				var typ = typeof(item)
				
				if (typ != "object")
				{
					var msg = ""
					for (var i = 0; i < depth; i++)
						msg += "\t"
					
					msg += key + " : " + item + " ( " + typ + " )"
					trace(msg)
				}
				else
					dumpObj(item, depth + 1)
			}
			
		}
	}
	
	/**
	 * Perform the default login procedure.
	 * The standard SmartFoxServer login procedure accepts guest users. If a user logs in with an empty username, the server automatically creates a name for the client using the format <i>guest_n</i>, where <i>n</i> is a progressive number.
	 * Also, the provided username and password are checked against the moderators list (see the SmartFoxServer server-side configuration) and if a user matches it, he is set as a Moderator.
	 * 
	 * <b>NOTE 1</b>: duplicate names in the same zone are not allowed.
	 * 
	 * <b>NOTE 2</b>: for SmartFoxServer Basic, where a server-side custom login procedure can't be implemented due to the lack of <i>extensions</i> support, a custom client-side procedure can be used, for example to check usernames against a database using a php/asp page.
	 * In this case, this should be done BEFORE calling the <b>login</b> method. This way, once the client is validated, the stadard login procedure can be used.
	 * 
	 * <b>NOTE 3</b>: for SmartFoxServer PRO. If the Zone you are accessing uses a custom login the login-response will be sent from server side and you will need to handle it using the <b>onExtensionResponse</b> handler.
	 * Additionally you will need to manually set the myUserId and myUserName properties if you need them. (This is automagically done by the API when using a <em>default login</em>)
	 * 
	 * @param	zone:	the name of the zone to log into.
	 * @param	name:	the user name.
	 * @param	pass:	the user password.
	 * 
	 * @return	Nothing. Causes the {@link #onLogin} handler to be called in response.
	 * 
	 * @example	The following example shows how to login into a zone.
	 * 			<code>
	 * 			smartFox.onLogin = onLoginHandler
	 * 			
	 * 			smartFox.login("simpleChat", "jack")
	 * 			
	 * 			function onLoginHandler(response:Object):Void
	 * 			{
	 * 				if (response.success)
	 * 					trace("Successfully logged in as " + response.name)
	 * 				else
	 * 					trace("Zone login error; the following error occurred: " + response.error)
	 * 			}
	 * 			</code>
	 * 
	 * @see 	#logout
	 * @see		#onLogin
	 * @see		#onExtensionResponse
	 *
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function login(zone:String, name:String, pass:String):Void
	{
		var header 	= {t:"sys"}
		var message 	= "<login z='" + zone + "'><nick><![CDATA[" + name + "]]></nick><pword><![CDATA[" + pass + "]]></pword></login>"

		this.send(header, "login", 0, message)
	}
	
	/**
	 * Log the user out of the current zone.
	 * After a successful logout the user is still connected to the server, but he/she has to login again into a zone, in order to be able to interact with the server.
	 * 
	 * @return	Nothing. Causes the {@link #onLogout} handler to be called in response.
	 * 
	 * @example	The following example shows how to logout from a zone.
	 * 			<code>
	 * 			smartFox.onLogout = onLogoutHandler
	 * 			
	 * 			smartFox.logout()
	 * 			
	 * 			function onLogoutHandler():Void
	 * 			{
	 * 				trace("Logged out successfully")
	 * 			}
	 * 			</code>
	 * 
	 * @see 	#login
	 * @see		#onLogout
	 * 
	 * @since	SmartFoxServer Pro v1.5.5
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function logout():Void
	{
		var header 	= {t:"sys"}
		this.send(header, "logout", -1, "")
	}
	
	/**
	 * Retrieve the updated list of rooms in the current zone.
	 * Unlike the {@link #roomList} property, this method sends a request to the server, which then sends back the complete list of rooms with all their properties and server-side variables (Room Variables).
	 * 
	 * If the default login mechanism provided by SmartFoxServer is used, then the updated list of rooms is received right after a successful login, without the need to call this method.
	 * Instead, if a custom login handler is implemented, the room list must be manually requested to the server using this method.
	 * 
	 * @return	Nothing. Causes the {@link #onRoomListUpdate} handler to be called in response.
	 * 
	 * @example	The following example shows how to retrieve the room list from the server.
	 * 			<code>
	 * 			smartFox.onRoomListUpdate = onRoomListUpdateHandler
	 * 			
	 * 			smartFox.getRoomList()
	 * 			
	 * 			function onRoomListUpdateHandler(roomList:Object):Void
	 * 			{
	 * 				// Dump the names of the available rooms in the current zone
	 * 				for (var r:String in roomList)
	 * 					trace(roomList[r].getName())
	 * 			}
	 * 			</code>
	 * 
	 * @see		#getRoom
	 * @see		#roomList
	 * @see		#onRoomListUpdate
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function getRoomList():Void
	{
		var header 	= {t:"sys"}
		this.send(header, "getRmList", (this.activeRoomId ? this.activeRoomId : -1), "")
	}
	
	/**
	 * Automatically join the the default room (if existing) for the current zone.
	 * A default room can be specified in the SmartFoxServer server-side configuration by adding the {@code autoJoin = "true"} attribute to one of the {@code <Room>} tags in a zone.
	 * When a room is marked as <i>autoJoin</i> it becomes the default room where all clients are joined when this method is called.
	 * 
	 * @return	Nothing. Causes the {@link #onJoinRoom} or {@link #onJoinRoomError} handlers to be called in response.
	 * 
	 * @example	The following example shows how to join the default room in the current zone.
	 * 			<code>
	 * 			smartFox.autoJoin()
	 * 			</code>
	 * 
	 * @see		#joinRoom
	 * @see		#onJoinRoom
	 * @see		#onJoinRoomError
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function autoJoin():Void
	{
		if ( !checkRoomList() )
			return
		
		var header 	= {t:"sys"}
		this.send(header, "autoJoin", (this.activeRoomId ? this.activeRoomId : -1) , "")
	}
	
	/**
	 * Join a room.
	 * 
	 * @param	newRoom:		the name ({@code String}) or the id ({@code Number}) of the room to join.
	 * @param	pword:			the room's password, if it's a private room (optional, dafault value: {@code null}).
	 * @param	isSpectator:	a boolean flag indicating wheter you join as a spectator or not (optional, dafault value: {@code false}).
	 * @param	dontLeave:		a boolean flag indicating if the current room must be left after successfully joining the new room (optional, dafault value: {@code false}).
	 * @param	oldRoom:		the id of the room to leave (optional, default value: {@link #activeRoomId}).
	 * <hr />
	 * <b>NOTE</b>: the last two optional parameters enable the advanced multi-room join feature of SmartFoxServer, which allows a user to join two or more rooms at the same time. If this feature is not required, the parameters can be omitted.
	 * 
	 * @return	Nothing. Causes the {@link #onJoinRoom} or {@link #onJoinRoomError} handlers to be called in response.
	 * 
	 * @example	In the following example the user requests to join a room with id = 10; by default SmartFoxServer will disconnect him from the previous room.
	 * 			<code>
	 * 			smartFox.joinRoom(10)
	 * 			</code>
	 * 			<hr />
	 * 			
	 * 			In the following example the user requests to join a room with id = 12 and password = "mypassword"; by default SmartFoxServer will disconnect him from the previous room.
	 * 			<code>
	 * 			smartFox.joinRoom(12, "mypassword")
	 * 			</code>
	 * 			<hr />
	 * 			
	 * 			In the following example the user requests to join the room with id = 15 and passes {@code true} to the <i>dontLeave</i> flag; this will join the user in the new room while keeping him in the old room as well.
	 * 			<code>
	 * 			smartFox.joinRoom(15, "", false, true)
	 * 			</code>
	 * 
	 * @see 	#onJoinRoom
	 * @see		#onJoinRoomError
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function joinRoom(newRoom, pword:String, isSpectator:Boolean, dontLeave:Boolean, oldRoom:Number):Void
	{
		if ( !checkRoomList() )
			return
			
		var newRoomId = null
		var isSpec:Number
		
		if (isSpectator)
			isSpec = 1
		else
			isSpec = 0
		
		if (!this.changingRoom)
		{
			if (typeof newRoom == "number")
			{
				newRoomId = newRoom
			}
			else
			{
				// Search the room
				for (var i in this.roomList)
				{
					//trace("scanning " + this.roomList[i].getName())
					if (this.roomList[i].name == newRoom)
					{
						newRoomId = this.roomList[i].id
						break
					}
				}
			}
			
			if (newRoomId != null)
			{
				var header:Object = {t:"sys"} 

				var leaveCurrRoom:String = (dontLeave) ? "0": "1"
				
				// Send oldroom id, even if you don't want to disconnect
				var roomToLeave:Number
				
				if (oldRoom)
					roomToLeave = oldRoom			
				else
					roomToLeave = this.activeRoomId
			
				// CHECK:
				// if this.activeRoomId is null no room has already been entered
				if (this.activeRoomId == null)
				{
					leaveCurrRoom = "0"
					roomToLeave = -1
				}
				
				var message:String = "<room id='" + newRoomId + "' pwd='" + pword + "' spec='" + isSpec + "' leave='" + leaveCurrRoom + "' old='" + roomToLeave + "' />"
				
				this.send(header, "joinRoom", ((this.activeRoomId) ? this.activeRoomId:-1), message)
				this.changingRoom = true
			}
			else
			{
				trace("SmartFoxError: requested room to join does not exist!")
			}
		}
	}
	
	/**
	 * Grant current user permission to be added to a buddy list.
	 * If the SmartFoxServer Pro 1.6.0 <i>advanced</i> security mode is used (see the SmartFoxServer server-side configuration), when a user wants to add a buddy to his/her buddy list, a permission request is sent to the buddy.
	 * Once the {@link #onBuddyPermissionRequest} handler is called, this method must be used by the buddy to grant or refuse permission. When the permission is granted, the requester's buddy list is updated.
	 * 
	 * @param	allowBuddy:		{@code true} to grant permission, {@code false} to refuse to be added to the requester's buddy list.
	 * @param	targetBuddy:	the username of the requester.
	 * 
	 * @example	The following example shows how to grant permission to be added to a buddy list once request is received.
	 * 			<code>
	 * 			smartFox.onBuddyPermissionRequest = onBuddyPermissionRequestHandler
	 * 			
	 * 			var autoGrantPermission:Boolean = true
	 * 			
	 * 			function onBuddyPermissionRequestHandler(sender:String, message:String):Void
	 * 			{
	 * 				if (autoGrantPermission)
	 * 				{
	 * 					// Automatically grant permission
	 * 					
	 * 					smartFox.sendBuddyPermissionResponse(true, sender)
	 * 				}
	 * 				else
	 * 				{
	 * 					// Display an alert attaching a movieclip from the Flash library
	 * 					var alert_mc:MovieClip = attachMovie("customAlertPanel", "customAlertPanel", 100)
	 * 					
	 * 					alert_mc.name_lb.text = sender
	 * 					alert_mc.message_lb.text = message
	 * 				}
	 * 			}
	 * 			</code>
	 * 
	 * @see		#addBuddy
	 * @see		#onBuddyPermissionRequest
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function sendBuddyPermissionResponse(allowBuddy:Boolean, targetBuddy:String):Void
	{
		var xmlMsg:String = "<n res='" + (allowBuddy ? "g" : "r") + "'><![CDATA[" + targetBuddy + "]]></n>";
		
		send({t:"sys"}, "bPrm", -1, xmlMsg)
	}
	
	/**
	 * Send a public message.
	 * The message is broadcasted to all users in the current room, including the sender.
	 * 
	 * @param	message:	the text of the public message.
	 * @param	roomId:		the id of the target room, in case of multi-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. Causes the {@link #onPublicMessage} handler to be called in response.
	 * 
	 * @example	The following example shows how to send and receive a public message.
	 * 			<code>
	 * 			smartFox.onPublicMessage = onPublicMessageHandler
	 * 			
	 * 			smartFox.sendPublicMessage("Hello world!")
	 * 			
	 * 			function onPublicMessageHandler(message:String, sender:User):Void
	 * 			{
	 * 				trace("User " + sender.getName() + " said: " + message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#sendPrivateMessage
	 * @see		#onPublicMessage
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function sendPublicMessage(message:String, roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
			
		var header:Object = {t:"sys"}
		
		// Encapsulate message
		var xmlmsg:String = "<txt><![CDATA[" + os.encodeEntities(message) + "]]></txt>"
	
		this.send(header, "pubMsg", roomId, xmlmsg)
	}
	
	/**
	 * Send a private message to a user.
	 * The message is broadcasted to the recipient and the sender.
	 * 
	 * @param	message:		the text of the private message.
	 * @param	recipientId:	the id of the recipient user.
	 * @param	roomId:			the id of the room from where the message is sent, in case of multi-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. Causes the {@link #onPrivateMessage} handler to be called in response.
	 * 
	 * @example	The following example shows how to send and receive a private message.
	 * 			<code>
	 * 			smartFox.onPrivateMessage = onPrivateMessageHandler
	 * 			
	 * 			smartFox.sendPrivateMessage("Hallo Jack!", 22)
	 * 			
	 * 			function onPrivateMessageHandler(message:String, sender:User):Void
	 * 			{
	 * 				trace("User " + sender.getName() + " sent the following private message: " + message)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#sendPublicMessage
	 * @see		#onPrivateMessage
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function sendPrivateMessage(message:String, recipientId:Number, roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
			
		var header:Object = {t:"sys"}
		
		// Encapsulate message
		var xmlmsg:String = "<txt rcp='" + recipientId + "'><![CDATA[" + os.encodeEntities(message) + "]]></txt>"
	
		this.send(header, "prvMsg", roomId, xmlmsg)
		
	}
	
	/**
	 * Send a Moderator message to the current zone, the current room or a specific user in the current room.
	 * In order to send these kind of messages, the user must have Moderator's privileges, which are set by SmartFoxServer when the user logs in (see the {@link #login} method).
	 * 
	 * @param	message:	the text of the message.
	 * @param	type:		the type of message. The following constants can be passed: {@link #MODMSG_TO_USER}, {@link #MODMSG_TO_ROOM} and {@link #MODMSG_TO_ZONE}, to send the message to a user, to the current room or to the entire current zone respectively.
	 * @param	id:			the id of the recipient room or user (ignored if the message is sent to the zone).
	 * 
	 * @return	Nothing. Causes the {@link #onModeratorMessage} handler to be called.
	 * 
	 * @example	The following example shows how to send a Moderator message.
	 * 			<code>
	 * 			smartFox.sendModeratorMessage("Greetings from the Moderator", SmartFoxClient.MODMSG_TO_ROOM, smartFox.getActiveRoom())
	 * 			</code>
	 * 
	 * @see		#login
	 * @see		#MODMSG_TO_USER
	 * @see		#MODMSG_TO_ROOM
	 * @see		#MODMSG_TO_ZONE
	 * @see		#onModeratorMessage
	 * 
	 * @since	SmartFoxServer Pro v1.4.5
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function sendModeratorMessage(message:String, type:String, id:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		var header:Object = {t:"sys"}
		
		// Encapsulate message
		var xmlmsg:String = "<txt t='" + type + "' id='" + id + "'><![CDATA[" + os.encodeEntities(message) + "]]></txt>"
	
		this.send(header, "modMsg", this.activeRoomId, xmlmsg)
	}
	
	/**
	 * Send an Actionscript object to the other users in the current room.
	 * This method can be used to send complex/nested data structures to clients, like a game move or a game status change. Supported data types are: Strings, Booleans, Numbers, Arrays, Objects.
	 * 
	 * @param	obj:	the Actionscript object to be sent.
	 * @param	roomId:	the id of the target room, in case of multi-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. Causes the {@link #onObjectReceived} handler to be called.
	 * 
	 * @example	The following example shows how to send a simple object with primitive data to the other users.
	 * 			<code>
	 * 			var move:Object = new Object()
	 * 			move.x = 150
	 * 			move.y = 250
	 * 			move.speed = 8
	 * 			
	 * 			smartFox.sendObject(move)
	 * 			</code>
	 * 			<hr />
	 * 
	 * 			The following example shows how to send an object with two arrays of items to the other users.
	 * 			<code>
	 * 			var itemsFound:Object = new Object()
	 * 			itemsFound.jewels = ["necklace", "ring"]
	 * 			itemsFound.weapons = ["sword", "sledgehammer"]
	 * 			
	 * 			smartFox.sendObject(itemsFound)
	 * 			</code>
	 * 
	 * @see		#sendObjectToGroup
	 * @see		#onObjectReceived
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function sendObject(obj:Object, roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		// If roomId is passed then use it
		// otherwise just use the current active room id
		if (roomId == undefined)
			roomId = this.activeRoomId
	
		var xmlPacket:String = "<![CDATA[" + os.serialize(obj) + "]]>"
		var header:Object = {t:"sys"}
	
		this.send(header, "asObj", roomId, xmlPacket)
	}
	
	/**
	 * Send an Actionscript object to a group of users in the room.
	 * See {@link #sendObject} for more info.
	 * 
	 * @param	obj:		the Actionscript object to be sent.
	 * @param	userList:	an array containing the id(s) of the recipients.
	 * @param	roomId:		the id of the target room, in case of multi-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. Causes the {@link #onObjectReceived} handler to be called.
	 * 
	 * @example	The following example shows how to send a simple object with primitive data to two users.
	 * 			<code>
	 * 			var move:Object = new Object()
	 * 			move.x = 150
	 * 			move.y = 250
	 * 			move.speed = 8
	 * 			
	 * 			smartFox.sendObjectToGroup(move, [11, 12])
	 * 			</code>
	 * 
	 * @see		#sendObject
	 * @see		#onObjectReceived
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function sendObjectToGroup(obj:Object, userList:Array, roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
		
		var _$$_:String = ""
		
		for (var i in userList)
		{
			if (!isNaN(userList[i]))
				_$$_ += userList[i] + ","
		}
		_$$_ = _$$_.substr(0, _$$_.length - 1)
		
		obj._$$_ = _$$_
		
		var xmlPacket:String = "<![CDATA[" + os.serialize(obj) + "]]>"
		var header:Object = {t:"sys"}
		
		this.send(header, "asObjG", roomId, xmlPacket)
	}
	
	/**
	 * Block or unblock a user in the buddy list.
	 * When a buddy is blocked, SmartFoxServer does not deliver private messages from/to that user.
	 * 
	 * @param	buddyName:	the name of the buddy to be blocked or unblocked.
	 * @param	status:		{@code true} to block the buddy, {@code false} to unblock the buddy.
	 * 
	 * @example	The following example shows how to block a user from the buddy list.
	 * 			<code>
	 * 			smartFox.setBuddyBlockStatus("jack", true)
	 * 			</code>
	 * 
	 * @see		#buddyList
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function setBuddyBlockStatus(buddyName:String, status:Boolean):Void
	{
		var b:Object = getBuddyByName(buddyName)
		
		if ( b != null )
		{
			if (b.blocked != status)
			{
				b.isBlocked = status
				
				var xmlMsg:String = "<n x='" + (status ? "1" : "0") +"'><![CDATA[" + buddyName + "]]></n>"
				send({t:"sys"}, "setB", -1, xmlMsg)
				
				this.onBuddyListUpdate(b)
			}
		}
	}
	
	/**
	 * Set on or more User Variables.
	 * User Variables are a useful tool to store user data that has to be shared with other users. When a user sets/updates/deletes one or more User Variables, all the other users in the same room are notified. 
	 * Allowed data types for User Variables are Numbers, Strings and Booleans; Arrays and Objects are not supported in order save bandwidth.
	 * If a User Variable is set to {@code null}, it is deleted from the server. Also, User Variables are destroyed when their owner logs out or gets disconnected.
	 * 
	 * @param	varObj:		an object in which each property is a variable to set/update.
	 * @param	roomId:		the room id where the request was originated, in case of molti-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. Causes the {@link #onUserVariablesUpdate} handler to be called.
	 * 
	 * @example	The following example shows how to save the user data (avatar name and position) in an avatar chat application.
	 * 			<code>
	 * 			var uVars:Object = new Object()
	 * 			uVars.myAvatar = "Homer"
	 * 			uVars.posx = 100
	 * 			uVars.posy = 200
	 * 			
	 * 			smartFox.setUserVariables(uVars)
	 * 			</code>
	 * 
	 * @see		#onUserVariablesUpdate
	 * @see		User#getVariable
	 * @see		User#getVariables
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function setUserVariables(varObj:Object, roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
			
		var header:Object = {t:"sys"}
		
		// Encapsulate Variables
		var xmlMsg:String = "<vars>"
		
		// Reference to the user setting the variables
		var user:Object = this.roomList[roomId].userList[this.myUserId]

		for (var vName in varObj)
		{
			var vValue = varObj[vName]
			var t = null
			
			// Check type
			if (typeof vValue == "boolean")
			{
				t = "b"
				vValue = (vValue) ? 1 : 0
			}
			else if (typeof vValue == "number")
				t = "n"
			else if (typeof vValue == "string")
				t = "s"
			else if (typeof vValue == "null")
			{
				t = "x"
				delete user.variables[vName]
			}
			
			if (t != null)
			{
				user.variables[vName] = vValue
				xmlMsg += "<var n='" + vName + "' t='" + t + "'><![CDATA[" + vValue + "]]></var>"
			}
		}
		
		xmlMsg += "</vars>"
		
		// Update local client
		user.setVariables(varObj)
		
		// Send request
		this.send(header, "setUvars", roomId, xmlMsg)
	}
	
	/**
	 * Set the current user's Buddy Variables.
	 * This method allows to set a number of properties of the current user as buddy of other users; in other words these variables will be received by the other users who have the current user as a buddy.
	 * 
	 * Buddy Variables are the best way to share user's informations with all the other users having him/her in their buddy list.: for example the nickname, the current audio track the user is listening to, etc. The most typical usage is to set a variable containing the current user status, like "available", "occupied", "away", "invisible", etc.).
	 * 
	 * <b>NOTE</b>: before the release of SmartFoxServer Pro v1.6.0, Buddy Variables could not be stored, and existed during the user session only. SmartFoxServer Pro v1.6.0 introduced the ability to persist (store) all Buddy Variables and the possibility to save "offline Buddy Variables" (see the following usage notes).
	 * 
	 * @usageNote	Let's assume that three users (A, B and C) use an "istant messenger"-like application, and user A is part of the buddy lists of users B and C.
	 * 				If user A sets his own variables (using the {@link #setBuddyVariables} method), the {@link #myBuddyVars} array on his client gets populated and the {@link #onBuddyListUpdate} handler is called on the clients of users B and C.
	 * 				User B and C can then read those variables in their own buddy lists by means of the <b>variables</b> property on the buddy object (which can be retrieved from the {@link #buddyList} array by means of the {@link #getBuddyById} or {@link #getBuddyByName} methods).
	 * 				<hr />
	 * 				If the buddy list's <i>advanced security mode</i> is used (see the SmartFoxServer server-side configuration), Buddy Variables persistence is enabled: in this way regular variables are saved when a user goes offline and they are restored (and dispatched to the other users) when their owner comes back online.
	 * 				Also, setting the {@code <offLineBuddyVariables>} parameter to {@code true}, offline variables can be used: this kind of Buddy Variables is loaded regardless the buddy is online or not, providing further informations for each entry in the buddy list. A typical usage for offline variables is to define a buddy image or additional informations such as country, email, rank, etc.
	 * 				To creare an offline Buddy Variable, the "$" character must be placed before the variable name.
	 * 
	 * @param	varList:	an associative array, where the key is the name of the variable and the value is the variable's value. Buddy Variables should all be strings. If you need to use other data types you should apply the appropriate type casts.
	 * 
	 * @return	Nothing. Causes the {@link #onBuddyListUpdate} handler to be called.
	 * 
	 * @example	The following example shows how to set three variables containing the user's status, the current audio track the user listening to and the user's rank. The last one is an offline variable.
	 * 			<code>
	 * 			var bVars:Object = new Object()
	 * 			bVars["status"] = "away"
	 * 			bVars["track"] = "One Of These Days"
	 * 			bVars["$rank"] = "guru"
	 * 			
	 * 			smartFox.setBuddyVariables(bVars)
	 * 			</code>
	 * 
	 * @see		#myBuddyVars
	 * @see		#onBuddyListUpdate
	 * 
	 * @history	SmartFoxServer Pro v1.6.0 - Buddy list's <i>advanced security mode</i> implemented (persistent and offline Buddy Variables).
	 * 
	 * @version	SmartFoxServer Basic (except <i>advanced mode</i>) / Pro
	 */
	public function setBuddyVariables(varList:Object):Void
	{			
		var header:Object = {t:"sys"}
		
		// Encapsulate Variables
		var xmlMsg:String = "<vars>"
		
		// Reference to the user setting the variables
		
		for (var vName:String in varList)
		{
			var vValue:String = varList[vName]
			
			// if variable is new or updated send it and update locally
			if (this.myBuddyVars[vName] != vValue)
			{
				this.myBuddyVars[vName] = vValue
				xmlMsg += "<var n='" + vName + "'><![CDATA[" + vValue + "]]></var>"
			}
		}
		
		xmlMsg += "</vars>"
	
		this.send(header, "setBvars", -1, xmlMsg)
	}
	
	/**
	 * D E B U G   O N L Y - Dumps the RoomList structure
	 */
	private function dumpRoomList():Void
	{
		for (var j in this.roomList)
		{
			var room = this.roomList[j]
			
			trace(newline)
			trace("-------------------------------------")
			trace(" > Room: (" + j + ") - " + room.getName())
			trace("isTemp: " + room.isTemp())
			trace("isGame: " + room.isGame())
			trace("isPriv: " + room.isPrivate())
			trace("Users: " + room.getUserCount() + " / " + room.getMaxUsers())
			trace("Variables: ")
			
			for (var i in room.variables)
			{
				trace("\t" + i + " = " + room.getVariable(i))
			}
			
			trace(newline + "UserList: ")
			
			var uList = room.getUserList()
			
			for (var i in uList)
			{
				trace("\t" + uList[i].getId() + " > " + uList[i].getName())
			}
		}
	}
	
	/**
	 * Dynamically create a new room in the current zone.
	 * 
	 * <b>NOTE</b>: if the newly created room is a game room, the user is joined automatically upon successful room creation.
	 * 
	 * @param	roomObj:	an object with the properties described farther on.
	 * @param	roomId:		the id of the room from where the request is originated, in case the application allows multi-room join (optional, default value: {@link #activeRoomId}). 
	 * 
	 * <hr />
	 * The <i>roomObj</i> parameter is an object containing the following properties:
	 * @param	name:				(<b>String</b>) the room name.
	 * @param	password:			(<b>String</b>) a password to make the room private (optional, default: none).
	 * @param	maxUsers:			(<b>Number</b>) the maximum number of users that can join the room.
	 * @param	maxSpectators:		(<b>Number</b>) in game rooms only, the maximum number of spectators that can join the room (optional, default value: 0).
	 * @param	isGame:				(<b>Boolean</b>) if {@code true}, the room is a game room (optional, default value: {@code false}).
	 * @param	exitCurrentRoom:	(<b>Boolean</b>) if {@code true} and in case of game room, the new room is joined after creation (optional, default value: {@code true}).
	 * @param	uCount:				(<b>Boolean</b>) if {@code true}, the new room will receive the {@link #onUserCountChange} notifications (optional, default <u>recommended</u> value: {@code false}).
	 * @param	vars:				(<b>Array</b>) an array of Room Variables, as described in the {@link #setRoomVariables} method documentation (optional, default: none).
	 * @param	extension:			(<b>Object</b>) which extension should be dynamically attached to the room, as described farther on (optional, default: none).
	 * 
	 * <hr />
	 * A Room-level extension can be attached to any room during creation; the <i>extension</i> property in the <i>roomObj</i> parameter is an object with the following properties:
	 * @param	name:	(<b>String</b>) the name used to reference the extension (see the SmartFoxServer server-side configuration).
	 * @param	script:	(<b>String</b>) the file name of the extension script (for Actionscript and Python); if Java is used, the fully qualified name of the extension must be provided. The file name is relative to the root of the extension folder ("sfsExtensions/" for Actionscript and Python, "javaExtensions/" for Java).
	 * 
	 * @return	Nothing. Causes the {@link #onRoomAdded} or {@link #onCreateRoomError} handlers to be called in response.
	 * 
	 * @example	The following example shows how to create a new room.
	 * 			<code>
	 * 			var roomObj:Object = new Object()
	 * 			roomObj.name = "The Cave"
	 * 			roomObj.isGame = true
	 * 			roomObj.maxUsers = 15
	 * 			
	 * 			var variables:Array = new Array()
	 * 			variables.push({name:"ogres", val:5, priv:true})
	 * 			variables.push({name:"skeletons", val:4})
	 * 			
	 * 			roomObj.vars = variables
	 * 			
	 * 			smartFox.createRoom(roomObj)
	 * 			</code>
	 * 
	 * @see		#onRoomAdded
	 * @see		#onCreateRoomError
	 * @see		#onUserCountChange
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function createRoom(roomObj:Object, roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
		
		if (roomId == undefined)
		 	roomId = this.activeRoomId
		
		var header:Object 	= {t:"sys"}
			
		var isGame:Number 	= (roomObj.isGame) ? 1 : 0
		var exitCurrent:Number	= 1
		var maxSpectators:Number= roomObj.maxSpectators
		var joinAsSpectator:String = roomObj.joinAsSpectator ? "1" : "0"
		
		// If this is a Game Room you will leave the current room
		// and log into the new game room
		// If you specify exitCurrentRoom = false you will not be logged out of the curr room.
		if (isGame && roomObj.exitCurrentRoom != undefined)
			exitCurrent	= (roomObj.exitCurrentRoom) ? 1 : 0
		
		var xmlMsg:String  = "<room tmp='1' gam='" + isGame + "' spec='" + maxSpectators + "' exit='" + exitCurrent + "' jas='" + joinAsSpectator + "'>"
		
		xmlMsg += "<name><![CDATA[" + roomObj.name + "]]></name>"
		xmlMsg += "<pwd><![CDATA[" + (roomObj.password == undefined ? "" : roomObj.password) + "]]></pwd>"
		xmlMsg += "<max>" + roomObj.maxUsers + "</max>"
		//xmlMsg += "<desc><![CDATA[" + roomObj.description + "]]></desc>"
		
		if (roomObj.uCount != undefined)
		{
			xmlMsg += "<uCnt>" + (roomObj.uCount ? "1" : "0") + "</uCnt>"
		}
		
		// Set extension for room
		if (roomObj.extension != undefined)
		{
			xmlMsg += "<xt n='" + roomObj.extension.name
			xmlMsg += "' s='" + roomObj.extension.script + "' />"
		}
		
		// Set Room Variables on creation
		if (roomObj.vars == undefined)
			xmlMsg += "<vars></vars>"
		else
		{
			xmlMsg += "<vars>"
			
			for (var i in roomObj.vars)
			{
				xmlMsg += getXmlRoomVariable(roomObj.vars[i])
			}
			
			xmlMsg += "</vars>"
		}
		
		xmlMsg += "</room>"
			
		this.send(header, "createRoom", roomId, xmlMsg)
	}
	
	/** 
	 * Disconnect the user from the given room.
	 * This method should be used only when users are allowed to be present in more than one room at the same time (multi-room join feature).
	 * 
	 * @param	roomId:	the id of the room to leave.
	 * 
	 * @return	Nothing. Causes the {@link #onRoomLeft} handler to be called in response.
	 * 
	 * @example	The following example shows how to make a user leave a room.
	 * 			<code>
	 * 			smartFox.leaveRoom(15)
	 * 			</code>
	 * 
	 * @see 	#joinRoom
	 * @see		#onRoomLeft
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function leaveRoom(roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		var header:Object = {t:"sys"}
		var xmlMsg:String = "<rm id='" + roomId + "' />"
		
		this.send(header, "leaveRoom", roomId, xmlMsg)
	}
	
	/**
	 * Get a {@link Room} object, using its id or name as key.
	 * 
	 * @param	roomId:	the id ({@code Number}) or the name ({@code String}) of the room.
	 * 
	 * @return	The {@link Room} object.
	 * 
	 * @example	The following example shows how to retrieve a room from its id.
	 * 			<code>
	 * 			var roomObj:Room = smartFox.getRoom(15)
	 * 			trace("Room name: " + roomObj.getName() + ", max users: " + roomObj.getMaxUsers())
	 * 			</code>
	 * 
	 * @see 	#roomList
	 * @see		#getRoomList
	 * @see		Room
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function getRoom(roomId):Room
	{
		if ( !checkRoomList() )
			return
		
		if (typeof roomId == "number")
		{
			return this.roomList[roomId]
		}
		else if (typeof roomId == "string")
		{
			for (var i in this.roomList)
			{
				var r = this.roomList[i]
	
				if (r.getName() == roomId)
				{
					return r;
				}
			}
		}
	}
	
	/**
	 * Get the currently active {@link Room} object.
	 * SmartFoxServer allows users to join two or more rooms at the same time (multi-room join). If this feature is used, then this method is useless and the application should track the various room id(s) manually, for example by keeping them in an array.
	 * 
	 * @return	the {@link Room} object of the currently active room; if the user joined more than one room, the last joined room is returned.
	 * 
	 * @example	The following example shows how to retrieve the current room object.
	 * 			<code>
	 * 			var room:Room = smartFox.getActiveRoom()
	 * 			trace("Current room is: " + room.getName())
	 * 			</code>
	 * 
	 * @see		#activeRoomId
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function getActiveRoom():Room
	{
		if ( !checkRoomList() || !checkJoin() )
			return null
			
		return this.roomList[this.activeRoomId]
	}
	
	/**
	 * Set one or more Room Variables.
	 * Room Variables are a useful feature to share data across the clients, keeping it in a centralized place on the server. When a user sets/updates/deletes one or more Room Variables, all the other users in the same room are notified. 
	 * Allowed data types for Room Variables are Numbers, Strings and Booleans; in order save bandwidth, Arrays and Objects are not supported. Nevertheless, an array of values can be simulated, for example, by using an index in front of the name of each variable (check one of the following examples).
	 * If a Room Variable is set to {@code null}, it is deleted from the server.
	 * 
	 * @param	varList:		an array of objects with the properties described farther on.
	 * @param	roomId:			the id of the room where the variables should be set, in case of molti-room join (optional, default value: {@link #activeRoomId}).
	 * @param	setOwnership:	{@code false} to prevent the Room Variable change ownership when its value is modified by another user (optional, default value: {@code true}).
	 * 
	 * <hr />
	 * Each Room Variable is an object containing the following properties:
	 * @param	name:		(<b>String</b>) the variable name.
	 * @param	val:		(any supported data type) the variable value.
	 * @param	priv:		(<b>Boolean</b>) if {@code true}, the variable can be modified by its creator only (optional, default value: {@code false}).
	 * @param	persistent:	(<b>Boolean</b>) if {@code true}, the variable will exist until its creator is connected to the current zone; if {@code false}, the variable will exist until its creator is connected to the current room (optional, default value: {@code false}).
	 * 
	 * @return	Nothing. Causes the {@link #onRoomVariablesUpdate} handler to be called.
	 * 
	 * @example	The following example shows how to save a persistent Room Variable called "score". This variable won't be destroyed when its creator leaves the room.
	 * 			<code>
	 * 			var rVars:Array = new Array()
	 * 			rVars.push({name:"score", val:2500, persistent:true})
	 * 			
	 * 			smartFox.setRoomVariables(rVars)
	 * 			</code>
	 * 			
	 * 			<hr />
	 * 			The following example shows how to save two Room Variables at once. The one called "bestTime" is private and no other user except its owner can modify it.
	 * 			<code>
	 * 			var rVars:Array = new Array()
	 * 			rVars.push({name:"bestTime", val:100, priv:true})
	 * 			rVars.push({name:"bestLap", val:120})
	 * 			
	 * 			smartFox.setRoomVariables(rVars)
	 * 			</code>
	 * 			
	 * 			<hr />
	 * 			The following example shows how to delete a Room Variable called "bestTime" by setting its value to {@code null}.
	 * 			<code>
	 * 			var rVars:Array = new Array()
	 * 			rVars.push({name:"bestTime", val:null})
	 * 			
	 * 			smartFox.setRoomVariables(rVars)
	 * 			</code>
	 * 			
	 * 			<hr />
	 * 			The following example shows how to send an array-like set of data without consuming too much bandwidth.
	 * 			<code>
	 * 			var rVars:Array = new Array()
	 * 			var names:Array = ["john", "dave", "sam"]
	 * 			
	 * 			for (var i:Number = 0; i < names.length; i++)
	 * 				rVars.push({name:"name" + i, val:names[i]})
	 * 			
	 * 			smartFox.setRoomVariables(rVars)
	 * 			</code>
	 * 			
	 * 			<hr />
	 * 			The following example shows how to handle the data sent in the previous example when the {@link #onRoomVariablesUpdate} handler is called.
	 * 			<code>
	 * 			smartFox.onRoomVariablesUpdate = onRoomVariablesUpdateHandler
	 * 			
	 * 			function onRoomVariablesUpdateHandler(room:Room, changedVars:Array):Void
	 * 			{
	 * 					// Iterate on the 'changedVars' array to check which variables were updated
	 * 					for (var v:String in changedVars)
	 * 						trace(v + " room variable was updated; new value is: " + room.getVariable(v))
	 * 			}
	 * 			</code>
	 * 			
	 * 			<hr />
	 * 			The following example shows how to update a Room Variable without affecting the variable's ownership.
	 * 			By default, when a user updates a Room Variable, he becomes the "owner" of that variable. In some cases it could be needed to disable this behavoir by setting the <i>setOwnership</i> to {@code false}. 
	 * 			<code>
	 * 			// For example, a variable that is defined in the server-side xml configuration file is owned by the Server itself;
	 * 			// if it's not set to private, its owner will change as soon as a user updates it.
	 * 			// To avoid this change of ownership the setOwnership flag is set to false.
	 * 			var rVars:Array = new Array()
	 * 			rVars.push({name:"shipPosX", val:100})
	 * 			rVars.push({name:"shipPosY", val:200})
	 * 			
	 * 			smartFox.setRoomVariables(rVars, smartFox.getActiveRoom(), false)
	 * 			</code>
	 * 
	 * @see		Room#getVariable
	 * @see		Room#getVariables
	 * @see		#onRoomVariablesUpdate
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function setRoomVariables(varList:Array, roomId:Number, setOwnership:Boolean):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
		
		if (setOwnership == undefined)
			setOwnership = true
			
		var header:Object 	= {t:"sys"}
		
		// Encapsulate Variables
		// so (setOwnership) attribute is sent only if specified as false
		var xmlMsg:String 
		if (setOwnership)
			xmlMsg = "<vars>"
		else
			xmlMsg = "<vars so='0'>"	
		
		for (var i:Number = 0; i < varList.length; i++)
			xmlMsg += getXmlRoomVariable(varList[i])
		
		xmlMsg += "</vars>"
	
		this.send(header, "setRvars", roomId, xmlMsg)
	}
	
	/**
	 * Returns the XML representation of a RoomVariable.
	 * Used by CreateRoom() and setRoomVariables() methods.
	 */
	private function getXmlRoomVariable(rVar):String
	{
		// Get properties for this var
		var vName	= rVar.name
		var vValue 	= rVar.val
		var vPrivate	= (rVar.priv) ? "1":"0"
		var vPersistent = (rVar.persistent) ? "1":"0"
		
		var t = null
		
		// Check type
		if (typeof vValue == "boolean")
		{
			t = "b"
			vValue = (vValue) ? 1:0			// transform in number before packing in xml
		}
		else if (typeof vValue == "number")
			t = "n"
		else if (typeof vValue == "string")
			t = "s"
		else if (typeof vValue == "null")
			t = "x"
		
		if (t != null)
			return "<var n='" + vName + "' t='" + t + "' pr='" + vPrivate + "' pe='" + vPersistent + "'><![CDATA[" + vValue + "]]></var>"
		else
			return ""
	}
	
	/**
	 * Load the buddy list for the current user.
	 * 
	 * @return	Nothing. Causes the {@link #onBuddyList} or {@link #onBuddyListError} handlers to be called in response.
	 * 
	 * @example	The following example shows how to load the current user's buddy list.
	 * 			<code>
	 * 			smartFox.onBuddyList = onBuddyListHandler
	 * 			
	 * 			smartFox.loadBuddyList()		
	 * 
	 * 			function onBuddyListHandler(list:Array):Void
	 * 			{
	 * 				for (var b:String in list)
	 * 				{
	 * 					var buddy:Object = list[b]
	 * 					
	 * 					trace("Buddy id: " + buddy.id)
	 * 					trace("Buddy name: " + buddy.name)
	 * 					trace("Is buddy online? " + buddy.isOnline ? "Yes" : "No")
	 * 					trace("Is buddy blocked? " + buddy.isBlocked ? "Yes" : "No")
	 * 					
	 * 					trace("Buddy Variables:")
	 * 					for (var v:String in buddy.variables)
	 * 						trace("\t" + v + " --> " + buddy.variables[v])
	 * 				}
	 * 			}
	 * 			</code>
	 * 
	 * @see		#buddyList
	 * @see		#onBuddyList
	 * @see		#onBuddyListError
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function loadBuddyList():Void
	{
		var header:Object = {t:"sys"}
		this.send(header, "loadB", -1, "")
	}
	
	/**
	 * Add a user to the buddy list.
	 * Since SmartFoxServer Pro 1.6.0, the buddy list feature can be configured to use a <i>basic</i> or <i>advanced</i> security mode (see the SmartFoxServer server-side configuration file).
	 * Check the following usage notes for details on the behavior of the <b>addBuddy</b> method in the two cases.
	 * 
	 * @usageNote	<i>Basic security mode</i>
	 * 				When a buddy is added, if the buddy list is already full, the {@link #onBuddyListError} handler is called; otherwise the buddy list is updated and the {@link #onBuddyList} handler is called.
	 * 				<hr />
	 * 				<i>Advanced security mode</i>
	 * 				If the {@code <addBuddyPermission>} parameter is set to {@code true} in the buddy list configuration section of a zone, before the user is actually added to the buddy list he/she must grant his/her permission.
	 * 				The permission request is sent if the user is online only. When the permission is granted, the buddy list is updated and the {@link #onBuddyList} handler is called.
	 * 				If the permission is not granted (or the buddy didn't receive the permission request), the <b>addBuddy</b> method can be called again after a certain amount of time only. This time is set in the server configuration {@code <permissionTimeOut>} parameter.
	 * 				Also, if the {@code <mutualAddBuddy>} parameter is set to {@code true}, when user A adds user B to the buddy list, he/she is automatically added to user B's buddy list.
	 * 				Lastly, if the buddy list is full, the {@link #onBuddyListError} handler is called.
	 * 
	 * @param	buddyName:	the name of the user to be added to the buddy list.
	 * 
	 * @return	Nothing. Causes the {@link #onBuddyList} or {@link #onBuddyListError} handlers to be called in response.
	 * 
	 * @example	The following example shows how to add a user to the buddy list.
	 * 			<code>
	 * 			smartFox.addBuddy("jack")
	 * 			</code>
	 * 
	 * @see		#buddyList
	 * @see		#removeBuddy
	 * @see		#setBuddyBlockStatus
	 * @see		#onBuddyList
	 * @see		#onBuddyListError
	 * 
	 * @history	SmartFoxServer Pro v1.6.0 - Buddy list's <i>advanced security mode</i> implemented.
	 * 
	 * @version	SmartFoxServer Basic (except <i>advanced mode</i>) / Pro
	 */
	public function addBuddy(buddyName:String):Void
	{
		if (buddyName != this.myUserName && !this.checkBuddy(buddyName))
		{
			
			// Look for userId
			var id = this.roomList[this.activeRoomId].getUserList().getUser(buddyName)
				
			// Send buddy to server
			var header:Object = {t:"sys"}
			var xmlMsg:String = "<n>" + buddyName + "</n>"
			
			this.send(header, "addB", -1, xmlMsg)
		}
	}
	
	/**
	 * Remove a buddy from the buddy list.
	 * Since SmartFoxServer Pro 1.6.0, the buddy list feature can be configured to use a <i>basic</i> or <i>advanced</i> security mode (see the SmartFoxServer server-side configuration file).
	 * Check the following usage notes for details on the behavior of the <b>removeBuddy</b> method in the two cases.
	 * 
	 * @usageNote	<i>Basic security mode</i>
	 * 				When a buddy is removed, the buddy list is updated and the {@link #onBuddyList} handler is called.
	 * 				<hr />
	 * 				<i>Advanced security mode</i>
	 * 				In addition to the basic behavior, if the {@code <mutualRemoveBuddy>} server-side configuration parameter is set to {@code true}, when user A removes user B from the buddy list, he/she is automatically removed from user B's buddy list.
	 * 
	 * @param	buddyName:	the name of the user to be removed from the buddy list.
	 * 
	 * @return	Nothing. Causes the {@link #onBuddyList} handler to be called in response.
	 * 
	 * @example	The following example shows how to remove a user from the buddy list.
	 * 			<code>
	 * 			var buddyName:String = "jack"
	 * 			smartFox.removeBuddy(buddyName)
	 * 			</code>
	 * 
	 * @see		#buddyList
	 * @see		#addBuddy
	 * @see		#onBuddyList
	 * 
	 * @history	SmartFoxServer Pro v1.6.0 - Buddy list's <i>advanced security mode</i> implemented.
	 * 
	 * @version	SmartFoxServer Basic (except <i>advanced mode</i>) / Pro
	 */
	public function removeBuddy(buddyName:String):Void
	{
		//var buddy:Object

		for (var i in this.buddyList)
		{
			if (this.buddyList[i].name == buddyName)
			{
				delete this.buddyList[i]
				break
			}
		}
		
		var header:Object = {t:"sys"}
		var xmlMsg:String = "<n>" + buddyName + "</n>"
			
		// Send 
		this.send(header, "remB", -1, xmlMsg)
			
		this.onBuddyList(this.buddyList)
	}
	
	/**
	 * Get a buddy from the buddy list, using the buddy's username as key.
	 * Refer to the {@link #buddyList} property for a description of the buddy object's properties.
	 * 
	 * @param	buddyName:	the username of the buddy.
	 * 
	 * @return	The buddy object.
	 * 
	 * @example	The following example shows how to retrieve a buddy from the buddy list.
	 * 			<code>
	 * 			var buddy:Object = smartFox.getBuddyByName("jack")
	 * 			
	 * 			trace("Buddy id: " + buddy.id)
	 * 			trace("Buddy name: " + buddy.name)
	 * 			trace("Is buddy online? " + buddy.isOnline ? "Yes" : "No")
	 * 			trace("Is buddy blocked? " + buddy.isBlocked ? "Yes" : "No")
	 * 			
	 * 			trace("Buddy Variables:")
	 * 			for (var v:String in buddy.variables)
	 * 				trace("\t" + v + " --> " + buddy.variables[v])
	 * 			</code>
	 * 
	 * @see 	#buddyList
	 * @see		#getBuddyById
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function getBuddyByName(buddyName:String):Object
	{
		var buddy
		for (var i:String in buddyList)
		{
			buddy = buddyList[i]
			if (buddy.name == buddyName)
				return buddy
		}
		
		return null
	}
	
	/**
	 * Get a buddy from the buddy list, using the user id as key.
	 * Refer to the {@link #buddyList} property for a description of the buddy object's properties.
	 * 
	 * @param	id:	the user id of the buddy.
	 * 
	 * @return	The buddy object.
	 * 
	 * @example	The following example shows how to retrieve a buddy from the buddy list.
	 * 			<code>
	 * 			var buddy:Object = smartFox.getBuddyById(25)
	 * 			
	 * 			trace("Buddy id: " + buddy.id)
	 * 			trace("Buddy name: " + buddy.name)
	 * 			trace("Is buddy online? " + buddy.isOnline ? "Yes" : "No")
	 * 			trace("Is buddy blocked? " + buddy.isBlocked ? "Yes" : "No")
	 * 			
	 * 			trace("Buddy Variables:")
	 * 			for (var v:String in buddy.variables)
	 * 				trace("\t" + v + " --> " + buddy.variables[v])
	 * 			</code>
	 * 
	 * @see 	#buddyList
	 * @see		#getBuddyByName
	 * 
	 * @since	SmartFoxServer Pro v1.6.0
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function getBuddyById(id:Number):Object
	{
		var buddy
		for (var i:String in buddyList)
		{
			buddy = buddyList[i]
			if (buddy.id == id)
				return buddy
		}
		
		return null
	}
	
	/**
	 * Request the room id(s) of the room(s) where a buddy is currently located into.
	 * 
	 * @param	buddy:	a buddy object taken from the {@link #buddyList} array.
	 * 
	 * @return	Nothing. Causes the {@link #onBuddyRoom} handler to be called in response.
	 * 
	 * @example	The following example shows how to join the same room of a buddy.
	 * 			<code>
	 * 			smartFox.onBuddyRoom = onBuddyRoomHandler
	 * 			
	 * 			var buddy:Object = smartFox.getBuddyByName("jack")
	 * 			smartFox.getBuddyRoom(buddy)
	 * 			
	 * 			function onBuddyRoomHandler(idList:Array):Void
	 * 			{
	 * 				// Reach the buddy in his room
	 * 				smartFox.join(idList[0])
	 * 			}
	 * 			</code>
	 * 
	 * @see 	#buddyList
	 * @see		#onBuddyRoom
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function getBuddyRoom(buddy:Object):Void
	{
		// If buddy is active...
		if (buddy.id != -1)
			this.send({t:"sys"}, "roomB", -1, "<b id='" + buddy.id + "' />")
	}
	
	/**
	 * Check if a buddy already exist.
	 * 
	 * @exclude
	 */
	public function checkBuddy(name):Boolean
	{
		var res:Boolean = false
		
		for (var i in this.buddyList)
		{
			if (this.buddyList[i].name == name)
			{
				res = true
				break
			}
		}
		
		return res
	}
	
	/**
	 * Remove all users from the buddy list.
	 * 
	 * @deprecated	In order to avoid conflits with the buddy list <i>advanced security mode</i> implemented since SmartFoxServer Pro 1.6.0, buddies should be removed one by one, by iterating through the buddy list.
	 * 
	 * @return	Nothing. Causes the {@link #onBuddyList} handler to be called in response.
	 * 
	 * @example	The following example shows how to clear the buddy list.
	 * 			<code>
	 * 			smartFox.clearBuddyList()
	 * 			</code>
	 * 
	 * @see		#buddyList
	 * @see		#onBuddyList
	 * 
	 * @history	SmartFoxServer Pro v1.6.0 - Method deprecated.
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function clearBuddyList():Void
	{
		this.buddyList = []
		
		this.send({t:"sys"}, "clearB", -1, "")
		
		this.onBuddyList(this.buddyList)
	}
	
	/**
	 * Send a roundtrip request to the server to test the connection' speed.
	 * The roundtrip request sends a small packet to the server which immediately responds with another small packet, and causing the {@link #onRoundTripResponse} handler to be called.
	 * The time taken by the packet to travel forth and back is called "roundtrip time" and can be used to calculate the average network lag of the client.
	 * A good way to measure the network lag is to send continuos requests (every 3 or 5 seconds) and then calculate the average roundtrip time on a fixed number of responses (i.e. the last 10 measurements).
	 * 
	 * @return	Nothing. Causes the {@link #onRoundTripResponse} handler to be called in response.
	 * 
	 * @example	The following example shows how to check the average network lag time.
	 * 			<code>
	 * 			smartFox.onRoundTripResponse = onRoundTripResponseHandler
	 * 			
	 * 			var totalPingTime:Number = 0
	 * 			var pingCount:Number = 0
	 * 			
	 * 			smartFox.roundTripBench() // TODO: this method must be called repeatedly every 3-5 seconds to have a significant average value
	 * 			
	 * 			function onRoundTripResponseHandler(elapsed:Number):Void
	 * 			{
	 * 				// We assume that it takes the same time to the ping message to go from the client to the server
	 * 				// and from the server back to the client, so we divide the elapsed time by 2.
	 * 				totalPingTime += elapsed / 2
	 * 				pingCount++
	 * 				
	 * 				var avg:Number = Math.round(totalPingTime / pingCount)
	 * 				
	 * 				trace("Average lag: " + avg + " milliseconds")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onRoundTripResponse
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function roundTripBench():Void
	{
		this.t1 		= getTimer()
		
		var header:Object	= {t:"sys"}
		this.send(header, "roundTrip", this.activeRoomId, "")
	}
	
	/**
	 * Turn a spectator inside a game room into a player. 
	 * All spectators have their <b>player id</b> property set to -1; when a spectator becomes a player, his player id gets a number > 0, representing the player number. The player id values are assigned by the server, based on the order in which the players joined the room.
	 * If the user joined more than one room, the id of the room where the switch should occurr must be passed to this method.
	 * The switch operation is successful only if at least one player slot is available in the room.
	 * 
	 * @param	roomId:	the id of the room where the spectator should be switched, in case of molti-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. Causes the {@link #onSpectatorSwitched} handler to be called in response.
	 * 
	 * @example	The following example shows how to turn a spectator into a player.
	 * 			<code>
	 * 			smartFox.onSpectatorSwitched = onSpectatorSwitchedHandler
	 * 			
	 * 			smartFox.switchSpectator()
	 * 			
	 * 			function onSpectatorSwitchedHandler(success:Boolean, newId:Number):Void
	 * 			{
	 * 				if (success)
	 * 					trace("You have been turned into a player; your player id is " + newId)
	 * 				else
	 * 					trace("The attempt to switch from spectator to player failed")
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onSpectatorSwitched
	 * @see		User#isSpectator
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function switchSpectator(roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
		
		var header:Object	= {t:"sys"}
		this.send(header, "swSpec", roomId, "")
	}
	
	/**
	 * Turn a player inside a game room into a spectator.
	 * All players have their <b>player id</b> property set to a value > 0; when a spectator becomes a player, his playerId is set to -1.
	 * If the user joined more than one room, the id of the room where the switch should occurr must be passed to this method.
	 * The switch operation is successful only if at least one spectator slot is available in the room.
	 * 
	 * @param	roomId:	the id of the room where the player should be switched to spectator, in case of multi-room join (optional, default value: {@link #activeRoomId}).
	 * 
	 * @return	Nothing. Causes the {@link #onPlayerSwitched} handler to be called in response.
	 *
	 * @example	The following example shows how to turn a player into a spectator.
	 * 			<code>
	 * 			smartFox.onPlayerSwitched = onPlayerSwitchedHandler
	 * 			
	 * 			smartFox.switchPlayer()
	 * 			
	 * 			function onPlayerSwitchedHandler(success:Boolean, newId:Number):Void
	 * 			{
	 * 				if (success)
	 * 					trace("You have been turned into a spectator; your id is: " + newId)
	 * 				else
	 * 					trace("The attempt to switch from player to spectator failed!")
	 * 			}
	 * 			</code>
	 * 
	 * @see		User#isSpectator
	 * @see		#onPlayerSwitched
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function switchPlayer(roomId:Number):Void
	{
		if ( !checkRoomList() || !checkJoin() )
			return
			
		if (roomId == undefined)
			roomId = this.activeRoomId
	
		var header:Object = {t:"sys"}
		this.send(header, "swPl", roomId, "")
	}
	
	/**
	 * Retrieve a random string key from the server.
	 * This key is also referred in the SmartFoxServer documentation as the "secret key".
	 * It's a unique key, valid for the current session only. It can be used to create a secure login system.
	 * 
	 * @return	Nothing. Causes the {@link #onRandomKey} handler to be called in response.
	 * 
	 * @example	The following example shows how to handle the request a random key to the server.
	 * 			<code>
	 * 			smartFox.onRandomKey = onRandomKeyHandler
	 * 			
	 * 			smartFox.getRandomKey()
	 * 			
	 * 			function onRandomKeyHandler(key:String):Void
	 * 			{
	 * 				trace("Random key received from server: " + key)
	 * 			}
	 * 			</code>
	 * 
	 * @see		#onRandomKey
	 * 
	 * @version	SmartFoxServer Pro
	 */
	public function getRandomKey():Void
	{
		this.send({t:"sys"}, "rndK", -1, "")
	}
	
	
	private function send(header:Object, action:String, fromRoom:Number, message:String):Void
	{
		// Setup Msg Header
		var xmlMsg:String = this.makeHeader(header);
		
		// Setup Body
		xmlMsg += "<body action='" + action + "' r='" + fromRoom + "'>" + message + "</body>" + this.closeHeader()
	
		if (this.debug)
			trace("[Sending]: " + xmlMsg + newline)
		
		if (isHttpMode)
			httpConnection.send(xmlMsg)
		else
			super.send(xmlMsg)
	}
	
	/**
	 * Upload a file to the embedded webserver.
	 * 
	 * @param	fileRef:	the FileReference object (see the example).
	 * @param	id:			the user id (optional, default value: {@link #myUserId}).
	 * @param	nick:		the user name (optional, default value: {@link #myUserName}).
	 * @param	port:		the webserver's TCP port (optional, default value: {@link #httpPort}).
	 * 
	 * @return	Nothing. Upload events fired in response should be handled by the provided FileReference object (see the example).
	 * 
	 * @example	Check the Upload Tutorial available here: {@link http://www.smartfoxserver.com/docs/docPages/tutorials_pro/14_imageManager/}
	 * 
	 * @see		#myUserId
	 * @see		#myUserName
	 * @see		#httpPort
	 * 
	 * @since	SmartFoxServer Pro v1.5.0
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function uploadFile(fileRef, id:Number, nick:String, port:Number):Void
	{
		if (id == undefined)
			id = this.myUserId
		
		if (nick == undefined)
			nick = this.myUserName
			
		if (port == undefined)
			port = this.httpPort
		
		fileRef.upload("http://" + this.ipAddress + ":" + port + "/default/Upload.py?id=" + id + "&nick=" + nick)
		
		if (this.debug)
			trace("[UPLOAD]: http://" + this.ipAddress + ":" + port + "/default/Upload.py?id=" + id + "&nick=" + nick)
	}
	
	/**
	 * Get the default upload path of the embedded webserver.
	 * 
	 * @return	The http address of the default folder in which files are uploaded.
	 * 
	 * @example	The following example shows how to get the default upload path.
	 * 			<code>
	 * 			var path:String = smartFox.getUploadPath()
	 * 			</code>
	 * 
	 * @see		#uploadFile
	 * 
	 * @since	SmartFoxServer Pro v1.5.0
	 * 
	 * @version	SmartFoxServer Basic / Pro
	 */
	public function getUploadPath():String
	{
		return "http://" + this.ipAddress + ":" + this.httpPort + "/default/uploads/"
	}
	
	//-----------------------------------------------------------------------------------
	// sendString sends a string formatted message instead of an XML one
	// The string is separated by a separator character
	// The first two fields are mandatory:
	//
	// % handlerId % actionName % param % param % ... % ... %
	//-----------------------------------------------------------------------------------
	private function sendString(message:String):Void
	{
		if (this.debug)
			trace("[Sending]: " + message + newline)
		
		if (isHttpMode)
			httpConnection.send(message)
		else			
			super.send(message)
	}
	
	private function sendJson(message:String):Void
	{
		if (this.debug)
			trace("[Sending - json]: " + message + newline)
				
		if (isHttpMode)
			httpConnection.send(message)
		else			
			super.send(message)
	}
	
	
	// Override parent class method
	private function gotData(message:String) 
	{
		if (message.charAt(0) == rawProtocolSeparator)
			strReceived(message)

		else if (message.charAt(0) == "<")
			onXML(new XML(message));
			
		else if (message.charAt(0) == "{")
			jsonReceived(message)
	}
	
	/**
	 * @exclude
	 */
	public function connectionEstablished(ok:Boolean):Void
	{
		// Socket connection OK
		if (ok)
		{
			clearInterval( socketConnectionTimeoutThread )
			this.preConnection = false
			
			var header:Object = {t:"sys"}
			var xmlMsg:String = "<ver v='" + this.majVersion.toString() + this.minVersion.toString() + this.subVersion.toString() + "' />"	
			this.send(header, "verChk", 0, xmlMsg)
		}
		
		// Socket connection failed
		else
		{
			if (smartConnect && preConnection)
	 		{
				if (this.debug)
	 				trace("** Socket connection failed. Trying BlueBox **")
	
	 			isHttpMode = true
				var __ip:String = blueBoxIpAddress != null ? blueBoxIpAddress : ipAddress
	 			var __port:Number = blueBoxPort != 0 ? blueBoxPort : httpPort

	 			httpConnection.connect(__ip, __port)
	 		}
	 		else
			{
				this.preConnection = false
				this.onConnection(false)
			}
		}
	}
	
	
	private function connectionClosed():Void
	{
		this.isConnected = false
		
		// Socket connection attempt timed out
		if (preConnection)
		{
			connectionEstablished(false)
		}
		
		// Connection was lost
		else
		{
			initialize()

			// Fire client event
			onConnectionLost()
		}
		
	}
	
	/**
	 * Establish a connection to SmartFoxServer.
	 * The client usually gets connected to SmartFoxServer through a socket connection. In SmartFoxServer Pro, if a socket connection is not available and the {@link #smartConnect} property is set to {@code true}, an http connection to the BlueBox module is attempted.
	 * When a successful connection is established, the {@link #getConnectionMode} can be used to check the current connection mode.
	 * 
	 * @param	ipAdr:	the SmartFoxServer ip address.
	 * @param	port:	the SmartFoxServer TCP port.
	 * 
	 * @return	Nothing. Causes the {@link #onConnection} handler to be called in response.
	 * 
	 * @example	The following example shows how to connect to SmartFoxServer.
	 * 			<code>
	 * 			smartFox.connect("127.0.0.1", 9339)
	 * 			</code>
	 * 
	 * @see		#disconnect
	 * @see		#getConnectionMode
	 * @see		#smartConnect
	 * @see		#socketConnectionTimeout
	 * @see		#onConnection
	 * 
	 * @history	SmartFoxServer Pro v1.6.0 - BlueBox connection attempt in case of socket connection not available.
	 * 
	 * @version	SmartFoxServer Lite (except BlueBox connection) / Basic (except BlueBox connection) / Pro
	 */
	public function connect(ipAdr:String, port:Number):Void
	{
		if (!isConnected)
		{
			this.ipAddress = ipAdr
			this.port = port
			super.connect(ipAdr, port)
			
			socketConnectionTimeoutThread = setInterval( Delegate.create(this, socketTimeoutHandler), socketConnectionTimeout )
		}
		else
		{
			trace("WARNING! You're already connected to -> " + this.ipAddress + ":" + this.port)
		}
	}
	
	/**
	 * Close the current connection to SmartFoxServer.
	 * 
	 * @return	Nothing. Causes the {@link #onConnectionLost} handler to be called in response.
	 * 
	 * @example	The following example shows how to disconnect from SmartFoxServer.
	 * 			<code>
	 * 			smartFox.disconnect()
	 * 			</code>
	 * 
	 * @see		#connect
	 * @see		#onConnectionLost
	 * 
	 * @version	SmartFoxServer Lite / Basic / Pro
	 */
	public function disconnect():Void
	{
		close()
		isConnected = false
		
		if (isHttpMode)
		{
			httpConnection.close()
		}
		
		initialize()
		
		onConnectionLost()
	}
	
	
	
	private function xmlReceived(message:XML):Void
	{
		var xmlObj:Object = new Object();
	
		message2Object(message.childNodes, xmlObj)
	
		if (this.debug)
			trace("[Received]: " + message)
	
		// get Handler
		var id:String = xmlObj.msg.attributes.t
	
		messageHandlers[id].handleMessage(xmlObj.msg.body, this, "xml")
	}
	
	private function socketTimeoutHandler():Void
	{
		clearInterval( socketConnectionTimeoutThread )
		this.close()
	}
	
	// Update 'brother' user objects
	private function globalUserVariableUpdate(user:User):Void
	{
		var id:Number = user.getId()
		
		for (var key:String in this.roomList)
		{
			var room:Room = this.roomList[key]
			var brother:User = room.getUser(id)
			
			if (brother != undefined && brother != user)
				brother["variables"] = user["variables"]
		}
	}
	
	private function checkRoomList():Boolean
	{
		var success:Boolean = true
		
		var count:Number = 0
		for (var j in roomList)
		{
			count++
			break
		}
		
		if (count == 0)
		{
			success = false
			errorTrace("The room list is empty!\nThe client API cannot function properly until the room list is populated.\nPlease consult the documentation for more infos.")
		}
		
		return success
	}
	
	private function checkJoin():Boolean
	{
		var success:Boolean = true
		
		if (activeRoomId < 0)
		{
			success = false
			errorTrace("You haven't joined any rooms!\nIn order to interact with the server you should join at least one room.\nPlease consult the documentation for more infos.")
		}
		
		return success
	}

	private function errorTrace(msg:String):Void
	{
		trace("\n****************************************************************")
		trace("Internal error:")
		trace(msg)
		trace("****************************************************************")
	}
	
	
	//-----------------------------------------------------------------------------------
	// Handle string message from server
	//-----------------------------------------------------------------------------------
	private function strReceived(message:String):Void
	{
		var params:Array = message.substr(1, message.length - 2).split(rawProtocolSeparator)
	
		if (this.debug)
			trace("[Received - Str]: " + message)
		
		// get Handler
		var id:String = params[0]

		// the last parameter specify that we have a string formatted message
		messageHandlers[id].handleMessage(params.splice(1, params.length -1), this, "str")
	}
	
	private function jsonReceived(message:String):Void
	{
		var jso = it.gotoandplay.smartfoxserver.JSON.parse(message)
		
		if (this.debug)
			trace("[Received - json]: " + message)
			
		var id:String = jso["t"]
		messageHandlers[id].handleMessage(jso["b"], this, "json")
		
	}
	
	
	/**
	 * Message Parser: parses the xml message into an Actionscript Object.
	 * 
	 * Retrieve attributes = xmlObj.node.attributs.attrName
	 * Retrieve tag value  = xmlObj.node.value
	 * 
	 * @exclude
	 */
	public function message2Object(xmlNodes, parentObj):Void
	{
		// counter
		var i = 0
		var currObj = null
	
		while(i < xmlNodes.length)
		{
			// get first child inside XML object
			var node	= xmlNodes[i]
			var nodeName	= node.nodeName
			var nodeValue	= node.nodeValue
	
			// Check if parent object is an Array or an Object
			if (parentObj instanceof Array)
			{
				currObj = {}
				parentObj.push(currObj)
				currObj = parentObj[parentObj.length - 1]
	
			}
			else
			{
				parentObj[nodeName] = new Object()
				currObj = parentObj[nodeName]
			}
	
			//-------------------------------------------
			// Save attributes
			//-------------------------------------------
			for (var att in node.attributes)
			{
				if (typeof currObj.attributes == "undefined")
					currObj.attributes = {}
	
				var attVal = node.attributes[att]
	
				// Check if it's number
				if (!isNaN(Number(attVal)))
					attVal = Number(attVal)
	
				// Check if it's a boolean
				if (attVal.toLowerCase() == "true")
					attVal = true
			
				else if (attVal.toLowerCase() == "false")
					attVal = false
	
				// Store the attribute
				currObj.attributes[att] = attVal
			}
	
			// If this node is present in the arrayTag Object
			// then a new Array() is created to hold its memebers
			if (this.arrayTags[nodeName])
			{
				currObj[nodeName] = []
				currObj = currObj[nodeName]
			}
	
			// Check if we have more subnodes
			if (node.hasChildNodes() && node.firstChild.nodeValue == undefined)
			{
				// Call this function recursively until node has no more children
				var subNodes = node.childNodes
				message2Object(subNodes, currObj)
			}
			else
			{
				nodeValue = node.firstChild.nodeValue

				if (!isNaN(nodeValue) && node.nodeName != "txt" && node.nodeName != "var")
					nodeValue = Number(nodeValue)

				currObj.value = nodeValue
			}
	
			i++
		}
	
	}
	
	
	
	private function makeHeader(headerObj:Object):String
	{
		var xmlData:String = "<msg"
	
		for (var item in headerObj)
		{
			xmlData += " " + item + "='" + headerObj[item] + "'"
		}
	
		xmlData += ">"
	
		return xmlData
	}
	
	
	
	private function closeHeader():String
	{
		return "</msg>"
	}
	
	// -------------------------------------------------------
	// Internal Http Event Handlers
	// -------------------------------------------------------
	
	/*
	* Handle delayed poll request
	* We use setInterval for FlashPlayer < 8, setTimout for later versions
	*/
	private function handleDelayedPoll():Void
	{
		httpConnection.send( HTTP_POLL_REQUEST ) 

		if ( this.fpMajorVersion < 8 )
			clearInterval( pollingThread )
	}
	
	private function handleHttpConnect(params:Object):Void
	{
		isConnected = true
		preConnection = false
		connectionEstablished(true)
		httpConnection.send(HTTP_POLL_REQUEST)
	}
	

	private function handleHttpClose(params:Object):Void
	{
		// Clear data
	 	initialize()

	 	// Fire event
		onConnectionLost()		
	}
	
	private function handleHttpData(params:Object):Void
	{
		var data:String = params.data
		var messages:Array = data.split("\n")
		var message:String
		
		/* debug only
		if (messages[0] != "ok" && this.debug)
			trace("HTTP DATA ---> " + messages + " (len: " + messages.length + ")")
		*/

		for (var i:Number = 0; i < messages.length - 1; i++)
		{
			message = messages[i]
			
			if (message.length > 0)
				gotData(message)
		}
		
		/*
		*	Sleep a little before sending next poll request
		*	WARNING: without delay the server may use too many requests
		*/
		if (this._httpPollSpeed > 0)
		{
			this.pollingThread = this.pollingDelayFn( Delegate.create( this, this.handleDelayedPoll ), this._httpPollSpeed )
		}
		else
		{
			httpConnection.send(HTTP_POLL_REQUEST)
		}
		
	}
	
	private function handleHttpError(params:Object):Void
	{
		if (!isConnected)
			onConnection(false)		
		else
			connectionClosed()
	}
}