/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.Model;

import mx.events.EventDispatcher;
import mx.utils.Delegate;

/**
 * The Response class is the abstract implementation of the IResponse interface,
 * and the basis of all of the FDK's built in response classes. It implements
 * Macromedia's MX {@link EventDispatcher} interface, which is used to add event
 * listeners (see {@link addLoadListener()} and dispatch the load event.  As per
 * Macromedia's methods, the dispatched event object's "target" member will
 * always be a reference to the instance that dispatched the event.
 */
class com.digg.services.Response implements IResponse
{
    public static var EVENT_LOADED:String = 'loaded';

    /*
     * These members are private; you should be accessing them via the {@link
     * IResponse} interface's methods.
     */
    private var items:Array;
    private var request:Request;
    private var error:ResponseError;
    private var loaded:Boolean;
    private var meta:Object;
    private var model:Model;

    /*
     * EventDispatcher decoration
     */
    public var addEventListener:Function;
    public var removeEventListener:Function;
    private var dispatchEvent:Function;
    private static var eventLink = EventDispatcher.initialize(Response.prototype);

    /**
     * Create a new Response object, and optionally load a URL.
     *
     * @param   url     If provided, the URL will be loaded via the {@link
     *                  load()} method.
     */
    public function Response(url:String)
    {
        if (url) load(url);
    }

    /**
     * Load the specified URL. To be notified when the response is loaded,
     * use {@link addLoadListener()}.
     *
     * @param   url     The URL to load.
     */
    public function load(url:String):Void
    {
        // make sure we kill the last request
        if (request)
        {
            request.onLoad = function():Void {};
            delete request;
        }
        loaded = false;
        request = new Request(url);
        request.onLoad = Delegate.create(this, onRequestLoaded);
    }

    /**
     * Determine the URL being loaded.
     */
    public function getURL():String
    {
        return request.url;
    }

    /**
     * Register a function to be called when the response body is loaded. The
     * function should receive an Object as its only argument, and can be
     * asssumed to have the following members:
     *
     * - "success" (type Boolean): whether or not the request succeeded.
     * - "target" (type Response): the Response object that dispatched the
     *      event. The body of the response can be obtained via the instance's
     *      {@link getBody()} method.
     *
     * @param   listener    A function that will be called when the response has
     *                      either been loaded, or failed to load.
     */
    public function addLoadListener(listener:Function):Void
    {
        addEventListener(EVENT_LOADED, listener);
    }

    /**
     * Determine whether or not the response has been loaded successfully.
     *
     * @TODO: Define "successfully".
     */
    public function isLoaded():Boolean
    {
        return loaded;
    }

    /**
     * This is the {@link Request.onLoad()} handler. First, we check to see that
     * the HTTP status code of the response was 200. If so, we attempt to load
     * the metadata and items with {@link loadMeta()} and {@link loadItems()}.
     * (NOTE: If {@link loadItems()} fails, success is set to false.) In the
     * even that it wasn't, the {@link error} member is set by {@link
     * setError()}. Either way, an event of type EVENT_LOADED is dispatched.
     *
     * @param   success     Provided by {@link Request.onLoad()}.
     */
    private function onRequestLoaded(success:Boolean):Void
    {
        /*
         * HACK: according to Macromedia's docs, the majority of browsers do not
         * pass the HTTP status code to the Flash plug-in. Therefore, we should
         * assume a 200 unless the first element in the response body is an
         * <error/>.
         */
        var body:XML = getBody();
        var isError:Boolean = body.firstChild.nodeName == 'error';

        if (success && !isError && (request.HTTPStatus == 200 || !request.HTTPStatus))
        {
            /*
             * loadItems() is expected to set the "error" member to something
             * meaningful if it fails to extract a list of items from the
             * response body
             */
            loadMeta();

            if (loadItems())
            {
                loaded = true;
            }
            else
            {
                success = false;
                if (!error)
                {
                    error = new ResponseError(request.url, request.HTTPStatus,
                                              'Unable to load items from response.');
                }
            }
        }
        else
        {
            setError();
        }

        dispatchEvent({type: EVENT_LOADED, success: success});
    }

    /**
     * Create a useful ResponseError object that can be obtained via {@link
     * getError()}. If the response body is successfully parsed as XML and
     * contains an <error/> node, the contents of its "message" attribute are
     * used as the error message. Otherwise, the error message should correspond
     * to the HTTP status code of the response.
     */
    private function setError():Void
    {
        var errorMessage:String = 'Unknown error';
        var body:XML = getBody();

        if (body && body.hasChildNodes() && body.firstChild.nodeName == 'error')
        {
            errorMessage = request.firstChild.attributes['message'];
        }
        else
        {
            switch (request.HTTPStatus)
            {
                case 404:
                    errorMessage = 'Not found';
                    break;

                case 503:
                    errorMessage = 'Server error';
                    break;
            }
        }

        error = new ResponseError(request.url, request.HTTPStatus, errorMessage);
    }

    /**
     * Load metadata from the response body. Common metadata for all Digg API
     * responses includes:
     *
     * - "timestamp": a UNIX timestamp indicating the time at which the request
     *      was served. This is parsed and turned into a native Date object.
     * - "count": the number of items included in the response
     * - "total": the total number of records in the result set
     * - "offset": if applicable, the offset of the returned data in the entire
     *      result set
     *
     * Metadata is accessed publicly via {@link getMeta()}.
     */
    private function loadMeta():Void
    {
        var root:XMLNode = getBody().firstChild;
        meta = {timestamp:  API.getDateFromTimestamp(parseInt(root.attributes['timestamp'])),
                count:      parseInt(root.attributes['count']),
                total:      parseInt(root.attributes['total']),
                offset:     parseInt(root.attributes['offset'])};
    }

    /**
     * Load items from the response body. The Array of items should be made
     * available publicly via the {@link getItems()} method.
     */
    private function loadItems():Boolean
    {
        return true;
    }

    /**
     * Get the response's metadata.
     *
     * @return  An Object with (for most API endpoints) the following members:
     *          - "timestamp": a Date object representing the time (according to
     *          the Digg API) at which the request was handled.
     *          - "count", "total", "offset": all integers indicating,
     *          respectively, the number of items contained in the response; the
     *          total number of items in the result set; and the offset from the
     *          start of the result set.
     */
    public function getMeta():Object
    {
        return meta;
    }

    /**
     * Get the response body as XML.
     */
    public function getBody():XML
    {
        return request;
    }

    /**
     * Get a {@link ResponseError} object indicating what (if anything) went
     * wrong in the event that the request failed.
     */
    public function getError():ResponseError
    {
        return error;
    }

    /**
     * Get the first item in the returned portion of the result set, and remove
     * it from the list.
     */
    public function getItem():Object
    {
        return items.shift();
    }

    /**
     * Get all of the items as an Array.
     */
    public function getItems():Array
    {
        return items;
    }

    public function useModel(model:Model):Void
    {
        this.model = model;
    }
}
