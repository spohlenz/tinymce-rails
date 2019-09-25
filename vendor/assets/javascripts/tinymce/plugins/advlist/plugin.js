/**
 * Copyright (c) Tiny Technologies, Inc. All rights reserved.
 * Licensed under the LGPL or a commercial license.
 * For LGPL see License.txt in the project root for license information.
 * For commercial licenses see https://www.tiny.cloud/
 *
 * Version: 5.0.16 (2019-09-24)
 */
!function(){"use strict";function n(){}function o(n){return function(){return n}}function t(){return d}var e,r=tinymce.util.Tools.resolve("tinymce.PluginManager"),u=tinymce.util.Tools.resolve("tinymce.util.Tools"),l=function(n,t,e){var r="UL"===t?"InsertUnorderedList":"InsertOrderedList";n.execCommand(r,!1,!1===e?null:{"list-style-type":e})},i=function(e){e.addCommand("ApplyUnorderedListStyle",function(n,t){l(e,"UL",t["list-style-type"])}),e.addCommand("ApplyOrderedListStyle",function(n,t){l(e,"OL",t["list-style-type"])})},c=function(n){var t=n.getParam("advlist_number_styles","default,lower-alpha,lower-greek,lower-roman,upper-alpha,upper-roman");return t?t.split(/[ ,]/):[]},s=function(n){var t=n.getParam("advlist_bullet_styles","default,circle,square");return t?t.split(/[ ,]/):[]},f=o(!1),a=o(!0),d=(e={fold:function(n,t){return n()},is:f,isSome:f,isNone:a,getOr:m,getOrThunk:p,getOrDie:function(n){throw new Error(n||"error: getOrDie called on none.")},getOrNull:o(null),getOrUndefined:o(undefined),or:m,orThunk:p,map:t,each:n,bind:t,exists:f,forall:a,filter:t,equals:g,equals_:g,toArray:function(){return[]},toString:o("none()")},Object.freeze&&Object.freeze(e),e);function g(n){return n.isNone()}function p(n){return n()}function m(n){return n}function y(n,t,e){var r=function(n,t){for(var e=0;e<n.length;e++){if(t(n[e]))return e}return-1}(t.parents,L),i=-1!==r?t.parents.slice(0,r):t.parents,o=u.grep(i,N(n));return 0<o.length&&o[0].nodeName===e}function O(n,t,e,r,i,o){0<o.length?function(e,n,t,r,i,o){e.ui.registry.addSplitButton(n,{tooltip:t,icon:"OL"===i?"ordered-list":"unordered-list",presets:"listpreview",columns:3,fetch:function(n){n(u.map(o,function(n){return{type:"choiceitem",value:"default"===n?"":n,icon:"list-"+("OL"===i?"num":"bull")+"-"+("disc"===n||"decimal"===n?"default":n),text:function(n){return n.replace(/\-/g," ").replace(/\b\w/g,function(n){return n.toUpperCase()})}(n)}}))},onAction:function(){return e.execCommand(r)},onItemAction:function(n,t){l(e,i,t)},select:function(t){return S(e).map(function(n){return t===n}).getOr(!1)},onSetup:function(t){function n(n){t.setActive(y(e,n,i))}return e.on("NodeChange",n),function(){return e.off("NodeChange",n)}}})}(n,t,e,r,i,o):function(e,n,t,r,i){e.ui.registry.addToggleButton(n,{active:!1,tooltip:t,icon:"OL"===i?"ordered-list":"unordered-list",onSetup:function(t){function n(n){t.setActive(y(e,n,i))}return e.on("NodeChange",n),function(){return e.off("NodeChange",n)}},onAction:function(){return e.execCommand(r)}})}(n,t,e,r,i)}var v=function(e){function n(){return i}function t(n){return n(e)}var r=o(e),i={fold:function(n,t){return t(e)},is:function(n){return e===n},isSome:a,isNone:f,getOr:r,getOrThunk:r,getOrDie:r,getOrNull:r,getOrUndefined:r,or:n,orThunk:n,map:function(n){return v(n(e))},each:function(n){n(e)},bind:t,exists:t,forall:t,filter:function(n){return n(e)?i:d},toArray:function(){return[e]},toString:function(){return"some("+e+")"},equals:function(n){return n.is(e)},equals_:function(n,t){return n.fold(f,function(n){return t(e,n)})}};return i},h=function(n){return null===n||n===undefined?d:v(n)},L=function(n){return n&&/^(TH|TD)$/.test(n.nodeName)},N=function(t){return function(n){return n&&/^(OL|UL|DL)$/.test(n.nodeName)&&function(n,t){return n.$.contains(n.getBody(),t)}(t,n)}},S=function(n){var t=n.dom.getParent(n.selection.getNode(),"ol,ul"),e=n.dom.getStyle(t,"listStyleType");return h(e)},T=function(n){O(n,"numlist","Numbered list","InsertOrderedList","OL",c(n)),O(n,"bullist","Bullet list","InsertUnorderedList","UL",s(n))};!function b(){r.add("advlist",function(n){var t,e,r;e="lists",r=(t=n).settings.plugins?t.settings.plugins:"",-1!==u.inArray(r.split(/[ ,]/),e)&&(T(n),i(n))})}()}();