var CSSearch = CSSearch || {};

CSSearch.extension = (function () {

    var Cc = Components.classes;
    var Ci = Components.interfaces;
    var enabled = true;

    var utils = (function () {

        var quiet = false;
        var console = Cc["@mozilla.org/consoleservice;1"].getService(Ci.nsIConsoleService);

        function log(message) {
            if (quiet) return;
            // requires javascript.options.showInConsole=true to show up in ErrorConsole
            console.logStringMessage('CSS ' + message);
        }

        return {
            log: log
        };

    })();

    var Browser = function (browser) {
        this.browser = browser;
        this.doc = browser.contentDocument;
        // this.window = browser.contentDocument.defaultView.wrappedJSObject;
    };

    Browser.prototype = {
        currentURI: function () {
            return this.browser.currentURI;
        },
        appendToHead: function (elem) {
            this.doc.getElementsByTagName('head')[0].appendChild(elem);
        },
        makeJS: function (src) {
            var s = this.doc.createElement('script');
            s.setAttribute('type', 'text/javascript');
            s.setAttribute('src', src);
            return s;
        }
    };

    var api = (function () {

        var baseUrl = "lbolla.info";
        var port = "";
        // var baseUrl = "localhost";
        // var port = ":8080";

        return {
            getCSSearchJS: function (host) { return "http://" + baseUrl + port + "/cssearch/js"; }
        };
    })();

    var Extension = function (browser) {
        this.browser = browser;
    };

    Extension.prototype = (function () {
        function run() {
            var uri = this.browser.currentURI();

            if (uri.scheme.search(/^https?/) === -1) {
                utils.log("invalid scheme " + uri.scheme);
                return;
            }

            utils.log("valid uri " + uri.spec);
            this.browser.appendToHead(this.browser.makeJS(api.getCSSearchJS()));
        }

        return {
            run: run
        };

    })();

    function onLoad() {
        var appcontent = document.getElementById("appcontent");
        if (appcontent) {
            appcontent.addEventListener("DOMContentLoaded", onPageLoad, true);
        } else {
            utils.log("Element id=appcontent not found.");
        }
    }

    function onPageLoad(aEvent) {
        if (!aEvent || !aEvent.originalTarget || !aEvent.originalTarget.location) 
            return;      
        if (aEvent.originalTarget.location.href.match(/^chrome:\/\//)) 
            return;    
        onPageRefresh(aEvent);
    }

    function onPageRefresh(aEvent) {
        var document = aEvent.originalTarget;
        var address = document.location.href;
        utils.log("page " + address);
        var browserForDoc = gBrowser.getBrowserForDocument(document);
        if (browserForDoc === null)
            return;
        var browser = new Browser(browserForDoc);
        utils.log("browser created");
        var e = new Extension(browser);
        e.run();
    }

    function toggleEnabled() {
        enabled = !enabled;
    }

    return { 
        onLoad: onLoad,
        toggleEnabled: toggleEnabled
    };

})();

window.addEventListener("load", CSSearch.extension.onLoad, false);
