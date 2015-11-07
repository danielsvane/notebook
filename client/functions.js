callSage = function(formula, latexDiv){
    if(latexDiv == undefined) latexDiv = document.getElementById("katex");

    $.post('http://aleph.sagemath.org/service?accepted_tos=true', {code: formula}, function(data) {
        console.log("Calculation result: ", data.stdout);
        katex.render(data.stdout, latexDiv);
    });

    // $.post('http://aleph.sagemath.org/service?accepted_tos=true', {code: "print latex("+formula+")"}, function(data) {
    //     console.log(data);
    //     console.log("Calculation result: ", data.stdout);
    //     katex.render(data.stdout, latexDiv);
    // });
}