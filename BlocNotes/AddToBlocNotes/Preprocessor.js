var MyPreprocessor = function() {};

MyPreprocessor.prototype = {
run: function(arguments) {
    var paragraphText = '';
    var elements = document.getElementsByTagName('p');
    
    for (var i = 0; i < elements.length; i++) {
        paragraphText += elements[i].textContent + "\n\n";
    }
    
    arguments.completionFunction({"URL": document.URL, "title": document.title, "selection": window.getSelection().toString(), "paragraphText": paragraphText});
}
};

var ExtensionPreprocessingJS = new MyPreprocessor;
