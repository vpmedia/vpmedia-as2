/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Canvas.as 698 2007-02-26 21:59:46Z allens $
 */

import mx.utils.Delegate;
import mx.transitions.*;
import mx.transitions.easing.*;

import com.stamen.data.Hash;
import com.stamen.utils.MathExt;
import com.stamen.utils.DateExt;
import com.stamen.display.*;
import com.digg.geo.*;

import com.digg.fdk.model.*;
import com.digg.fdk.view.*;
import com.digg.fdk.view.path.*;
import com.digg.fdk.view.controls.TextButton;
import com.digg.fdk.controller.Controller;

class com.digg.fdk.view.Canvas extends ViewObject
{
    public var storyClips:Hash;
    public var sortedStoryClips:Array;
    public var storyStage:MovieClip;
    public var userClips:Hash;
    public var userStage:MovieClip;

    public var model:Model;
    public var controller:Controller;

    public var maxStories:Number = 100;

    public var minWidth:Number = Stage.width;
    public var minHeight:Number = Stage.height;

    public var pathParams:Object;
    public var storyParams:Object;

    public var storyAttachHandler:Function;
    public var storyDetachHandler:Function;
    public var userAttachHandler:Function;
    public var userDetachHandler:Function;
    public var userArrivalHandler:Function;

    // public var navigator:MovieClip;
    public var fps:FPSCounter;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.Canvas';
    public static var symbolOwner:Function = Canvas;
    private static var symbolLink:Boolean = Object.registerClass(symbolName, symbolOwner);

    public var attachRate:Number = 50;
    public var modeAttachRates:Object = {spy: 500};

    private var resetting:Boolean = false;
    private var resetClearInterval:Number;
    private var transition:Transition;
    private var transitionOptions:Object;

    /**
     * Initialize. No graphics should be drawn until {@link attach()} is called.
     *
     * @return  Void
     */
    public function init():Void
    {
        super.init();

        storyClips = new Hash();
        sortedStoryClips = new Array();
        userClips = new Hash();

        createStoryStage();
        createUserStage();

        storyAttachHandler = Delegate.create(this, onStoryDoneAttaching);
        storyDetachHandler = Delegate.create(this, onStoryDoneDetaching);
        userAttachHandler = Delegate.create(this, onUserDoneAttaching);
        userDetachHandler = Delegate.create(this, onUserDoneDetaching);
        userArrivalHandler = Delegate.create(this, onUserDoneTraveling);

        Key.addListener(this);
        Stage.addListener(this);

        attachMovie(FPSCounter.symbolName, 'fps', getNextHighestDepth());

        transitionOptions = {type:         Fade,
                             direction:    Transition.IN,
                             duration:     2.0,
                             easing:       Regular.easeOut};
    }

    public function adjustStage():Void
    {
        Stage.scaleMode = 'noScale';
        Stage.align = 'TL';
    }

    /**
     * Key handler: starts and stops the controller when the spacebar is
     * pressed.
     */
    public function onKeyUp():Void
    {
        switch (Key.getCode())
        {
            case Key.SPACE:
                controller.toggle();
                break;
        }
    }

    /**
     * Create the stage that will contain StoryClip instances. By default, the
     * story stage is this.
     *
     * @return  Void
     */
    public function createStoryStage():Void
    {
        storyStage = this;
    }

    /**
     * Create the stage that will contain PathClip instances. By default, the
     * user stage is this.
     *
     * @return  Void
     */
    public function createUserStage():Void
    {
        userStage = this;
    }

    /**
     * Attach. This should start any intro animations, after which {@link
     * onDoneAttaching()} should be called.
     *
     * @return  Void
     */
    public function attach():Void
    {
        trace('Canvas.attach()');

        attachNavigator(_parent);
        onResize();
        
        transitionOptions.direction = Transition.IN;
        transition = TransitionManager.start(this, transitionOptions);

        // if the transition start failed, just notify the controller that we're
        // done attaching.
        if (null == transition || !transition.ID)
        {
            trace('TransitionManager.start() failed!');
            onDoneAttaching();
        }
        else
        {
            transition.addEventListener('transitionInDone', Delegate.create(this, onDoneAttaching));
        }
    }

    public function expire():Void
    {
        trace('*** Canvas.expire()');

        if (controller.running)
            controller.reset(false);

        resetExpirationInterval();
    }

    /**
     * Reset the display.
     *
     * @param   Boolean     immediate
     * @return  Void
     */
    public function reset(immediate:Boolean):Void
    {
        clearInterval(resetClearInterval);

        if (immediate)
        {
            trace('forced reset: clearing storyClips and userClips');

            for (var k:String in storyClips)
            {
                storyClips[k].detach();
            }

            for (var k:String in userClips)
            {
                userClips[k].detach();
            }
        }
        else
        {
            resetting = true;
            resetClearInterval = setInterval(this, 'resetClear', attachRate);
        }
    }

    /**
     *
     */
    private function resetClear():Void
    {
        trace('*** resetClear(): continuing...');

        var userKeys:Array = userClips.keys;
        if (userKeys.length > 0)
        {
            var userKey = userKeys.shift();
            // trace('detaching user: "' + userKey + '"');
            userClips[userKey].detach();
            userClips.deleteKey(userKey);
        }

        var storyKeys:Array = storyClips.keys;
        if (storyKeys.length > 0)
        {
            var storyKey = storyKeys.shift();
            // trace('detaching story: "' + storyKey + '"');
            storyClips[storyKey].detach();
            storyClips.deleteKey(storyKey);
        }

        checkDoneResetting();
    }

    /**
     * Check for whether or not we're done resetting. If we're in the process of
     * resetting ({@link reset()} was called) and the storyClips hash is empty,
     * a 'doneResetting' event is dispatched. This should be received by the
     * controller, which will then perform an immediate reset().
     *
     * @return  Void
     */
    public function checkDoneResetting():Boolean
    {
        if (resetting &&
            userClips.values.length == 0 &&
            storyClips.values.length == 0)
        {
            clearInterval(resetClearInterval);
            resetting = false;

            dispatchEvent({type: 'doneResetting'});
            return true;
        }
        else
        {
            // trace('Canvas.checkDoneResetting(): not done yet...');
            return false;
        }
    }

    /**
     * Attach the navigator.
     *
     * @param	MovieClip   where   the movie clip onto which the navigator
     *                              should be attached.
     * @return	Void
     */
    public function attachNavigator(where:MovieClip):Void
    {
        /*
        navigator = where.attachMovie(Navigator.symbolName, 'navigator',
                                           where.getNextHighestDepth());
        navigator.setSize(Stage.width / 8, 100);
        navigator.align = 'TR';
        navigator.setContent(this);
        */
    }

    /**
     * Get the visual representation of a user, if it exists.
     *
     * @param   User    user
     * @return  MovieClip       either a PathClip or DiggerClip instance, or
     *                          null if the user isn't represented yet.
     */
    public function getUserClip(user:User):MovieClip
    {
        // trace('Canvas.getUserClip(): looking for userClips[' + user.safeKey() + ']');
        return userClips[user.safeKey()];
    }

    /**
     * Get the visual reprentation of a story, if it exists.
     *
     * @param   Story   story
     * @return  StoryClip       a reference to the story's visual
     *                          representation, or null if no such clip exists.
     */
    public function getStoryClip(story:Story):StoryClip
    {
        // trace('Canvas.getStoryClip(): looking for storyClips[' + story.safeKey() + ']');
        return storyClips[story.safeKey()];
    }

    /**
     * Attach a digg to the view. This function serves to move the visual
     * representation of a user from one point to the next, based on certain
     * criteria:
     *
     * - if a visual representation already exists for the user of the digg, that
     *   representation's {@link com.digg.fdk.view.ViewObject.detach()}
     *   method is called. {@link onUserDoneDetaching()} will then remove that
     *   representation and query the model for the last digg by that user and
     *   pass it along to attachDigg() again.
     * - otherwise, the origin of the path is determined using {@link
     *   getOffstagePoint()}.
     *
     * - if the story listed in the digg doesn't have a visual representation,
     *   an off-stage point (see {@link getOffstagePoint()} is used as the
     *   destination of the user's path.
     * - otherwise, the destination is a point obtained using the StoryClip's
     *   {@link com.digg.fdk.view.StoryClip.attachPoint()} method.
     * 
     * @param   Digg     digg
     * @param	Point   origin      an optional origin. This is provided when
     *                              attachDigg() is called from {@link
     *                              onUserDoneDetaching()}, and should be the
     *                              point at which the previous representation
     *                              of the user was when it detached (for
     *                              instance, the destination of a path from one
     *                              story to the next).
     * @return 	Void
     */
    public function attachDigg(digg:Digg, origin:Point):Boolean
    {
        if (resetting)
        {
            // error('Canvas.attachDigg(): resetting, skipping attachment.');
            return false;
        }

        // this should either be an instance of PathClip or DiggerClip
        var digger:MovieClip = getUserClip(digg.user);

        // trace('Canvas.attachDigg(): digg = ' + digg);
        var story:Story = digg.story;

        // trace('Canvas.attachDigg(): story = "' + story.title + '", (id = ' + story.id + ')');

        /*
         * If digger exists, detach him.
         */
        if (digger)
        {
            var clip:StoryClip = getStoryClip(digg.story);
            if (null != clip &&
                (clip == digger._parent || clip == digger.destination.context))
            {
                trace('Canvas.attachDigg(): already digging story: ' + digg.story);
                return false;
            }
            // trace('Canvas.attachDigg(): telling digger ' + digger + ' to detach()');
            digger.detach();
            return true;
        }
        else
        {
            var storyClip:StoryClip = getStoryClip(digg.story);
            var destination:Point;

            // trace('Canvas.attachDigg(): got storyClip ' + storyClip);
            if (storyClip)
            {
                destination = storyClip.attachPoint(origin);

                if (null == origin)
                {
                    // trace('Canvas.attachDigg(): creating off-stage origin');
                    origin = getOffstagePoint(destination);
                }
                else
                {
                    // trace('Canvas.attachDigg(): using origin: ' + origin);
                }
            }
            else
            {
                if (null == origin)
                {
                    error('Canvas.attachDigg() attempted attachment without origin and no storyClip');
                    return false;
                }
                destination = getOffstagePoint(origin);
            }

            var symbolName:String = pathSymbol(origin, destination);
            
            if (null == symbolName)
            {
                if (storyClip)
                {
                    // trace("Canvas.attachDigg(): no pathSymbol, attaching immediately to storyClip: " + storyClip);
                    storyClip.attachUser(digg.user, destination);
                    var d:DateExt = new DateExt();
                    storyClip.lastDiggTime = d.toTimestamp();
                    return true;
                }
                else
                {
                    error("no pathSymbol and no storyClip destination, discarding digg");
                    return false;
                }
            }
            else
            {
                // trace('attaching path...');
	            attachPath(digg.user, origin, destination, symbolName);
                return true;
            }
        }
    }
    
	/**
	 * Get the library symbol name for a path from one point to another. If this
     * is null, no paths will be created; the user representations will be
     * attached directly onto each story that is dug.
     *
	 * @param	Point   origin
	 * @param	Point   destination
	 * @return	String
     */
    public function pathSymbol(origin:Point, destination:Point):String
    {
        return PathClip.symbolName;
    }

    /**
     * Event handler for DiggerClip 'doneDetaching', bubbles up from
     * StoryClip.onUserDoneDetaching().
     *
     * @param   Object  event
     * @return  Void
     */
    public function onUserDoneDetaching(event:Object):Void
    {
        var clip:MovieClip = event.target;
        // trace('Canvas.onUserDoneDetaching(): ' + clip);
        var user:User = clip.user;
        var origin:Point = clip.point();

        // navigator.stopTracking(clip);
        clip.removeMovieClip();
        delete clip;
        userClips.deleteKey(user.safeKey());

        /*
         * If the user expired, create a dummy digg with a null story property
         * and clear the user's digg history from the model so that the next call
         * to {@link com.digg.fdk.model.Model.getLastUserDigg()} will return
         * null.
         */
        var digg:Digg;
        if (event.reason == 'expired')
        {
            digg = new Digg({user: user, story: null});
            model.removeUserDiggs(user);
        }
        /*
         * Otherwise, just get the user's last digg and pass that along.
         */
        else
        {
            digg = model.getLastUserDigg(user);
        }

        if (digg)
        {
            // trace('Canvas.onUserDoneDetaching(): attaching new digg!');
            attachDigg(digg, origin);
        }

        // check for whether or not we're done resetting.
        checkDoneResetting();
    }
 
	/**
	 * Handler for both DiggerClip and PathClip's 'doneAttaching' event.
	 * When the is done attaching, it is added to the userClips hash as a representation of
	 * its 'user' member.
	 * 
	 * @param	Object  event   the 'target' property of the event should be a
     *                          reference to the visual reprsentation of a user
     *                          that's done attaching. Both the DiggerClip and
     *                          PathClip classes define a 'user' property which
     *                          is a reference to the model User object that the
     *                          clip represents.
	 * @return	Void
     */
    public function onUserDoneAttaching(event:Object):Void
    {
        var clip:MovieClip = event.target;
        var user:User = clip.user;
        if (user)
        {
	        // trace('Canvas.onUserDoneAttaching(): clip = ' + clip + ', user = ' + user);
	        userClips.setValue(user.safeKey(), clip);
	        // navigator.startTracking(clip, 0xFFFF00);
        }
    }

    /**
     * Handler for PathClip's 'doneTraveling' event. When a path has finished
     * traveling, we query the model for the story that the user is supposed to
     * be digging, and tell the corresponding StoryClip instance to attach that
     * user.
     * 
     * @param	Object  event   the 'target' property of the event should be a
     *                          reference to a PathClip instance, which should
     *                          in turn define a destination point (supplied to
     *                          {@link attachPath()} by {@link attachDigg()}).
     * @return	Void
     */
    public function onUserDoneTraveling(event:Object):Void
    {
        var clip:MovieClip = event.target;
        var user:User = clip.user;
        // trace('Canvas.onUserDoneTraveling(): user = ' + user);
        var digg:Digg = model.getLastUserDigg(user);
        var destination:Point = clip.destination;

        clip.removeMovieClip();
        userClips.deleteKey(user.safeKey());

        // path has a destination that is a story
        if (digg && digg.story)
        {
            var storyClip:StoryClip = getStoryClip(digg.story);
            // if the destination of the path is different...
            if (!storyClip)
            {
                // trace('Canvas.onUserDoneTraveling(): done with path to non-existent story');
                return;
            }

            /*
             * Climb up movie clip hierarchy to find the StoryClip instance.
             * This is done so that the destination point's context can refer to
             * a child of the StoryClip.
             */
            var found:Boolean = destination.context == storyClip;
            if (!found)
            {
                var parent:MovieClip = destination.context;
                while (parent = parent._parent)
                {
                    if (parent == storyClip)
                    {
                        found = true;
                        break;
                    }
                }
            }

            if (!found)
            {
                error('Canvas.onUserDoneTraveling(): destination story is not dug story: ' +
                           destination.context + ' vs. ' + storyClip);
                destination = storyClip.attachPoint();
            }

            // trace('Canvas.onUserDoneTraveling(): attaching to ' + storyClip + ' at ' + destination);
            var newClip:MovieClip = storyClip.attachUser(user, destination);
            userClips.setValue(user.safeKey(), newClip);
        }
        else
        {
            /*
            if (!digg) trace('Canvas.onUserDoneTraveling(): no digg!');
            else trace('Canvas.onUserDoneTraveling(): no story! digg = ' + digg);
            */
        }
    }

    /**
     * Attach a path representing a user's movement from one point to another.
     *
     * @param   User    user
     * @param   Point   origin
     * @param   Point   destination
     * @param   String  symbolName
     * @return  MovieClip               should be a PathClip instance
     */
    public function attachPath(user:User, origin:Point, destination:Point,
                               symbolName:String):MovieClip
    {
        var inst:String = 'path_' + user.safeKey();
        if (null == symbolName) symbolName = PathClip.symbolName;
        // trace('Canvas.attachPath(): attaching symbol "' + symbolName + '" with instance name "' + inst + '"');

        var params:Hash = new Hash({user:           user,
                                    origin:         origin,
                                    destination:    destination,
                                    canvas:         this});
        params.update(pathParams);

        var path:MovieClip = userStage.attachMovie(symbolName, inst,
                                                   userStage.getNextHighestDepth(),
                                                   params);

        path.addEventListener('doneAttaching', userAttachHandler);
        path.addEventListener('doneDetaching', userDetachHandler);
        path.addEventListener('doneTraveling', userArrivalHandler);
        path.attach();
        return path;
    }
    
	/**
	 * Get a point off-stage, to which users that are either expiring or digging
     * non-existant stories can travel to.
	 * 
	 * @param	Point   orign   an optional origin. This can be used to create a
     *                          path that leads from the closest edge of the
     *                          screen.
	 * @return	Point
     */
    public function getOffstagePoint(origin:Point):Point
    {
        var angle:Number = MathExt.radians(Math.random() * 360);
        var radius:Number = Math.max(__width, __height) / 2 + Math.random() * 100;
        var polar:PolarCoordinate = new PolarCoordinate(angle, radius);
        var cartesian:Point = polar.toCartesian();
        return new Point(__width / 2 + cartesian.x,
                         __height / 2 + cartesian.y,
                         this);
    }

	/**
	 * Throw an error. FIXME: this function should provide some visual feedback
     * that something went wrong.
     *
     * @param   String  message
     * @return  Void
     */
    public function error(message:String):Void
    {
        trace('*** ERROR: ' + message);
    }

    /**
     * Create a visual representation of a story.
     *
     * @param   Story   story
     * @param   String  symbolName
     * @return  Void
     */
    public function attachStory(story:Story):Void
    {
        if (getStoryClip(story))
        {
            trace('Canvas.attachStory(): story already exists: ' + story);
            return;
        }
        else if (resetting)
        {
            trace('Canvas.attachStory(): resetting, skipping attachment.');
            return;
        }

        var inst:String = story.safeKey();
        this[inst] = null;
        delete this[inst];
        // trace('Canvas.attachStory(): attaching ' + story + ' with instance name "' + inst + '"');

        story.inView = true;

        var params:Hash = new Hash({story: story, canvas: this});
        params.update(storyParams);

        var symbolName:String = storySymbol(story);
        var clip:MovieClip = storyStage.attachMovie(symbolName, inst,
                                                         storyStage.getNextHighestDepth(),
                                                         params);

        clip.addEventListener('doneAttaching', storyAttachHandler);
        clip.addEventListener('doneDetaching', storyDetachHandler);
        clip.addEventListener('doneAttachingUser', userAttachHandler);
        clip.addEventListener('doneDetachingUser', userDetachHandler);

        storyClips.setValue(story.safeKey(), clip);
        // navigator.startTracking(clip, 0xFF0000);
        clip.attach();

        // re-arrange stories
        sortStoryClips();
        arrangeStoryClips();
    }

    /**
     * Get the symbol appropriate for representing a story. This could change
     * based on category, for instance.
     *
     * @param   Story   story   an instance of com.digg.fdk.model.Story
     * @return  String          the name of a symbol in the library that,
     *                          presumably, subclasses StoryClip
     */
    public function storySymbol(story:Story):String
    {
        return StoryClip.symbolName;
    }
    
	/**
	 * This is the handler for StoryClip's 'doneAttaching' event.
	 * @return	Void
     */
    public function onStoryDoneAttaching(event:Object):Void
    {
        // trace('Canvas.onStoryDoneAttaching(): ' + event.target);
    }

	/**
	 * This is called as a handler for StoryClip's 'doneDetaching' event.
	 * It removes the story clip instance and its reference in the storyClips hash.
	 * @param	event	Object
	 * @return	Void
     */
    public function onStoryDoneDetaching(event:Object):Void
    {
        var clip:StoryClip = event.target;

        var story:Story = clip.story;
        story.inView = false;

        trace('Canvas.onStoryDoneDetaching(): removing ' + clip);
        // navigator.stopTracking(clip);
        clip.removeMovieClip();

        // let the controller know that it's done
        dispatchEvent({type: 'storyRemovedFromView', story: story});

        storyClips.deleteKey(story.safeKey());
        // re-arrange stories
        sortStoryClips();
        arrangeStoryClips();
        checkDoneResetting();
    }

    /**
     * Sort the stories.
     *
     * @param   Function    sortFunc    a comparison function suitable for use
     *                                  with Array.sort().
     * @return  Array
     */
    public function sortStoryClips(sortFunc:Function):Void
    {
        sortedStoryClips = storyClips.values;

        if (sortFunc)
            sortedStoryClips.sort(sortFunc);

        if (isFinite(maxStories) && sortedStoryClips.length > maxStories)
        {
            var num:Number = sortedStoryClips.length - maxStories;
            for (var i:Number = 0; i < num; i++)
            {
                // trace('sortedStoryClips(): detaching sortedStoryClips[' + i + ']', 3);
                sortedStoryClips[i].detach();
            }

            sortedStoryClips = sortedStoryClips.slice(num - 1);
        }
    }

    /**
     * Get a list of story clips, sorted using a function that compares Story
     * objects. First, a list of the stories in the model is obtained and
     * sorted. This list is filtered according to whether or not visual
     * representations for the stories exist (using {@link getStoryClip()}), and
     * the resulting array is returned.
     *
     */
    public function getStoryClips():Array
    {
        return sortedStoryClips;
    }

    /**
     * Update the loading status of the controller. By default, this does
     * nothing.
     */
    public function updateLoadingStatus():Void
    {
    }

    /**
     * Arrange stories on the canvas. By default, stories arrange themselves with {@link StoryClip.place()}.
     * @return	Void
     */
    public function arrangeStoryClips(snap:Boolean):Void
    {
    }

	/**
	 * This is the event handler for Stage.onResize().
	 * @return	Void
     */
    public function onResize():Void
    {
        setSize(Math.max(minWidth, Stage.width),
                     Math.max(minHeight, Stage.height));
    }
    
	/**
	 * This function is called by {@link UIObject.setSize()}. Changes in the size of the canvas should always be handled here.
	 * @return	Void
     */
    public function size():Void
    {
        draw();
        arrangeStoryClips(true);

        // navigator._visible = !(__width == Stage.width && __height == Stage.height);
        // navigator.size();
    }
	
	/**
	 * Draw the background. By default, it's a nice blue gradient.
     */
    public function draw():Void
    {
        var mask:MovieClip = mask();
        mask.clear();
        drawGradient(mask,
                     [0xCCEEFF, 0x99CCFF, 0x336699],
                     [100, 100, 100],
                     [16, 64, 255]);
    }

    /**
     * Show a dialog.
     * @param   params  dialog parameters
     */
    public function showDialog(params:Object):Dialog
    {
        var dialog:Dialog = Dialog(attachMovie(Dialog.symbolName, 'dialog',
                                               getNextHighestDepth(),
                                               params));
        if (params.title)
            dialog.title = params.title;
        if (params.body)
            dialog.body = params.body;

        for (var b:String in params.buttons)
        {
            var button:TextButton = TextButton(dialog.addButton(b));
            button.label = params.buttons[b];
            if (params.buttonSize)
            {
                button.setSize(params.buttonSize[0], params.buttonSize[1]);
            }
        }

        dialog.attach();
        return dialog;
    }

	/**
	 * Convenience method for drawing a gradient background on a movie clip.
	 * @param	obj
	 * @param	colors
	 * @param	alphas
	 * @param	distributions
	 * @param	angle
	 * @return	Void
	 * @see		com.stamen.display.Draw.gradient()
	 */
    public function drawGradient(obj:MovieClip, colors:Array, alphas:Array,
                                 distributions:Array, angle:Number):Void
    {
        var bounds:Object = {x: 0, y: 0,
                             w: __width,
                             h: __height,
                             angle: angle};

        Draw.gradient(obj, 'linear', colors, alphas, distributions, bounds);
        Draw.rect(obj, bounds.x, bounds.y, bounds.w, bounds.h);
        obj.endFill();
    }

    /**
     * The onUnload() handler is called when the canvas is deleted. Since the
     * navigator may be attached to a different parent, we need to also remove
     * it.
     *
     * @return  Void
     */
    public function onUnload():Void
    {
        Stage.removeListener(this);
        // navigator.removeMovieClip();
    }
}
