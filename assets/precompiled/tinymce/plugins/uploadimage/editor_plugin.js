(function(){tinymce.PluginManager.requireLangPack("uploadimage");tinymce.create("tinymce.plugins.uploadimagePlugin",{init:function(a,b){a.addCommand("mceuploadimage",function(){a.windowManager.open({file:b+"/dialog.htm",width:350+parseInt(a.getLang("uploadimage.delta_width",0)),height:140+parseInt(a.getLang("uploadimage.delta_height",0)),inline:1},{plugin_url:b,some_custom_arg:"custom arg"})});a.addButton("uploadimage",{title:"upload image",cmd:"mceuploadimage",image:b+"/img/uploadimage.gif"});a.onNodeChange.add(function(d,c,e){c.setActive("uploadimage",e.nodeName=="IMG")})},createControl:function(b,a){return null},getInfo:function(){return{longname:"uploadimage plugin",author:"Some author",authorurl:"http://tinymce.moxiecode.com",infourl:"http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/uploadimage",version:"1.0"}}});tinymce.PluginManager.add("uploadimage",tinymce.plugins.uploadimagePlugin)})();