/**
 * TinyMCE version 6.8.5 (TBD)
 */
!function(){"use strict";var e=tinymce.util.Tools.resolve("tinymce.PluginManager");const n=("function",e=>"function"==typeof e);var o=tinymce.util.Tools.resolve("tinymce.dom.DOMUtils"),t=tinymce.util.Tools.resolve("tinymce.util.Tools");const a=e=>n=>n.options.get(e),c=a("save_enablewhendirty"),i=a("save_onsavecallback"),s=a("save_oncancelcallback"),r=(e,n)=>{e.notificationManager.open({text:n,type:"error"})},l=e=>n=>{const o=()=>{n.setEnabled(!c(e)||e.isDirty())};return o(),e.on("NodeChange dirty",o),()=>e.off("NodeChange dirty",o)};e.add("save",(e=>{(e=>{const n=e.options.register;n("save_enablewhendirty",{processor:"boolean",default:!0}),n("save_onsavecallback",{processor:"function"}),n("save_oncancelcallback",{processor:"function"})})(e),(e=>{e.ui.registry.addButton("save",{icon:"save",tooltip:"Save",enabled:!1,onAction:()=>e.execCommand("mceSave"),onSetup:l(e)}),e.ui.registry.addButton("cancel",{icon:"cancel",tooltip:"Cancel",enabled:!1,onAction:()=>e.execCommand("mceCancel"),onSetup:l(e)}),e.addShortcut("Meta+S","","mceSave")})(e),(e=>{e.addCommand("mceSave",(()=>{(e=>{const t=o.DOM.getParent(e.id,"form");if(c(e)&&!e.isDirty())return;e.save();const a=i(e);if(n(a))return a.call(e,e),void e.nodeChanged();t?(e.setDirty(!1),t.onsubmit&&!t.onsubmit()||("function"==typeof t.submit?t.submit():r(e,"Error: Form submit field collision.")),e.nodeChanged()):r(e,"Error: No form element found.")})(e)})),e.addCommand("mceCancel",(()=>{(e=>{const o=t.trim(e.startContent),a=s(e);n(a)?a.call(e,e):e.resetContent(o)})(e)}))})(e)}))}();