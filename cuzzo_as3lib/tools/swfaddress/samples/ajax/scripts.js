// Custom utility functions

function toTitleCase(str) {
    return str.substr(0,1).toUpperCase() + str.substr(1).toLowerCase();
}      

function formatTitle(title) {
    return 'SWFAddress Website' + (title != '/' ? ' / ' + toTitleCase(title.substr(1, title.length - 2).replace(/\//g, ' / ')) : '');
}


// Custom SWFAddress and Ajax handling

function getTransport() {
    if (window.XMLHttpRequest) {
        return new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        try {
            return new ActiveXObject('Msxml2.XMLHTTP');
        } catch(e) {
            return new ActiveXObject('Microsoft.XMLHTTP');
        }
    }
}

function appear(content, value) {
    if (typeof value == 'undefined') value = 0;
    var property = content.filters ? 'filter' : 'opacity';
    if (value == 100) {
        if (content.style.removeAttribute) {
            content.style.removeAttribute(property);
        } else {
            content.style[property] = 1;
        }
    } else {
        content.style[property] = content.filters ? 'alpha(opacity=' + value + ')' : value/100;
        setTimeout(function () {appear(content, value + 20)}, 50);
    }
}

function updateChange(xhr) {
    if (xhr.readyState == 4) {
        if (xhr.status == 200) {
            var content = document.getElementById('content');
            content.innerHTML = xhr.responseText;
            appear(content);
            var links = document.getElementById('social').getElementsByTagName('a');
            for (var i = 0, link, parts, pairs; link = links[i]; i++) {
                parts = link.href.split('?');
                pairs = parts[1].split('&');
                for (var j = 0, params; j < pairs.length; j++) {
                    params = pairs[j].split('=');
                    if (params[0] == 'url' || params[0] == 'u' || params[0] == 'bkmk')
                        pairs[j] = params[0] + '=' + SWFAddress.getBaseURL() + SWFAddress.getValue();
                    if (params[0] == 'title' || params[0] == 't')
                        pairs[j] = params[0] + '=' + SWFAddress.getTitle();
                }
                link.href = parts[0] + '?' + pairs.join('&');
            }
        } else {
            alert('Error: ' + xhr.status + '!');
        }
    }
}

function handleChange(event) {
    var index, rel, links = document.getElementsByTagName('a'), path = event.path;
    if (path.substr(path.length - 1) != '/') {
        path += '/';
    }
    for (var i = 0, l, link; link = links[i]; i++) {
        index = link.rel.indexOf('?');
        rel = (index > -1) ? link.rel.substr(0, index) : link.rel;
        link.className = (rel == path) ? 'selected' : '';
    }
    var parameters = '';
    for (var p in event.parameters) {
        parameters += '&' + p + '=' + event.parameters[p];
    }
    var xhr = getTransport();
    xhr.onreadystatechange = function() {
        updateChange(xhr);
    }
    xhr.open('get', 'datasource.php?swfaddress=' + event.path + parameters, true);
    xhr.send('');
    SWFAddress.setTitle(formatTitle(event.path));
}

function copyLink() {
    if (window.clipboardData && clipboardData.setData) {
        clipboardData.setData('Text', SWFAddress.getBaseURL() + SWFAddress.getValue());
    } else {
        alert('Unsupported browser.');
    }
}

SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleChange);