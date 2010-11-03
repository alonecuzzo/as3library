/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Ma Bingyao <andot@ujn.edu.cn>
 */
_global.SWFAddress = function(){

    this._init = false;
    this._initChange = false;
    this._initChanged = false;
    this._queue = new Array();
    this._strict = true;
    this._value = '';
    this._availability = flash.external.ExternalInterface.available;

    this._check = function() {
        if (typeof SWFAddress.onInit == 'function' && !_init) {
            SWFAddress._setValueInit(this._getValue());
            SWFAddress._init = true;
        }
        if (typeof SWFAddress.onChange == 'function' || 
            typeof SWFAddress.onExtenalChange == 'function') {
            clearInterval(this._interval);
            SWFAddress._init = true;
            SWFAddress._setValueInit(this._getValue());
        }
    }
    
    this._strictCheck = function(value, force) {
        if (SWFAddress.getStrict()) {
            if (force) {
                if (value.substr(0, 1) != '/') value = '/' + value;
            } else {
                if (value == '') value = '/';
            }
        }
        return value;
    }

    this._getValue = function() {
        var value, ids = 'null';
        if (this._availability) {
            value = String(flash.external.ExternalInterface.call('SWFAddress.getValue'));
            ids = String(flash.external.ExternalInterface.call('SWFAddress.getIds'));
        }
        if (ids == 'undefined' || ids == 'null' || !this._availability || this._initChange) {
            value = this._value;
        } else if (value == undefined || value == 'undefined' || value == 'null') {
            value = '';
        }
        return SWFAddress._strictCheck(value || '', false);
    }
    
    this._setValueInit = function(value) {
        SWFAddress._value = value;
        if (!this._init) {
            SWFAddress._dispatchEvent('init');
        } else {
            SWFAddress._dispatchEvent('change');
            SWFAddress._dispatchEvent('externalChange');
        }
        SWFAddress._initChange = true;
    }
    
    this._setValue = function(value) {
        if (value == 'undefined' || value == 'null') value = '';
        if (SWFAddress._value == value && SWFAddress._init) return;
        if (!SWFAddress._initChange) return;
        SWFAddress._value = value;
        if (!this._init) {
            SWFAddress._init = true;            
            if (typeof SWFAddress.onInit == 'function') SWFAddress.onInit();
        }
        SWFAddress._dispatchEvent('change');
        SWFAddress._dispatchEvent('externalChange');
    }

    this._dispatchEvent = function(type) {    
        type = type.substr(0, 1).toUpperCase() + type.substring(1);
        if (typeof SWFAddress['on' + type] == 'function') {
            SWFAddress['on' + type]();
        }
    }
    
    this._callQueue = function() {
        if (this._queue.length != 0) {
            var script = '';
            for (var i = 0, obj; obj = this._queue[i]; i++) {
                if (typeof obj.param == 'string') obj.param = '"' + SWFAddress.encodeURI(SWFAddress.decodeURI(String(obj.param))) + '"';
                script += obj.fn + '(' + obj.param + ');';
            }
            this._queue = new Array();
            getURL('javascript:' + script + 'void(0);');
        } else {
            clearInterval(this._queueInterval);
        }
    }
    
    this._call = function(fn, param) {
        if (typeof param == 'undefined') param = '';
        if (this._availability) {
            if (System.capabilities.os.indexOf('Mac') != -1) {
                if (this._queue.length == 0) {
                    this._queueInterval = setInterval(this, '_callQueue', 10);                
                }
                this._queue.push({fn: fn, param: param});
            } else {
                flash.external.ExternalInterface.call(fn, param);
            }
        }
    }
        
    if (this._availability) {
        try {
            this._availability = 
                Boolean(flash.external.ExternalInterface.call('function() { return (typeof SWFAddress != "undefined"); }'));
            flash.external.ExternalInterface.addCallback('getSWFAddressValue', this, 
                function(){return SWFAddress.getValue();});
            flash.external.ExternalInterface.addCallback('setSWFAddressValue', this, 
                function(value){SWFAddress._setValue(value);});
        } catch (e) {
            this._availability = false;
        }    
    }
    
    this._interval = setInterval(this, '_check', 10);
}
_global.SWFAddress = new SWFAddress();

SWFAddress.toString = function() {
    return '[class SWFAddress]';
}

/**
 * Ported from iecompat.js <http://www.coolcode.cn/?action=show&id=126>
 */
SWFAddress.encodeURI = function(str) {

    var l = ['%00', '%01', '%02', '%03', '%04', '%05', '%06', '%07', '%08', 
                    '%09', '%0A', '%0B', '%0C', '%0D', '%0E', '%0F', '%10', 
                    '%11', '%12', '%13', '%14', '%15', '%16', '%17', '%18', 
                    '%19', '%1A', '%1B', '%1C', '%1D', '%1E', '%1F', '%20', 
                    '!', '%22', '#', '$', '%25', '&', '\'', '(', ')', '*', 
                    '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', 
                    '6', '7', '8', '9', ':', ';', '%3C', '=', '%3E', '?',
                    '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 
                    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 
                    'V', 'W', 'X', 'Y', 'Z', '%5B', '%5C', '%5D', '%5E', '_', 
                    '%60', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 
                    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',  'u', 
                    'v', 'w', 'x', 'y', 'z', '%7B', '%7C', '%7D', '~', '%7F'];
                    
    var out = [], i, j, len = str.length, c, c2;

    for (i = 0, j = 0; i < len; i++) {
        c = str.charCodeAt(i);
        if (c <= 0x007F) {
                out[j++] = l[c];
                continue;
        } else if (c <= 0x7FF) {
                out[j++] = '%' + (0xC0 | ((c >>  6) & 0x1F)).toString(16).toUpperCase();
                out[j++] = '%' + (0x80 |         (c & 0x3F)).toString(16).toUpperCase();
                continue;
        } else if (c < 0xD800 || c > 0xDFFF) {
                out[j++] = '%' + (0xE0 | ((c >> 12) & 0x0F)).toString(16).toUpperCase();
                out[j++] = '%' + (0x80 | ((c >>  6) & 0x3F)).toString(16).toUpperCase();
                out[j++] = '%' + (0x80 |         (c & 0x3F)).toString(16).toUpperCase();
                continue;
        } else {
            if (++i < len) {
                c2 = str.charCodeAt(i);
                if (c <= 0xDBFF && 0xDC00 <= c2 && c2 <= 0xDFFF) {
                    c = ((c & 0x03FF) << 10 | (c2 & 0x03FF)) + 0x010000;
                    if (0x010000 <= c && c <= 0x10FFFF) {
                            out[j++] = '%' + (0xF0 | ((c >>> 18) & 0x3F)).toString(16).toUpperCase();
                            out[j++] = '%' + (0x80 | ((c >>> 12) & 0x3F)).toString(16).toUpperCase();
                            out[j++] = '%' + (0x80 | ((c >>>  6) & 0x3F)).toString(16).toUpperCase();
                            out[j++] = '%' + (0x80 |          (c & 0x3F)).toString(16).toUpperCase();
                            continue;
                    }
                }
            }
        }
        return null;
    }
    return out.join('');
}

/**
 * Ported from iecompat.js <http://www.coolcode.cn/?action=show&id=126>
 */
SWFAddress.decodeURI = function(str) {

    var out = [], i = 0, j = 0, len = str.length;
    var c, c2, c3, c4, s;

    var checkcode = function (strcc, i2, i1) {
        var d1 = strcc.charAt(i1),
            d2 = strcc.charAt(i2);
        if (isNaN(parseInt(d1, 16)) || isNaN(parseInt(d2, 16))) {
            return null;
        }
        return parseInt(d1 + d2, 16);
    }
    
    var checkutf8 = function (strcu, i3, i2, i1) {
        var ccu = strcu.charCodeAt(i1);
        if (ccu == 37) {
            if ((ccu = checkcode(strcu, i3, i2)) == null) return null;
        }
        if ((ccu >> 6) != 2) {
            return null;
        }
        return ccu;
    }

    while(i < len) {
        c = str.charCodeAt(i++);
        if (c == 37) {
            if ((c = checkcode(str, i++, i++)) == null) return null;
        } else {
            out[j++] = String.fromCharCode(c);
            continue;
        }
        switch(c) {
            case 35: case 36: case 38: case 43: case 44: case 47:
            case 58: case 59: case 61: case 63: case 64: {
                if (str.charCodeAt(i - 3) == 37) {
                    out[j++] = str.substr(i - 3, 3);
                } else {
                    out[j++] = str.substr(i - 1, 1);
                }
                break;
            }
            default: {
                switch (c >> 4) { 
                    case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: {
                        // 0xxxxxxx
                        out[j++] = String.fromCharCode(c);
                        break;
                    }
                    case 12: case 13: {
                        // 110x xxxx    10xx xxxx
                        if ((c2 = checkutf8(str, i++, i++, i++)) == null) return null;
                        out[j++] = String.fromCharCode(((c & 0x1F) << 6) | (c2 & 0x3F));
                        break;
                    }
                    case 14: {
                        // 1110 xxxx  10xx xxxx  10xx xxxx
                        if ((c2 = checkutf8(str, i++, i++, i++)) == null) return null;
                        if ((c3 = checkutf8(str, i++, i++, i++)) == null) return null;
                        out[j++] = String.fromCharCode(((c & 0x0F) << 12) |
                            ((c2 & 0x3F) << 6) | ((c3 & 0x3F) << 0));
                        break;
                    }
                    default: {
                        switch (c & 0xf) {
                            case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: {
                                // 1111 0xxx  10xx xxxx  10xx xxxx  10xx xxxx
                                if ((c2 = checkutf8(str, i++, i++, i++)) == null) return null;
                                if ((c3 = checkutf8(str, i++, i++, i++)) == null) return null;
                                if ((c4 = checkutf8(str, i++, i++, i++)) == null) return null;
                                s = ((c  & 0x07) << 18) |
                                    ((c2 & 0x3f) << 12) |
                                    ((c3 & 0x3f) <<  6) |
                                    (c4 & 0x3f) - 0x10000;
                                if (0 <= s && s <= 0xfffff) {
                                    out[j++] = String.fromCharCode(((s >>> 10) & 0x03ff) | 0xd800, (s & 0x03ff) | 0xdc00);
                                } else {
                                    return null;
                                }
                                break;
                            }
                            default: {
                                return null;
                            }
                        }
                    }
                }
            }
        }
    }
    return out.join('');
}

SWFAddress.back = function() {
    this._call('SWFAddress.back');
}

SWFAddress.forward = function() {
    this._call('SWFAddress.forward');
}

SWFAddress.up = function() {
    var path:String = SWFAddress.getPath();
    SWFAddress.setValue(path.substr(0, path.lastIndexOf('/', path.length - 2) + (path.substr(path.length - 1) == '/' ? 1 : 0)));
}

SWFAddress.go = function(delta) {
    this._call('SWFAddress.go', delta);
}

SWFAddress.href = function(url, target) {
    target = (typeof target != 'undefined') ? target : '_self';        
    if (this._availability && System.capabilities.playerType == 'ActiveX') {
        flash.external.ExternalInterface.call('SWFAddress.href', url, target);
        return;
    }
    getURL(url, target);
}

SWFAddress.popup = function(url, name, options, handler) {
    name = (typeof name != 'undefined') ? name : 'popup';
    options = (typeof options != 'undefined') ? options : '""';
    handler = (typeof handler != 'undefined') ? handler : '';
    if (this._availability && System.capabilities.playerType == 'ActiveX') {
        flash.external.ExternalInterface.call('SWFAddress.popup', url, name, options, handler);
        return;
    }
    getURL('javascript:popup=window.open("' + url + '","' + name + '",' + options + ');' + handler + ';void(0);');
}

SWFAddress.getBaseURL = function() {
    var url = 'null';
    if (this._availability)
        url = String(flash.external.ExternalInterface.call('SWFAddress.getBaseURL'));
    return (url == 'undefined' || url == 'null' || !this._availability) ? '' : url;
}

SWFAddress.getStrict = function() {
    var strict = 'null';
    if (this._availability)
        strict = String(flash.external.ExternalInterface.call('SWFAddress.getStrict'));
    return (strict == 'null' || strict == 'undefined') ? this._strict : (strict == 'true');
}

SWFAddress.setStrict = function(strict) {
    this._call('SWFAddress.setStrict', strict);
    this._strict = strict;
}

SWFAddress.getHistory = function() {
    return (this._availability) ? 
        Boolean(flash.external.ExternalInterface.call('SWFAddress.getHistory')) : false;
}

SWFAddress.setHistory = function(history) {
    this._call('SWFAddress.setHistory', history);
}

SWFAddress.getTracker = function() {
    return (this._availability) ? 
        String(flash.external.ExternalInterface.call('SWFAddress.getTracker')) : '';
}

SWFAddress.setTracker = function(tracker) {
    this._call('SWFAddress.setTracker', tracker);
}
        
SWFAddress.getTitle = function() {
    var title = (this._availability) ? 
        String(flash.external.ExternalInterface.call('SWFAddress.getTitle')) : '';
    if (title == 'undefined' || title == 'null') title = '';
    return title;
}

SWFAddress.setTitle = function(title) {
    this._call('SWFAddress.setTitle', title);
}

SWFAddress.getStatus = function() {
    var status = (this._availability) ? 
        String(flash.external.ExternalInterface.call('SWFAddress.getStatus')) : '';
    if (status == 'undefined' || status == 'null') status = '';
    return status;
}

SWFAddress.setStatus = function(status) {
    this._call('SWFAddress.setStatus', status);
}

SWFAddress.resetStatus = function() {
    this._call('SWFAddress.resetStatus');
}

SWFAddress.getValue = function() {
    return SWFAddress.decodeURI(SWFAddress._strictCheck(SWFAddress._value || '', false));
}

SWFAddress.setValue = function(value) {
    if (value == 'undefined' || value == 'null') value = '';
    value = SWFAddress.encodeURI(SWFAddress.decodeURI(value));
    if (SWFAddress._value == value) return;
    SWFAddress._value = value;
    this._call('SWFAddress.setValue', value);
    if (SWFAddress._init) {
        SWFAddress._dispatchEvent('change');
        SWFAddress._dispatchEvent('internalChange');
    } else {
        SWFAddress._initChanged = true;
    }
}

SWFAddress.getPath = function() {
    var value = SWFAddress.getValue();
    if (value.indexOf('?') != -1) {
        return value.split('?')[0];
    } else if (value.indexOf('#') != -1) {
        return value.split('#')[0];
    } else {
        return value;   
    }
}

SWFAddress.getPathNames = function() {
    var path = SWFAddress.getPath();
    var names = path.split('/');
    if (path.substr(0, 1) == '/' || path.length == 0)
        names.splice(0, 1);
    if (path.substr(path.length - 1, 1) == '/')
        names.splice(names.length - 1, 1);
    return names;
}
        
SWFAddress.getQueryString = function() {
    var value = SWFAddress.getValue();
    var index = value.indexOf('?');
    if (index != -1 && index < value.length) {
        return value.substr(index + 1);
    }
}

SWFAddress.getParameter = function(param) {
    var value = SWFAddress.getValue();
    var index = value.indexOf('?');
    if (index != -1) {
        value = value.substr(index + 1);
        var params = value.split('&');
        var p, i = params.length, r = [];
        while(i--) {
            p = params[i].split('=');
            if (p[0] == param) {
                r.push(p[1]);
            }
        }
        if (r.length != 0)
            return r.length != 1 ? r : r[0];
    }
}

SWFAddress.getParameterNames = function() {
    var value = SWFAddress.getValue();
    var index = value.indexOf('?');
    var names = new Array();
    if (index != -1) {
        value = value.substr(index + 1);
        if (value != '' && value.indexOf('=') != -1) {            
            var params = value.split('&');
            var i = 0;
            while(i < params.length) {
                names.push(params[i].split('=')[0]);
                i++;
            }
        }
    }
    return names;
}