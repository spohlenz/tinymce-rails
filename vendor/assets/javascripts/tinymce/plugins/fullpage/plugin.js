/**
 * Copyright (c) Tiny Technologies, Inc. All rights reserved.
 * Licensed under the LGPL or a commercial license.
 * For LGPL see License.txt in the project root for license information.
 * For commercial licenses see https://www.tiny.cloud/
 *
 * Version: 5.8.1 (2021-05-20)
 */
!function(){"use strict";var s=function(e){var t=e;return{get:function(){return t},set:function(e){t=e}}},e=tinymce.util.Tools.resolve("tinymce.PluginManager"),u=function(){return(u=Object.assign||function(e){for(var t,n=1,l=arguments.length;n<l;n++)for(var i in t=arguments[n])Object.prototype.hasOwnProperty.call(t,i)&&(e[i]=t[i]);return e}).apply(this,arguments)},p=tinymce.util.Tools.resolve("tinymce.util.Tools"),t=tinymce.util.Tools.resolve("tinymce.html.DomParser"),m=tinymce.util.Tools.resolve("tinymce.html.Node"),f=tinymce.util.Tools.resolve("tinymce.html.Serializer"),h=function(e){return e.getParam("fullpage_hide_in_source_view")},i=function(e){return e.getParam("fullpage_default_encoding")},g=function(e){return e.getParam("fullpage_default_font_family")},y=function(e){return e.getParam("fullpage_default_font_size")},v=function(e){return t({validate:!1,root_name:"#document"}).parse(e,{format:"xhtml"})},d=function(l,i){var e,t,n,o,r,a,c,s=(e=l,t=i.get(),r=v(t),c=function(e,t){return e.attr(t)||""},(a={}).fontface=g(e),a.fontsize=y(e),7===(n=r.firstChild).type&&(a.xml_pi=!0,(o=/encoding="([^"]+)"/.exec(n.value))&&(a.docencoding=o[1])),(n=r.getAll("#doctype")[0])&&(a.doctype="<!DOCTYPE"+n.value+">"),(n=r.getAll("title")[0])&&n.firstChild&&(a.title=n.firstChild.value),p.each(r.getAll("meta"),function(e){var t,n=e.attr("name"),l=e.attr("http-equiv");n?a[n.toLowerCase()]=e.attr("content"):"Content-Type"===l&&(t=/charset\s*=\s*(.*)\s*/gi.exec(e.attr("content")))&&(a.docencoding=t[1])}),(n=r.getAll("html")[0])&&(a.langcode=c(n,"lang")||c(n,"xml:lang")),a.stylesheets=[],p.each(r.getAll("link"),function(e){"stylesheet"===e.attr("rel")&&a.stylesheets.push(e.attr("href"))}),(n=r.getAll("body")[0])&&(a.langdir=c(n,"dir"),a.style=c(n,"style"),a.visited_color=c(n,"vlink"),a.link_color=c(n,"link"),a.active_color=c(n,"alink")),a),d=u(u({},{title:"",keywords:"",description:"",robots:"",author:"",docencoding:""}),s);l.windowManager.open({title:"Metadata and Document Properties",size:"normal",body:{type:"panel",items:[{name:"title",type:"input",label:"Title"},{name:"keywords",type:"input",label:"Keywords"},{name:"description",type:"input",label:"Description"},{name:"robots",type:"input",label:"Robots"},{name:"author",type:"input",label:"Author"},{name:"docencoding",type:"input",label:"Encoding"}]},buttons:[{type:"cancel",name:"cancel",text:"Cancel"},{type:"submit",name:"save",text:"Save",primary:!0}],initialData:d,onSubmit:function(e){var t=e.getData(),n=function(e,o,t){var r,n,l=e.dom,i=function(e,t,n){e.attr(t,n||undefined)},a=function(e){s.firstChild?s.insert(e,s.firstChild):s.append(e)},c=v(t),s=c.getAll("head")[0];s||(r=c.getAll("html")[0],s=new m("head",1),r.firstChild?r.insert(s,r.firstChild,!0):r.append(s)),r=c.firstChild,o.xml_pi?(n='version="1.0"',o.docencoding&&(n+=' encoding="'+o.docencoding+'"'),7!==r.type&&(r=new m("xml",7),c.insert(r,c.firstChild,!0)),r.value=n):r&&7===r.type&&r.remove(),r=c.getAll("#doctype")[0],o.doctype?(r||(r=new m("#doctype",10),o.xml_pi?c.insert(r,c.firstChild):a(r)),r.value=o.doctype.substring(9,o.doctype.length-1)):r&&r.remove(),r=null,p.each(c.getAll("meta"),function(e){"Content-Type"===e.attr("http-equiv")&&(r=e)}),o.docencoding?(r||((r=new m("meta",1)).attr("http-equiv","Content-Type"),r.shortEnded=!0,a(r)),r.attr("content","text/html; charset="+o.docencoding)):r&&r.remove(),r=c.getAll("title")[0],o.title?(r?r.empty():(r=new m("title",1),a(r)),r.append(new m("#text",3)).value=o.title):r&&r.remove(),p.each("keywords,description,author,copyright,robots".split(","),function(e){for(var t,n=c.getAll("meta"),l=o[e],i=0;i<n.length;i++)if((t=n[i]).attr("name")===e)return void(l?t.attr("content",l):t.remove());l&&((r=new m("meta",1)).attr("name",e),r.attr("content",l),r.shortEnded=!0,a(r))});var d={};p.each(c.getAll("link"),function(e){"stylesheet"===e.attr("rel")&&(d[e.attr("href")]=e)}),p.each(o.stylesheets,function(e){d[e]||((r=new m("link",1)).attr({rel:"stylesheet",text:"text/css",href:e}),r.shortEnded=!0,a(r)),delete d[e]}),p.each(d,function(e){e.remove()}),(r=c.getAll("body")[0])&&(i(r,"dir",o.langdir),i(r,"style",o.style),i(r,"vlink",o.visited_color),i(r,"link",o.link_color),i(r,"alink",o.active_color),l.setAttribs(e.getBody(),{style:o.style,dir:o.dir,vLink:o.visited_color,link:o.link_color,aLink:o.active_color})),(r=c.getAll("html")[0])&&(i(r,"lang",o.langcode),i(r,"xml:lang",o.langcode)),s.firstChild||s.remove();var u=f({validate:!1,indent:!0,indent_before:"head,html,body,meta,title,script,link,style",indent_after:"head,html,body,meta,title,script,link,style"}).serialize(c);return u.substring(0,u.indexOf("</body>"))}(l,p.extend(s,t),i.get());i.set(n),e.close()}})},_=p.each,b=function(e){return e.replace(/<\/?[A-Z]+/g,function(e){return e.toLowerCase()})},x=function(e,t,n,l){var i,o,r,a,c,s,d,u,m,f="",g=e.dom;l.selection||(a=e.getParam("protect"),c=l.content,p.each(a,function(e){c=c.replace(e,function(e){return"\x3c!--mce:protected "+escape(e)+"--\x3e"})}),r=c,"raw"===l.format&&t.get()||l.source_view&&h(e)||(0!==r.length||l.source_view||(r=p.trim(t.get())+"\n"+p.trim(r)+"\n"+p.trim(n.get())),-1!==(i=(r=r.replace(/<(\/?)BODY/gi,"<$1body")).indexOf("<body"))?(i=r.indexOf(">",i),t.set(b(r.substring(0,i+1))),-1===(o=r.indexOf("</body",i))&&(o=r.length),l.content=p.trim(r.substring(i+1,o)),n.set(b(r.substring(o)))):(t.set(k(e)),n.set("\n</body>\n</html>")),s=v(t.get()),_(s.getAll("style"),function(e){e.firstChild&&(f+=e.firstChild.value)}),(d=s.getAll("body")[0])&&g.setAttribs(e.getBody(),{style:d.attr("style")||"",dir:d.attr("dir")||"",vLink:d.attr("vlink")||"",link:d.attr("link")||"",aLink:d.attr("alink")||""}),g.remove("fullpage_styles"),u=e.getDoc().getElementsByTagName("head")[0],f&&g.add(u,"style",{id:"fullpage_styles"}).appendChild(document.createTextNode(f)),m={},p.each(u.getElementsByTagName("link"),function(e){"stylesheet"===e.rel&&e.getAttribute("data-mce-fullpage")&&(m[e.href]=e)}),p.each(s.getAll("link"),function(e){var t=e.attr("href");if(!t)return!0;m[t]||"stylesheet"!==e.attr("rel")||g.add(u,"link",{rel:"stylesheet",text:"text/css",href:t,"data-mce-fullpage":"1"}),delete m[t]}),p.each(m,function(e){e.parentNode.removeChild(e)})))},k=function(e){var t,n="",l="";return e.getParam("fullpage_default_xml_pi")&&(n+='<?xml version="1.0" encoding="'+(i(e)||"ISO-8859-1")+'" ?>\n'),n+=e.getParam("fullpage_default_doctype","<!DOCTYPE html>"),n+="\n<html>\n<head>\n",(t=e.getParam("fullpage_default_title"))&&(n+="<title>"+t+"</title>\n"),(t=i(e))&&(n+='<meta http-equiv="Content-Type" content="text/html; charset='+t+'" />\n'),(t=g(e))&&(l+="font-family: "+t+";"),(t=y(e))&&(l+="font-size: "+t+";"),(t=e.getParam("fullpage_default_text_color"))&&(l+="color: "+t+";"),n+="</head>\n<body"+(l?' style="'+l+'"':"")+">\n"},C=function(e,t,n,l){"html"!==l.format||l.selection||l.source_view&&h(e)||(l.content=(p.trim(t)+"\n"+p.trim(l.content)+"\n"+p.trim(n)).replace(/<!--mce:protected ([\s\S]*?)-->/g,function(e,t){return unescape(t)}))};e.add("fullpage",function(e){var t,n,l,i,o,r,a=s(""),c=s("");n=a,(t=e).addCommand("mceFullPageProperties",function(){d(t,n)}),(l=e).ui.registry.addButton("fullpage",{tooltip:"Metadata and document properties",icon:"document-properties",onAction:function(){l.execCommand("mceFullPageProperties")}}),l.ui.registry.addMenuItem("fullpage",{text:"Metadata and document properties",icon:"document-properties",onAction:function(){l.execCommand("mceFullPageProperties")}}),o=a,r=c,(i=e).on("BeforeSetContent",function(e){x(i,o,r,e)}),i.on("GetContent",function(e){C(i,o.get(),r.get(),e)})})}();