tinyMCEPopup.requireLangPack();

function getFrameByName(name) {
  for (var i = 0; i < frames.length; i++)
    if (frames[i].name == name)
      return frames[i];

  return null;
}

/* Same as the one defined in OpenJS */
function uploadDone(name) {
   var frame = getFrameByName(name);
   if (frame) {
     ret = frame.document.getElementsByTagName("body")[0].innerHTML;

     /* If we got JSON, try to inspect it and display the result */
     if (ret.length) {
       /* Convert from JSON to Javascript object */
       var json = eval("("+ret+")");
      console.log(json["image"]["url"]);
      tinyMCE.execCommand('mceInsertContent',false,'<br><img src=\'' + json["image"]["url"] + '\' />');
      tinyMCEPopup.close();
     }
  }
}
 

var UploadimageDialog = {
	init : function() {
		var f = document.forms[0];
	},

	insert : function() {
		// Insert the contents from the input into the document
		document.forms[0].submit();
	}
};

tinyMCEPopup.onInit.add(UploadimageDialog.init, UploadimageDialog);
