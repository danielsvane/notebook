$(function() {

    // HTTP.post("http://aleph.sagemath.org/service?accepted_tos=true", {code: "print 1+2"}, function(req, res){
    //     console.log(req,res);
    // });

    $.post('http://aleph.sagemath.org/service?accepted_tos=true', {code: "print solve(x^2 + 3*x + 2, x)"}, function(data, lol,foo,bar) {
        console.log(data.stdout);
    });

    // var xmlhttp = new XMLHttpRequest();
    // var url = "http://aleph.sagemath.org/service?accepted_tos=true";

    // xmlhttp.onreadystatechange = function() {
    //     console.log(xmlhttp.responseText);
    // }

    // xmlhttp.open("POST", url, true);
    // xmlhttp.send("print 1+2");

    var canvas = document.getElementById("canvas");
    var result = document.getElementById("result");
    var latexDiv = document.getElementById("katex");
    var context = canvas.getContext("2d");
    var pointerId;

    var applicationKey = '9e5b9e3c-7ac4-4500-bf19-6bb08f7f517f';
    var hmacKey = '6d187bcd-017d-42b8-9f04-02363c5b1e6f';

    var stroker = new MyScript.InkManager();
    var mathRecognizer = new MyScript.MathRecognizer();
    var instanceId;

    $("#run").on("click", function(){
        doRecognition();
    });

    $("#clear").on("click", function(){
        stroker.clear();
        context.clearRect(0, 0, canvas.width, canvas.height);
    });

    function trim(string) {
        return string.replace(/ /g,'');
    }

    function doRecognition () {
        //console.log(mathRecognizer.doSimpleRecognition());
        mathRecognizer.doSimpleRecognition(applicationKey, instanceId, stroker.getStrokes(), hmacKey).then(
            function (data) {
                if (!instanceId) {
                    instanceId = data.getInstanceId();
                } else if (instanceId !== data.getInstanceId()) {
                    return;
                }
                var results = data.getMathDocument().getResultElements();

                for (var i in results) {
                    if (results[i] instanceof MyScript.MathLaTexResultElement) {
                        var latex = trim(results[i].value);

                        var formula = Jison.Parsers.latex.parse(latex);
                        console.log(latex);
                        console.log(formula);

                        katex.render(latex, latexDiv);

                        var exp = algebra.parse(formula);

                        console.log(exp.toString());

                    }
                }
            }
        )
    }

    canvas.addEventListener('pointerdown', function (event) {
        if (!pointerId) {
            pointerId = event.pointerId;
            event.preventDefault();

            context.beginPath();
            context.arc(event.offsetX, event.offsetY, 0.5, 0, 2*Math.PI, false);
            context.fill();
            context.closePath();

            stroker.startInkCapture(event.offsetX, event.offsetY);
        }
    }, false);

    canvas.addEventListener('pointermove', function (event) {
        if (pointerId === event.pointerId) {
            event.preventDefault();
            context.lineTo(event.offsetX, event.offsetY);
            context.stroke();

            stroker.continueInkCapture(event.offsetX, event.offsetY);
        }
    }, false);

    canvas.addEventListener('pointerup', function (event) {
        if (pointerId === event.pointerId) {
            event.preventDefault();

            context.lineTo(event.offsetX, event.offsetY);
            context.stroke();
            context.closePath();

            stroker.endInkCapture();
            pointerId = undefined;
        }
    }, false);

    canvas.addEventListener('pointerleave', function (event) {
        if (pointerId === event.pointerId) {
            event.preventDefault();

            context.lineTo(event.offsetX, event.offsetY);
            context.stroke();
            context.closePath();

            //mathRenderer.drawEnd(event.offsetX, event.offsetY, context);
            stroker.endInkCapture();
            pointerId = undefined;
        }
    }, false);
});