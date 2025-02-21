/**
 * TinyMCE version 7.7.0 (TBD)
 */
!function(){"use strict";var t=tinymce.util.Tools.resolve("tinymce.PluginManager");const e=(t,e,s)=>{const r="UL"===e?"InsertUnorderedList":"InsertOrderedList";t.execCommand(r,!1,!1===s?null:{"list-style-type":s})},s=t=>e=>e.options.get(t),r=s("advlist_number_styles"),n=s("advlist_bullet_styles"),l=t=>null==t,i=t=>!l(t);class o{constructor(t,e){this.tag=t,this.value=e}static some(t){return new o(!0,t)}static none(){return o.singletonNone}fold(t,e){return this.tag?e(this.value):t()}isSome(){return this.tag}isNone(){return!this.tag}map(t){return this.tag?o.some(t(this.value)):o.none()}bind(t){return this.tag?t(this.value):o.none()}exists(t){return this.tag&&t(this.value)}forall(t){return!this.tag||t(this.value)}filter(t){return!this.tag||t(this.value)?this:o.none()}getOr(t){return this.tag?this.value:t}or(t){return this.tag?this:t}getOrThunk(t){return this.tag?this.value:t()}orThunk(t){return this.tag?this:t()}getOrDie(t){if(this.tag)return this.value;throw new Error(null!=t?t:"Called getOrDie on None")}static from(t){return i(t)?o.some(t):o.none()}getOrNull(){return this.tag?this.value:null}getOrUndefined(){return this.value}each(t){this.tag&&t(this.value)}toArray(){return this.tag?[this.value]:[]}toString(){return this.tag?`some(${this.value})`:"none()"}}o.singletonNone=new o(!1);const a=Array.prototype.indexOf,u=Object.keys;var d=tinymce.util.Tools.resolve("tinymce.util.Tools");const c=t=>e=>i(e)&&t.test(e.nodeName),h=c(/^(OL|UL|DL)$/),g=c(/^(TH|TD)$/),p=t=>l(t)||"default"===t?"":t,m=(t,e)=>s=>((t,e)=>{const s=t.selection.getNode();return e({parents:t.dom.getParents(s),element:s}),t.on("NodeChange",e),()=>t.off("NodeChange",e)})(t,(r=>((t,r)=>{const n=t.selection.getStart(!0);s.setActive(((t,e,s)=>((t,e,s)=>{for(let e=0,n=t.length;e<n;e++){const n=t[e];if(h(r=n)&&!/\btox\-/.test(r.className))return o.some(n);if(s(n,e))break}var r;return o.none()})(e,0,g).exists((e=>e.nodeName===s&&((t,e)=>t.dom.isChildOf(e,t.getBody()))(t,e))))(t,r,e)),s.setEnabled(!((t,e)=>{const s=t.dom.getParent(e,"ol,ul,dl");return((t,e)=>null!==e&&!t.dom.isEditable(e))(t,s)||!t.selection.isEditable()})(t,n))})(t,r.parents))),v=(t,s,r,n,l,i)=>{const c={"lower-latin":"lower-alpha","upper-latin":"upper-alpha","lower-alpha":"lower-latin","upper-alpha":"upper-latin"},h=(g=t=>{return e=i,s=t,a.call(e,s)>-1;var e,s},((t,e)=>{const s={};return((t,e)=>{const s=u(t);for(let r=0,n=s.length;r<n;r++){const n=s[r];e(t[n],n)}})(t,((t,r)=>{const n=e(t,r);s[n.k]=n.v})),s})(c,((t,e)=>({k:e,v:g(t)}))));var g;t.ui.registry.addSplitButton(s,{tooltip:r,icon:"OL"===l?"ordered-list":"unordered-list",presets:"listpreview",columns:3,fetch:t=>{t(d.map(i,(t=>{const e="OL"===l?"num":"bull",s="disc"===t||"decimal"===t?"default":t,r=p(t),n=(t=>t.replace(/\-/g," ").replace(/\b\w/g,(t=>t.toUpperCase())))(t);return{type:"choiceitem",value:r,icon:"list-"+e+"-"+s,text:n}})))},onAction:()=>t.execCommand(n),onItemAction:(s,r)=>{e(t,l,r)},select:e=>{const s=(t=>{const e=t.dom.getParent(t.selection.getNode(),"ol,ul"),s=t.dom.getStyle(e,"listStyleType");return o.from(s)})(t);return s.exists((t=>e===t||c[t]===e&&!h[e]))},onSetup:m(t,l)})},y=(t,s,r,n,l,i)=>{i.length>1?v(t,s,r,n,l,i):((t,s,r,n,l,i)=>{t.ui.registry.addToggleButton(s,{active:!1,tooltip:r,icon:"OL"===l?"ordered-list":"unordered-list",onSetup:m(t,l),onAction:()=>t.queryCommandState(n)||""===i?t.execCommand(n):e(t,l,i)})})(t,s,r,n,l,p(i[0]))};t.add("advlist",(t=>{t.hasPlugin("lists")?((t=>{const e=t.options.register;e("advlist_number_styles",{processor:"string[]",default:"default,lower-alpha,lower-greek,lower-roman,upper-alpha,upper-roman".split(",")}),e("advlist_bullet_styles",{processor:"string[]",default:"default,circle,square".split(",")})})(t),(t=>{y(t,"numlist","Numbered list","InsertOrderedList","OL",r(t)),y(t,"bullist","Bullet list","InsertUnorderedList","UL",n(t))})(t),(t=>{t.addCommand("ApplyUnorderedListStyle",((s,r)=>{e(t,"UL",r["list-style-type"])})),t.addCommand("ApplyOrderedListStyle",((s,r)=>{e(t,"OL",r["list-style-type"])}))})(t)):console.error("Please use the Lists plugin together with the List Styles plugin.")}))}();