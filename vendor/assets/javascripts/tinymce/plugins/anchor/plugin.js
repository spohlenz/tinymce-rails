/**
 * TinyMCE version 6.1.0 (2022-06-29)
 */
!function(){"use strict";var e=tinymce.util.Tools.resolve("tinymce.PluginManager"),t=tinymce.util.Tools.resolve("tinymce.dom.RangeUtils"),n=tinymce.util.Tools.resolve("tinymce.util.Tools");const o=("allow_html_in_named_anchor",e=>e.options.get("allow_html_in_named_anchor"));const a="a:not([href])",r=e=>!e,i=e=>e.getAttribute("id")||e.getAttribute("name")||"",l=e=>(e=>e&&"a"===e.nodeName.toLowerCase())(e)&&!e.getAttribute("href")&&""!==i(e),s=e=>e.dom.getParent(e.selection.getStart(),a),c=(e,a)=>{const r=s(e);r?((e,t,n)=>{n.removeAttribute("name"),n.id=t,e.addVisual(),e.undoManager.add()})(e,a,r):((e,a)=>{e.undoManager.transact((()=>{o(e)||e.selection.collapse(!0),e.selection.isCollapsed()?e.insertContent(e.dom.createHTML("a",{id:a})):((e=>{const o=e.dom;t(o).walk(e.selection.getRng(),(e=>{n.each(e,(e=>{var t;l(t=e)&&!t.firstChild&&o.remove(e,!1)}))}))})(e),e.formatter.remove("namedAnchor",null,null,!0),e.formatter.apply("namedAnchor",{value:a}),e.addVisual())}))})(e,a),e.focus()},d=e=>(e=>e&&r(e.attr("href"))&&!r(e.attr("id")||e.attr("name")))(e)&&!e.firstChild,m=e=>t=>{for(let n=0;n<t.length;n++){const o=t[n];d(o)&&o.attr("contenteditable",e)}};e.add("anchor",(e=>{(e=>{(0,e.options.register)("allow_html_in_named_anchor",{processor:"boolean",default:!1})})(e),(e=>{e.on("PreInit",(()=>{e.parser.addNodeFilter("a",m("false")),e.serializer.addNodeFilter("a",m(null))}))})(e),(e=>{e.addCommand("mceAnchor",(()=>{(e=>{const t=(e=>{const t=s(e);return t?i(t):""})(e);e.windowManager.open({title:"Anchor",size:"normal",body:{type:"panel",items:[{name:"id",type:"input",label:"ID",placeholder:"example"}]},buttons:[{type:"cancel",name:"cancel",text:"Cancel"},{type:"submit",name:"save",text:"Save",primary:!0}],initialData:{id:t},onSubmit:t=>{((e,t)=>/^[A-Za-z][A-Za-z0-9\-:._]*$/.test(t)?(c(e,t),!0):(e.windowManager.alert("ID should start with a letter, followed only by letters, numbers, dashes, dots, colons or underscores."),!1))(e,t.getData().id)&&t.close()}})})(e)}))})(e),(e=>{e.ui.registry.addToggleButton("anchor",{icon:"bookmark",tooltip:"Anchor",onAction:()=>e.execCommand("mceAnchor"),onSetup:t=>e.selection.selectorChangedWithUnbind("a:not([href])",t.setActive).unbind}),e.ui.registry.addMenuItem("anchor",{icon:"bookmark",text:"Anchor...",onAction:()=>e.execCommand("mceAnchor")})})(e),e.on("PreInit",(()=>{(e=>{e.formatter.register("namedAnchor",{inline:"a",selector:a,remove:"all",split:!0,deep:!0,attributes:{id:"%value"},onmatch:(e,t,n)=>l(e)})})(e)}))}))}();