!function(e,t){"use strict";function n(e,t){for(var n,i=[],r=0;r<e.length;++r){if(n=s[e[r]]||o(e[r]),!n)throw"module definition dependecy not found: "+e[r];i.push(n)}t.apply(null,i)}function i(e,i,r){if("string"!=typeof e)throw"invalid module definition, module id must be defined and be a string";if(i===t)throw"invalid module definition, dependencies must be specified";if(r===t)throw"invalid module definition, definition function must be specified";n(i,function(){s[e]=r.apply(null,arguments)})}function r(e){return!!s[e]}function o(t){for(var n=e,i=t.split(/[.\/]/),r=0;r<i.length;++r){if(!n[i[r]])return;n=n[i[r]]}return n}function a(n){for(var i=0;i<n.length;i++){for(var r=e,o=n[i],a=o.split(/[.\/]/),l=0;l<a.length-1;++l)r[a[l]]===t&&(r[a[l]]={}),r=r[a[l]];r[a[a.length-1]]=s[o]}}var s={},l="tinymce/pasteplugin/Clipboard",c="tinymce/Env",u="tinymce/util/Tools",d="tinymce/util/VK",p="tinymce/pasteplugin/WordFilter",f="tinymce/html/DomParser",g="tinymce/html/Schema",m="tinymce/html/Serializer",v="tinymce/html/Node",h="tinymce/pasteplugin/Quirks",b="tinymce/pasteplugin/Plugin",y="tinymce/PluginManager";i(l,[c,u,d],function(e,t,n){function i(){return!e.gecko&&("ClipboardEvent"in window||e.webkit&&"FocusEvent"in window)}return function(r){function o(){return(new Date).getTime()-d<100}function a(e,n){return t.each(n,function(t){e=t.constructor==RegExp?e.replace(t,""):e.replace(t[0],t[1])}),e}function s(t){var n=r.fire("PastePreProcess",{content:t});t=n.content,r.settings.paste_data_images||(t=t.replace(/<img src=\"data:image[^>]+>/g,"")),(r.settings.paste_remove_styles||r.settings.paste_remove_styles_if_webkit!==!1&&e.webkit)&&(t=t.replace(/ style=\"[^\"]+\"/g,"")),n.isDefaultPrevented()||r.insertContent(t)}function l(e){e=r.dom.encode(e),e=a(e,[[/\n\n/g,"</p><p>"],[/^(.*<\/p>)(<p>)$/,"<p>$1"],[/\n/g,"<br />"]]);var t=r.fire("PastePreProcess",{content:e});t.isDefaultPrevented()||r.insertContent(t.content)}function c(){var e=(r.inline?r.getBody():r.getDoc().documentElement).scrollTop,t=r.dom.add(r.getBody(),"div",{id:"mcePasteBin",contentEditable:!1,style:"position: absolute; top: "+e+"px; left: 0; background: red; width: 1px; height: 1px; overflow: hidden"},'<div contentEditable="true">X</div>');return t}function u(){var e=r.dom.get("mcePasteBin");r.dom.unbind(e),r.dom.remove(e)}var d;r.on("keydown",function(e){n.metaKeyPressed(e)&&e.shiftKey&&86==e.keyCode&&(d=(new Date).getTime())}),i()?r.on("paste",function(e){function t(e,t){for(var i=0;i<n.types.length;i++)if(n.types[i]==e)return t(n.getData(e)),!0}var n=e.clipboardData;n&&(e.preventDefault(),o()?t("text/plain",l)||t("text/html",s):t("text/html",s)||t("text/plain",l))}):e.ie?r.on("init",function(){var e=r.dom;r.dom.bind(r.getBody(),"paste",function(t){var n;if(t.preventDefault(),o()&&e.doc.dataTransfer)return l(e.doc.dataTransfer.getData("Text")),void 0;var i=c();e.bind(i,"paste",function(e){e.stopPropagation(),n=!0});var a=r.selection.getRng(),d=e.doc.body.createTextRange();if(d.moveToElementText(i.firstChild),d.execCommand("Paste"),u(),!n)return r.windowManager.alert("Clipboard access not possible."),void 0;var p=i.firstChild.innerHTML;r.selection.setRng(a),s(p)})}):(r.on("init",function(){r.dom.bind(r.getBody(),"paste",function(e){e.preventDefault(),r.windowManager.alert("Please use Ctrl+V/Cmd+V keyboard shortcuts to paste contents.")})}),r.on("keydown",function(e){if(n.metaKeyPressed(e)&&86==e.keyCode&&!e.isDefaultPrevented()){var t=c(),i=r.selection.getRng();r.selection.select(t,!0),r.dom.bind(t,"paste",function(e){e.stopPropagation(),setTimeout(function(){u(),r.lastRng=i,r.selection.setRng(i),s(t.firstChild.innerHTML)},0)})}})),r.paste_block_drop&&r.on("dragend dragover draggesture dragdrop drop drag",function(e){e.preventDefault(),e.stopPropagation()}),this.paste=s,this.pasteText=l}}),i(p,[u,f,g,m,v],function(e,t,n,i,r){return function(o){var a=e.each;o.on("PastePreProcess",function(s){function l(e){a(e,function(e){d=e.constructor==RegExp?d.replace(e,""):d.replace(e[0],e[1])})}function c(e){function t(e,t,a,s){var l=e._listLevel||o;l!=o&&(o>l?n&&(n=n.parent.parent):(i=n,n=null)),n&&n.name==a?n.append(e):(i=i||n,n=new r(a,1),s>1&&n.attr("start",""+s),e.wrap(n)),e.name="li",t.value="";var c=t.next;c&&3==c.type&&(c.value=c.value.replace(/^\u00a0+/,"")),l>o&&i.lastChild.append(n),o=l}for(var n,i,o=1,a=e.getAll("p"),s=0;s<a.length;s++)if(e=a[s],"p"==e.name&&e.firstChild){for(var l="",c=e.firstChild;c&&!(l=c.value);)c=c.firstChild;if(/^\s*[\u2022\u00b7\u00a7\u00d8o\u25CF]\s*$/.test(l)){t(e,c,"ul");continue}if(/^\s*\w+\./.test(l)){var u=/([0-9])\./.exec(l),d=1;u&&(d=parseInt(u[1],10)),t(e,c,"ol",d);continue}n=null}}function u(t,n){if("p"===t.name){var i=/mso-list:\w+ \w+([0-9]+)/.exec(n);i&&(t._listLevel=parseInt(i[1],10))}if(o.getParam("paste_retain_style_properties","none")){var r="";if(e.each(o.dom.parseStyle(n),function(e,t){switch(t){case"horiz-align":return t="text-align",void 0;case"vert-align":return t="vertical-align",void 0;case"font-color":case"mso-foreground":return t="color",void 0;case"mso-background":case"mso-highlight":t="background"}("all"==p||f&&f[t])&&(r+=t+":"+e+";")}),r)return r}return null}var d=s.content,p,f;if(p=o.settings.paste_retain_style_properties,p&&(f=e.makeMap(p)),o.settings.paste_enable_default_filters!==!1&&/class="?Mso|style="[^"]*\bmso-|style='[^'']*\bmso-|w:WordDocument/i.test(s.content)){s.wordContent=!0,l([/<!--[\s\S]+?-->/gi,/<(!|script[^>]*>.*?<\/script(?=[>\s])|\/?(\?xml(:\w+)?|img|meta|link|style|\w:\w+)(?=[\s\/>]))[^>]*>/gi,[/<(\/?)s>/gi,"<$1strike>"],[/&nbsp;/gi,"\xa0"],[/<span\s+style\s*=\s*"\s*mso-spacerun\s*:\s*yes\s*;?\s*"\s*>([\s\u00a0]*)<\/span>/gi,function(e,t){return t.length>0?t.replace(/./," ").slice(Math.floor(t.length/2)).split("").join("\xa0"):""}]]);var g=new n({valid_elements:"@[style],-strong/b,-em/i,-span,-p,-ol,-ul,-li,-h1,-h2,-h3,-h4,-h5,-h6,-table,-tr,-td[colspan|rowspan],-th,-thead,-tfoot,-tbody,-a[!href]"}),m=new t({},g);m.addAttributeFilter("style",function(e){for(var t=e.length,n;t--;)n=e[t],n.attr("style",u(n,n.attr("style"))),"span"!=n.name||n.attributes.length||n.unwrap()});var v=m.parse(d);c(v),s.content=new i({},g).serialize(v)}})}}),i(h,[c,u],function(e,t){return function(n){function i(e){n.on("PastePreProcess",function(t){t.content=e(t.content)})}function r(e,n){return t.each(n,function(t){e=t.constructor==RegExp?e.replace(t,""):e.replace(t[0],t[1])}),e}function o(e){return e=r(e,[/^[\s\S]*<!--StartFragment-->|<!--EndFragment-->[\s\S]*$/g,[/<span class="Apple-converted-space">\u00a0<\/span>/g,"\xa0"],/<br>$/])}function a(e){if(!s){var i=[];t.each(n.schema.getBlockElements(),function(e,t){i.push(t)}),s=new RegExp("(?:<br>&nbsp;[\\s\\r\\n]+|<br>)*(<\\/?("+i.join("|")+")[^>]*>)(?:<br>&nbsp;[\\s\\r\\n]+|<br>)*","g")}return e=r(e,[[s,"$1"]]),e=r(e,[[/<br><br>/g,"<BR><BR>"],[/<br>/g," "],[/<BR><BR>/g,"<br>"]])}var s;e.webkit&&i(o),e.ie&&i(a)}}),i(b,[y,l,p,h],function(e,t,n,i){e.add("paste",function(e){var r=this;r.clipboard=new t(e),r.quirks=new i(e),r.wordFilter=new n(e),e.addCommand("mceInsertClipboardContent",function(e,t){t.content&&r.clipboard.paste(t.content),t.text&&r.clipboard.pasteText(t.text)})})}),a([l,p,h,b])}(this);