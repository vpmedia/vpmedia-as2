/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Controller.as 698 2007-02-26 21:59:46Z allens $
 */

import org.json.JSON;
import com.stamen.data.*;
import com.stamen.utils.DateExt;
import com.stamen.utils.MathExt;
import com.digg.fdk.model.*;
import com.digg.fdk.view.*;
import com.digg.services.*;

import mx.utils.Delegate;

class com.digg.fdk.controller.Controller implements com.digg.fdk.interfaces.IController
{
    public var model:Model;
    public var view:Canvas;

    public static var MODE_SPY:String = 'spy';
    public static var MODE_POPULAR:String = 'popular';
    public static var MODE_UPCOMING:String = 'upcoming';

    /**
     * @param   mode            Valid values are 'spy', 'popular', and
     *                          'upcoming'.
     */
    public var mode:String = MODE_SPY;
    public var storyType:String;

    /**
     * @var     requestParams   Parameters for the initial API call. The
     *                          'promoted' key indicates whether or not only
     *                          promoted stories will be represented visually,
     *                          and 'count' indicates the number of either
     *                          stories or diggs (based on the current mode) to
     *                          fetch the first time.
     */
    public var requestParams:Object = {count: 10};

    /**
     * @var     requestOffset   The number of seconds by which to offset
     *                          'min_date' timestamps used in API requests.
     *                          THIS IS A FUDGE FACTOR!
     */
    public var requestOffset:Number = -10;
    public var maxDiggsPerRequest:Number = 30;
    public var maxStoriesPerRequest:Number = 100;
    public var attachRate:Number = 500;

    public static var DEQUEUE_NONE:Number = 0x0;
    public static var DEQUEUE_STORIES:Number = 0x2;
    public static var DEQUEUE_DIGGS:Number = 0x4;
    public static var DEQUEUE_ALL:Number = DEQUEUE_STORIES | DEQUEUE_DIGGS;
    public var dequeueMode:Number = 0x2 | 0x4;

    public var maxStoriesPerDequeue:Number = 1;
    public var maxDiggsPerDequeue:Number = 1;

    /**
     * @var     running     Whether or not the controller is periodically
     *                      fetching new content. Do not set this variable;
     *                      instead, call the controller's {@link start()} and
     *                      {@link stop()} methods.
     */
    public var running:Boolean = false;

    /**
     * @var     timestampQuantize   The number of seconds by which to quantize
     *                              the date parameters of each digg and story
     *                              request.
     */
    private var timestampQuantize:Number = 10;

    /**
     * @var     requestRate     The number of milliseconds between timed
     *                          requests.
     */
    private var requestRate:Number = 10000;

    /**
     * @var     storyRequestTime    getTimer()'s value when the last story
     *                              request went out.
     */
    private var storyRequestTime:Number;

    /**
     * @var     responseTime    The amount of time we assume that it will take
     *                          for responses to come back from the server. This
     *                          number is averaged out as responses finish.
     */
    private var responseTime:Number = 2000;
    /**
     * @var     maxResponseTime     Don't factor responses that come back after
     *                              more than this many milliseconds.
     */
    private var maxResponseTime:Number = 5000;

    private var requestInterval:Number;
    private var lastRequestTime:Number;
    private var nextRequestTime:Number;

    /**
     * @var     storyRequests   Outbound requests for individual story data.
     */
    private var storyRequests:Hash;
    private var deferredStoryDiggs:Hash;
    private var now:DateExt;

    public var queuedStories: /*Story*/ Array;
    public var queuedDiggs: /*Digg*/ Array;

    /**
     * @var     pauseRate       The number of ms that have to elapse before we
     *                          pause the controller. The default is 5 minutes.
     */
    public var pauseRate:Number = 1800000;
    private var pauseInterval:Number;

    /**
     * @var     dialogParams    Default parameters for the stop dialog.
     */
    private var dialogParams:Object = {title:       'Paused',
                                       body:        "We\'ve stopped updating this screen with new information, to help prevent the Internet tubes from being clogged.",
                                       button_yes : 'Clog on!'};
    private var dialog:Dialog;

    // for MovieClip.addListener()
    public var onEnterFrame:Function;

    public function Controller()
    {
        reset();
    }

    /**
     * This is a workaround for the Flash IDE's restriction on calling trace()
     * with more than one argument.
     */
    private function debug(msg:String, level:Number):Void
    {
        trace(msg, level);
        // trace.call(arguments);
    }

    /**
     * Make the supplied MovieClip our view, add event listeners, then call its
     * attach() method.
     */
    public function setView(view:Canvas):Void
    {
        // debug('Controller.setView(): got ' + view);
        this.view = view;
        view.model = model;
        view.controller = this;

        view.addEventListener(View.EVENT_DONE_ATTACHING, Delegate.create(this, onViewDoneAttaching));
        view.addEventListener(View.EVENT_DONE_RESETTING, Delegate.create(this, onViewDoneResetting));
        view.addEventListener(View.EVENT_REMOVED_STORY, Delegate.create(this, onViewDoneRemovingStory));
    }

    /**
     * Call a function once after a given number of milliseconds.
     *
     * @TODO: com.stamen.time.Timeout decoration
     *
     * @param   fn          the function to call.
     * @param   timeout     the number of milliseconds to wait before calling
     *                      the function.
     */
    public function setTimeout(fn:Function, timeout:Number):Number
    {
        var id:Number;
        var context:Controller = this;
        var args:Array = arguments.slice(2);
        var func:Function = function():Void
        {
            // debug('setTimeout(): expired after ' + timeout + 'ms, calling ' + fn + ' with args: ' + args);
            fn.apply(context, args);
            clearInterval(id);
        };
        id = setInterval(func, timeout, args);
        return id;
    }

    /**
     * Set the controller's mode. This forces a reset.
     *
     * @param   mode    the new mode ('spy', 'incoming', 'popular', etc.)
     * @return          true if the mode was set successfully, false otherwise.
     */
    public function setMode(mode:String):Boolean
    {
        debug('*** Controller.setMode(' + mode + ', ' + JSON.stringify(requestParams) + ')', 2);

        this.mode = mode;
        reset(false);
        return true;
    }

    /**
     * Start requesting content from the API and dequeueing diggs and stories.
     */
    public function start():Void
    {
        debug('*** Controller.start(): mode = "' + mode + '"', 1);

        if (dialog)
        {
            dialog.detach();
            delete dialog;
        }

        startRequesting();
        startDequeueing();
        running = true;

        view.updateLoadingStatus();
    }

    /**
     * Stop requesting content from the API and dequeueing diggs and stories.
     */
    public function stop():Void
    {
        stopRequesting();
        stopDequeueing();
        running = false;

        view.updateLoadingStatus();
    }

    /**
     * For BC.
     */
    public function pause(params:Object):Void
    {
        stopWithDialog(params);
    }

    /**
     * For BC.
     */
    public function unpause():Void
    {
        start();
    }

    public function toggle():Void
    {
        if (running)
        {
            stop();
        }
        else
        {
            start();
        }
    }

    /**
     * Stop with a dialog.
     *
     * @param   params  Dialog parameters. Properties with the prefix 'button_'
     *                  are munged into the 'buttons' property (because,
     *                  apparently, the JavaScript serializer is shit).
     */
    public function stopWithDialog(params:Object):Void
    {
        stop();

        if (dialog)
            dialog.detach();

        if (null == params)
        {
            params = dialogParams;
        }
        
        if (params.buttons == undefined)
        {
            params.buttons = {};
        }
        
        for (var p:String in params)
        {
            if (p.substr(0, 7) != 'button_') continue;
            params.buttons[p.substr(7)] = params[p];
            delete params[p];
        }
        
        dialog = view.showDialog(params);
        dialog.addEventListener('dismissed', Delegate.create(this, onDialogDismissed));
    }

    /**
     * Initiate the timeout for pausing.
     */
    private function startPauseTimeout():Void
    {
        debug('startPauseTimeout: ' + pauseRate, 3);
        stopPauseTimeout();
        pauseInterval = setTimeout(pause, pauseRate);
    }

    private function stopPauseTimeout():Void
    {
        clearInterval(pauseInterval);
    }

    /**
     * Start requesting content from the API.
     */
    private function startRequesting(rate:Number):Void
    {
        updateRequestTimes();
        request();

        startPauseTimeout();
    }

    /**
     * Stop requesting content from the API.
     */
    private function stopRequesting():Void
    {
        clearInterval(requestInterval);
        stopPauseTimeout();

        // reset the response time
        responseTime = maxResponseTime;
    }

    /**
     * Request stories or diggs from the API.
     */
    private function request():Void
    {
        var requestFunction:Function;
        switch (mode)
        {
            case MODE_UPCOMING:
            case MODE_POPULAR:
                loadStories();
                break;
            case MODE_SPY:
            default:
                if (mode != MODE_SPY)
                {
                    error('INVALID MODE: ' + mode);
                    mode = MODE_SPY;
                }
        		loadDiggs();
        		break;
        }
    }

    /**
     * Update the timestamps for current and next requests, so that queue adds
     * can be spaced out properly.
     */
    private function updateRequestTimes():Void
    {
        lastRequestTime = getTimer();
        nextRequestTime = lastRequestTime + requestRate;
    }

    /**
     * Add a digg to the model and queue it for display.
     * @param   digg     the Digg object to queue.
     */
    private function queueDigg(digg:Digg):Void
    {
        queuedDiggs.push(digg);
    }


    /**
     * Add a story to the model and queue it for display.
     * @param   digg     the Digg object to queue.
     */
    private function queueStory(story:Story):Void
    {
        queuedStories.push(story);
        story.inQueue = true;
        queueDeferredStoryDiggs(story);
    }

    /**
     * Start dequeueing stories and diggs.
     */
    private function startDequeueing(dequeueMode:Number):Void
    {
        if (null != dequeueMode) this.dequeueMode = dequeueMode;
        MovieClip.addListener(this);
        onEnterFrame = dequeue;
    }

    /**
     * Stop dequeueing stories and diggs.
     */
    private function stopDequeueing():Void
    {
        MovieClip.removeListener(this);
        delete onEnterFrame;
    }

    /**
     * Dequeue stories and/or diggs.
     */
    private function dequeue():Void
    {
        if (dequeueMode & DEQUEUE_STORIES && queuedStories.length > 0)
        {
            // debug('# STORIES: ' + queuedStories.length);

            var count:Number = 0;
            while (count < maxStoriesPerDequeue && queuedStories.length > 0)
            {
                var story:Story = Story(queuedStories.pop());
                story.inQueue = false;
                // debug('attaching story: "' + story.title + '"', 1);
                view.attachStory(story);
                count++;
            }
        }

        if (dequeueMode & DEQUEUE_DIGGS && queuedDiggs.length > 0)
        {
            // debug('# DIGGS: ' + queuedDiggs.length);

            var requeuedDiggs:Array = new Array();

            var count:Number = 0;
            while (count < maxDiggsPerDequeue && queuedDiggs.length > 0)
            {
                var digg:Digg = Digg(queuedDiggs.pop());

                // attach the digg if its story is in view
                if (digg.story.inView)
                {
					// debug('attaching digg: ' + digg.id);
                    view.attachDigg(digg);
                    count++;
                }
                // otherwise, re-queue it if its story is still in the model
                else if (model.hasStory(digg.story))
                {
                    requeuedDiggs.push(digg);
                }
            }

            var t:Number = getTimer();
            while (requeuedDiggs.length > 0)
            {
                var digg:Digg = Digg(requeuedDiggs.pop());
                queuedDiggs.unshift(digg);
            }
        }
    }

    public function flushQueuedDiggs():Void
    {
        debug('flushing queued diggs', 1);
        delete queuedDiggs;
        queuedDiggs = new Array();
    }

    /**
     * Flush stories in the queue. These stories will never be attached.
     */
    public function flushQueuedStories():Void
    {
        debug('flushing queued stories', 1);
        delete queuedStories;
        queuedStories = new Array();
    }

    /**
     * Event handler for dialog dismissal. If the pressed button has an id of
     * 'yes', we start up again.
     *
     * @param   event
     */
    private function onDialogDismissed(event:Object):Void
    {
        // debug('onDialogDismissed(): got button id "' + event.button.id + '"');
        switch (event.button.id)
        {
            case 'no':
                break;

            case 'yes':
            default:
                start();
                break;
        }

        delete dialog;
    }

    /**
     * Reset the state of the application. This *should* return both the model
     * and view to an empty state, without having to forcibly delete and
     * re-attach the canvas.
     *
     * @param   immediate   whether or not the reset should be performed
     *                      forcibly. This argument is acted upon in {@link
     *                      Canvas.reset()}.
     */
    public function reset(immediate:Boolean):Void
    {
        debug('Controller.reset(' + immediate + ')', 2);

        var wasRunning:Boolean = running;
        if (running) stop();

        delete model;
        delete now;
        model = new Model();
        view.model = model;

        delete storyRequests;
        storyRequests = new Hash();

        delete deferredStoryDiggs;
        deferredStoryDiggs = new Hash();

        if (view)
            view.reset(immediate);

        queuedDiggs = new /*Digg*/Array();
        queuedStories = new /*Story*/Array();

        if (wasRunning) start();
    }

    /**
     * Fetch a list of diggs from the API.
     */
    private function loadDiggs():IResponse
    {
        var args:Object = {};
        if (now)
        {
            var minDate:Number = now.toTimestamp() + requestOffset;
            var maxDate:Number = minDate + Math.ceil(requestRate / 1000);

            args['min_date'] = minDate;
            args['max_date'] = maxDate;
        }
        else
        {
            // what to do here?
        }

        args['count'] = maxDiggsPerRequest;

        // debug('args = ' + JSON.stringify(args));

        var path:String = 'stories';
        var storyType:String = (storyType);
        if (mode == MODE_POPULAR || mode == MODE_UPCOMING)
        {
            storyType = mode;
        }
        if (storyType)
        {
            path += '/' + storyType;
        }
        path += '/diggs';

        var response:IResponse = API.request(path, args);
        response.addLoadListener(Delegate.create(this, onDiggsResponseLoaded));
        return response;
    }

    /**
     * Parse a diggs API response into Digg objects, and send them off to
     * {@link diggsLoaded()}.
     *
     * @param   event   an event object whose 'target' property is a reference
     *                  to the loaded Request.
     */
    private function onDiggsResponseLoaded(event:Object):Void
    {
        if (!running)
        {
            debug('Not running, discarding diggs!', 3);
            return;
        }

        var diggs:Array = new Array();
        var now:DateExt;

        var errorMessage:String = 'Failed to load diggs from the API';
        var fatal:Boolean = mode == MODE_SPY;
        if (event.success)
        {
            var body:XML = event.target.getBody();
            var root:XMLNode = body.firstChild;

            if (root.nodeName == 'error')
            {
                if (root.attributes['message'])
                {
                    errorMessage += ': "' + root.attributes['message'] + '"';
                }
                error(errorMessage, fatal);
                if (fatal) return;
            }
            else
            {
                // debug('Loaded XML:' + root.toString());
                now = DateExt.fromTimestamp(root.attributes['timestamp']);

                for (var child:XMLNode = root.firstChild; child; child = child.nextSibling)
                {
                    if (child.nodeName == 'digg')
                    {
                        var digg:Digg = Digg.fromXML(child, model);
                        diggs.push(digg);
                    }
                }
            }
        }
        else
        {
            debug('event.success == false!', 3);
            error(errorMessage, fatal);
            if (fatal) return;
        }

        diggsLoaded(diggs, now, false);
        event.target.cancel();
    }

    /**
     * Attach a list of diggs to the view.
     *
     * @param	Array   diggs        a list of {@link com.digg.fdk.model.Digg} objects.
     * @param	DateExt now         the timestamp used to determine the timeout for
     *                              each call to {@link diggLoaded()}.
     * @param   Boolean deferred    whether or not these diggs were loaded as the
     *                              result of a story request. If they were not
     *                              and the controller is in 'spy' mode, a
     *                              timeout is set for the function to be called
     *                              again.
     * @return	Void
     */
    private function diggsLoaded(diggs:Array, now:DateExt, deferred:Boolean):Void
    {
        var len:Number = diggs.length;
        if (deferred)
        {
            // debug('diggsLoaded(): loading ' + len + ' deferred diggs from story: "' + diggs[0].story.title + '"', 1);
        }
        else
        {
            // debug("diggsLoaded(): got " + len + " diggs", 1);
        }

        var deferredDiggs:Array = new Array();
        var attachableDiggs:Array = new Array();

        // debug('BEFORE: diggs.length = ' + model.diggs.length, 2);

        while (diggs.length > 0)
        {
            var digg:Digg = Digg(diggs.pop());
            // debug('processing digg: ' + digg.id);

            // don't bother attempting to add deferred diggs to the model again
            if (!deferred)
            {
                if (mode != MODE_SPY && !digg.story.inView && !digg.story.inQueue)
                {
                    // debug('discarding orphan digg: ' + digg.id);
                    continue;
                }
                else if (!model.addDigg(digg))
                {
                    error('unable to add duplicate digg: ' + digg.id);
                    continue;
                }
            }

            // if the story exists in the view, go ahead and queue it
            if (digg.story.inView || digg.story.inQueue)
            {
                attachableDiggs.push(digg);
            }
            else if (!deferred && mode == MODE_SPY)
            {
                // debug('deferring digg: ' + digg.id);
                deferredDiggs.push(digg);
            }
        }

        if (attachableDiggs.length > 0)
        {
            len = attachableDiggs.length;

            var minTime:Number = attachableDiggs[len - 1].time.toTimestamp();
            var maxTime:Number = attachableDiggs[0].time.toTimestamp();

            // debug('min/maxTime = ' + minTime + '/' + maxTime);
            var attachRate:Number = getAttachRate(len);
            var totalTime:Number = attachRate * len;

            var timeout:Number = 0;
            var i:Number = 0;

            while (attachableDiggs.length > 0)
            {
                var digg:Digg = Digg(attachableDiggs.shift());

                if (false)
                {
                    // scale timestamps across the total amount of time that
                    // should elapse between requests
                    var t:Number = digg.time.toTimestamp();
                    timeout = MathExt.scaleMinMax(t, minTime, maxTime) * totalTime;
                    // debug('timeout for diggs[' + i + '] = ' + timeout + ' (t = ' + t + ')');
                }

                if (true)
                {
                    // randomize the ones in the middle
                    if (i > 0 && i < (len - 1))
                    {
                        timeout += MathExt.random(-0.75, 0.75) * attachRate;
                    }
                }

                setTimeout(queueDigg, timeout, digg);
                timeout += attachRate;
                i++;
            }
        }

        var numDeferred:Number = deferredDiggs.length;
        if (numDeferred > 0)
        {
            debug('got ' + numDeferred + ' deferred diggs...', 1);
            var ids:Array = new Array();
            while (deferredDiggs.length > 0)
            {
                var digg:Digg = Digg(deferredDiggs.shift());
                var storyID:Number = digg.story.id;
                var storyKey:String = digg.story.safeKey();

                if (!deferredStoryDiggs.hasKey(storyKey))
                {
                    ids.push(storyID);
                    deferredStoryDiggs.setValue(storyKey, new Array());
                }

                deferredStoryDiggs[storyKey].push(digg);
            }

            // debug('loading stories: ' + ids.join(', '));
            loadStories(ids);
        }

        if (mode == MODE_SPY && !deferred)
        {
            setNow(now);
            // debug('setting timeout for loadDiggs():' + requestRate);
            requestInterval = setTimeout(loadDiggs, requestRate);
        }
    }

    /**
     * Fetch individual story information from the API.
     *
     * @param   Story   story   a {@link com.digg.fdk.model.Story} object
     *                          with a valid 'id' member.
     */
    public function loadStory(story:Story):IResponse
    {
        if (storyRequests.hasKey(story.safeKey()))
        {
            // debug('*** Controller.loadStory(): using existing story request for story: ' + story.safeKey());
            return IResponse(storyRequests.getValue(story.safeKey()));
        }
 
        var path = 'story/' + story.id;
        var response:IResponse = API.request(path);
        response.addLoadListener(Delegate.create(this, onStoryResponseLoaded));

        storyRequests.setValue(story.safeKey(), response);

    	return response;
    }

    /**
     * Parse a response for a single story's info, and update the story in the
     * model with the new Story object's properties.
     *
     * @param   event   an event object whose 'target' property is a reference
     *                  to the loaded Request.
     */
    private function onStoryResponseLoaded(event:Object):Void
    {
        if (event.success)
        {
            var body:XML = event.target.getBody();
            var story:Story = Story.fromXML(body.firstChild.firstChild, model);
            debug("*** Request.loadStory(): story loaded: " + story.id);

            var updated:Boolean = model.stories[story.safeKey()].update(story);
            // debug('*** updated story? ' + updated);
            storyRequests.deleteKey(story.safeKey());
        }
        else
        {
            error("Failed to load story data from the digg API");
        }

        event.target.cancel();
    }

    /**
     * Dequeue diggs deferred because the story wasn't yet available.
     *
     * @param   story   the story
     */
    private function queueDeferredStoryDiggs(story:Story):Void
    {
        var diggs:Array = deferredStoryDiggs.getValue(story.safeKey());
        if (diggs.length > 0)
        {
            var len:Number = diggs.length;
            for (var i:Number = 0; i < len; i++)
                diggs[i].story = story;

            diggsLoaded(diggs, null, true);

            deferredStoryDiggs.deleteKey(story.safeKey());
        }
    }

    /**
     * Fetch a list of stories from the API. The paremeters for the API call are
     * based on the {@link requestParams} object.
     *
     * @return  Request
     */
    public function loadStories(ids:Array):IResponse
    {
        var path:String = 'stories';

        var args:Object = {};
        var sortKey:String = getSortKey();
        args['sort'] = sortKey + '_date-desc';

        if (ids.length > 0)
        {
            path += '/' + ids.join(',');
        }
        else
        {
            path += '/' + mode;

            if (now)
            {
                var minDate:Number = now.toTimestamp() + requestOffset;
                args['min_' + sortKey + '_date'] = minDate;
                args['max_' + sortKey + '_date'] = minDate + Math.ceil(requestRate / 1000);
            }
            else
            {
                args['count'] = Math.min(maxStoriesPerRequest, requestParams.count);

                if (isFinite(view.maxStories))
                {
                    args['count'] = Math.min(args['count'], view.maxStories);
                }
            }
        }

        // debug('args = ' + JSON.stringify(args));

        var response:IResponse = API.request(path, args);
        response.addLoadListener(Delegate.create(this, onStoriesResponseLoaded));

        storyRequestTime = getTimer();

        clearInterval(requestInterval);
        return response;
    }

    /**
     * @return  String
     */
    private function getSortKey():String
    {
        return (mode == MODE_POPULAR) ? 'promote' : 'submit';
    }

    /**
     * Parse a request for multiple stories, and pass them off to
     * {@link storiesLoaded()}.
     *
     * @param   event   an event object whose 'target' property is a reference
     *                  to the loaded Response.
     */
    private function onStoriesResponseLoaded(event:Object):Void
    {
        if (!running)
        {
            debug('Not running, discarding stories!', 3);
            return;
        }

        var stories:Array = new Array();
        var now:DateExt;
        
        debug('onStoriesResponseLoaded(' + event.success + ')', 3);

        var fatal:Boolean = true; // mode != MODE_SPY;
        if (event.success)
        {
            var body:XML = event.target.getBody();
            var root:XMLNode = body.firstChild;
            // debug('Loaded XML:' + root.toString());
            now = DateExt.fromTimestamp(root.attributes['timestamp']);

            for (var child:XMLNode = root.firstChild; child; child = child.nextSibling)
            {
                if (child.nodeName == 'story')
                {
                    var story:Story = Story.fromXML(child, model);
                    stories.push(story);
                }
            }

            debug('got ' + stories.length + ' stories!', 3);
        }
        else
        {
            error("Failed to load stories from the digg API", fatal);
            if (fatal) return;
        }

        if (storyRequestTime > 0)
        {
            var responseTime:Number = getTimer() - storyRequestTime;
            if (true) // (responseTime < maxResponseTime)
            {
                debug('got new response time: ' + responseTime, 1);
                // average them out
                this.responseTime = (this.responseTime + responseTime) / 2;
            }
        }

        storiesLoaded(stories, now, mode == MODE_SPY);
        event.target.cancel();
    }

    /**
     * Attach a list of loaded stories to the view.
     *
     * @param   Array   stories     a list of {@link com.digg.fdk.model.Story} objects.
     * @param   DateExt now         used to determine the timestamp for the next
     *                              {@link loadStories()} request.
     *
     */
    private function storiesLoaded(stories:Array, now:DateExt, update:Boolean):Void
    {
        debug('storiesLoaded(): got ' + stories.length + ' stories');

        stories.reverse();

        var timeout:Number = 0;
        var offset:Number = getAttachRate(stories.length);

        var len:Number = stories.length;
        for (var i:Number = 0; i < len; i++)
        {
            var story:Story = stories[i];

            if (!model.addStory(story, update))
            {
                error('unable to add duplicate story: "' + story.title + '"');
                continue;
            }

            // debug('setting timeout for story #' + i + ': "' + story.title + '", ' + Math.round(timeout));
            setTimeout(queueStory, timeout, story);
            timeout += offset;
        }

        if (mode != MODE_SPY)
        {
	        loadDiggs();
            setNow(now);
            debug('setting timeout for loadStories(): ' + requestRate);
            requestInterval = setTimeout(loadStories, requestRate);
        }
    }

    /**
     * Update a story in the model from the API.
     *
     * @param   story   the story to be updated.
     * @return          a request that can be listened to for 'loaded' events.
     */
    public function updateStory(story:Story):IResponse
    {
        var response:IResponse = loadStory(story);
        // response.eventParams.update = true;
        return response;
    }

    /**
     * Get the number of milliseconds between events that should be spaced out
     * between now and the time of the next request.
     *
     * @param   count   the number of events that will take place.
     */
    private function getAttachRate(count:Number):Number
    {
        if (null == count) count = requestParams.count;
        return (requestRate + responseTime) / (count + 1);
    }

    /**
     * Set the timestamp used for periodic calls to either {@link loadStories()}
     * or {@link loadDiggs()} (based on the controller mode).
     *
     * @param   DateExt     now
     */
    private function setNow(now:DateExt):Void
    {
        updateRequestTimes();

        if (now.toTimestamp() > 0)
        {
            var ts:Number = Math.floor(now.toTimestamp() / timestampQuantize) * timestampQuantize;
            this.now = DateExt.fromTimestamp(ts);
            debug('*** now = ' + this.now.formatTime(), 1);
        }
        else
        {
            error('There was a problem with the digg API response: bad "now" timestamp', true);
        }
    }

    /**
     * Tell the view to display an error message, and stop the controller if the
     * error was fatal.
     *
     * @param   String      msg         the error message.
     * @param   Boolean     fatal       whether or not the error was fatal.
     *
     */
    public function error(msg:String, fatal:Boolean):Void
    {
        debug(msg, fatal ? 3 : 4);

        if (fatal)
        {
            var params:Object = {title: 'Error',
                                 body:  msg,
                                 buttons: {reset: 'Try again'}};

            var dialog:Dialog = view.showDialog(params);
            var reset:Function = function():Void
            {
                this.reset(true);
                this.start();
            };
            dialog.addEventListener('dismissed', Delegate.create(this, reset));

            stop();
        }
    }

    /**
     * Read options in from an object. The object is treated as a dictionary
     * with keys corresponding to Controller class member variable names. This
     * is used to read options provided to the swf via the query string.
     */
    public function readOptions(options:Object):Void
    {
        // load up config options
    	for (var key:String in options)
    	{
            if (options[key] instanceof MovieClip) continue;
    		setConfigOption(key, options[key]);
    	}
    }

    /**
     * Set a member variable based on a config option.
     *
     * @param   String  key     the member variable name.
     * @param   Object  value   the member value.
     * @return  Boolean         whether or not the option was set.
     */
    private function setConfigOption(key:String, value):Boolean
    {
        switch (key)
        {
            /*
             * Whitelist for configurable member variables
             */
            case 'apiURL':
            case 'appKey':
            case 'mode':
            case 'pauseRate':
            case 'requestParams':
            case 'requestRate':
                if (key == 'requestRate')
                {
                    value = Math.max(value, 1000);
                }
                else if (key == 'apiURL')
                {
                    debug('API url: ' + value);
                    API.baseURL = value;
                    return true;
                }
                else if (key == 'appKey')
                {
                    debug('got API app key: ' + value);
                    API.appKey = value;
                    return true;
                }

                if (typeof value != typeof this[key])
                {
                    error('Invalid type for config option "' + key + '": got ' +
                          (typeof value) + ' but was expecting ' + (typeof this[key]));
                    return false;
                }

                debug('setting config option "' + key + '" to "' + JSON.stringify(value) + '"');
                this[key] = value;
                return true;
        }

        // debug('Unrecognized config option: "' + key + '"');
        return false;
    }

    /**
     * Initialize the controller.
     */
    public function init():Void
    {
        view.attach();
    }

    /**
     * Handler for the view's 'doneAttaching' event. Once the view is done
     * attaching, the controller starts.
     *
     * @param   Object  event
     */
    private function onViewDoneAttaching(event:Object):Void
    {
        if (event.target != view)
        {
            error('Controller.onViewDoneAttaching(): received event from non-view clip: ' + event.target);
            return;
        }

        // debug('Controller.onViewDoneAttaching(): starting...');
        start();
    }

    /**
     * Handler for the view's 'doneResetting' event. This in turn triggers an
     * immediate resetting of the controller.
     *
     * @param   Object  event
     */
    private function onViewDoneResetting(event:Object):Void
    {
        if (event.target != view)
        {
            error('Controller.onViewDoneResetting(): received event from non-view clip: ' + event.target);
            return;
        }

        // debug('Controller.onViewDoneResetting(): resetting...');
        reset(true);
    }

    /**
     * Handler for view's 'storyRemovedFromView' event. This should remove the
     * story from the model and purge the deferredStoryDiggs hash of any diggs on
     * that story.
     */
    private function onViewDoneRemovingStory(event:Object):Void
    {
        var story:Story = event.story;
        debug('onViewDoneRemovingStory(): removed "' + story.title + '"');

        model.removeStory(story);
        deferredStoryDiggs.deleteKey(story.safeKey());
    }
}
