/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex

%{
    doSum = function(a, b){
        return a+'+'+b;
    };

    doSolve = function(left, right, solveFor){
        var sage = "from sagenb.misc.support import automatic_name_eval;";
        sage += "automatic_name_eval('"+left+"=="+right+"', globals());";
        sage += "print latex(solve("+left+"=="+right+","+solveFor+"))";
        return sage;
    }
%}

%%

// Varibles numbers and constants

// Units
("cm")           { return 'CENTIMETER'; }

([0-9]*\.{0,1}[0-9]+)   { return 'NUMBER'; }
(\w[a-zA-Z0-9_]*)       { return 'VAR'; }

// Logic stuff
("\\to")                {return 'IFTHEN';}
("\\leftrightarrow")    {return 'IFTHEN';}
("\\Rightarrow")        {return 'IFTHEN';}
("\\Leftrightarrow")    {return 'IFTHEN';}
("=")                   {return 'EQUAL';}
("\\equiv")             {return 'EQUAL';}

// Basic operators
("+")                   { return 'ADD'; }
("*")                   { return 'MUL'; }
("\\times")             { return 'MUL'; }
("\\cdot")              { return 'MUL'; }
("\\rightarrow")        {return 'IFTHEN';}
("\\left")              {  }
("\\right")             {  }


// Other stuff to ignore 
("$")                   {  }
(\s+)                   {  }
<<EOF>>                 { return 'EOF'; }

/lex

/* operator associations and precedence */

%left IFTHEN
%left EQUAL
%left ADD
%left CENTIMETER
%left VAR
%left MUL

%start expressions

%% /* language grammar */

expressions
    : e EOF
        {return $1;}
    ;

e
    : e MUL e
        {$$ = $1+"*"+$3;}
    | e EQUAL e IFTHEN e EQUAL
        {$$ = doSolve($1, $3, $5);}
    | e ADD e
        {$$ = doSum($1, $3);}
    | VAR EQUAL e
        {$$ = $1+"="+$3;}
    | e CENTIMETER
        {$$ = $1+"*units.length.centimeter";}
    | VAR
        {$$ = yytext;}
    | NUMBER
        {$$ = Number(yytext);}
    ;
