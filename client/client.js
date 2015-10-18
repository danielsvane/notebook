$(function() {
    var canvas = document.getElementById("canvas");
    var result = document.getElementById("result");
    var latex = document.getElementById("katex");
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

    function doRecognition () {
        console.log(applicationKey, instanceId, stroker.getStrokes(), hmacKey);
        //console.log(mathRecognizer.doSimpleRecognition());
        mathRecognizer.doSimpleRecognition(applicationKey, instanceId, stroker.getStrokes(), hmacKey).then(
            function (data) {
                if (!instanceId) {
                    instanceId = data.getInstanceId();
                } else if (instanceId !== data.getInstanceId()) {
                    return;
                }
                var results = data.getMathDocument().getResultElements();

                console.log(data);

                for (var i in results) {
                    if (results[i] instanceof MyScript.MathLaTexResultElement) {
                        katex.render(results[i].getValue(), latex);

                        var exp = new algebra.parse(results[i].getValue());

                        console.log(exp.toString());

                    }
                }
            }
        )
    }

    canvas.addEventListener('pointerdown', function (event) {
        if (!pointerId) {
            console.log("down");
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
            console.log("move");
            event.preventDefault();
            context.lineTo(event.offsetX, event.offsetY);
            context.stroke();

            stroker.continueInkCapture(event.offsetX, event.offsetY);
        }
    }, false);

    canvas.addEventListener('pointerup', function (event) {
        if (pointerId === event.pointerId) {
            console.log("up");
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
            console.log("leave");
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