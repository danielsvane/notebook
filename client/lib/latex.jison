/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%%

// Varibles numbers and constants
([0-9]*\.{0,1}[0-9]+)   { return 'NUMBER'; }
(\w[a-zA-Z0-9_]*)       { return 'VAR'; }
("\\alpha")      { return 'VAR'; }
("\\beta")       { return 'VAR'; }
("\\chi")        { return 'VAR'; }
("\\delta")      { return 'VAR'; }
("\\epsilon")    { return 'VAR'; }
("\\varepsilon") { return 'VAR'; }
("\\eta")        { return 'VAR'; }
("\\gamma")      { return 'VAR'; }
("\\iota")       { return 'VAR'; }
("\\kappa")      { return 'VAR'; }
("\\lambda")     { return 'VAR'; }
("\\mu")         { return 'VAR'; }
("\\nu")         { return 'VAR'; }
("\\omega")      { return 'VAR'; }
("\\phi")        { return 'VAR'; }
("\\varphi")     { return 'VAR'; }
("\\pi")         { return 'VAR'; }
("\\psi")        { return 'VAR'; }
("\\rho")        { return 'VAR'; }
("\\sigma")      { return 'VAR'; }
("\\tau")        { return 'VAR'; }
("\\theta")      { return 'VAR'; }
("\\upsilon")    { return 'VAR'; }
("\\xi")         { return 'VAR'; }
("\\zeta")       { return 'VAR'; }
("\\Delta")      { return 'VAR'; }
("\\Gamma")      { return 'VAR'; }
("\\Lambda")     { return 'VAR'; }
("\\Omega")      { return 'VAR'; }
("\\Phi")        { return 'VAR'; }
("\\Pi")         { return 'VAR'; }
("\\Psi")        { return 'VAR'; }
("\\Sigma")      { return 'VAR'; }
("\\Theta")      { return 'VAR'; }
("\\Upsilon")    { return 'VAR'; }
("\\Xi")         { return 'VAR'; }
("\\aleph")      { return 'VAR'; }
("\\beth")       { return 'VAR'; }
("\\daleth")     { return 'VAR'; }
("\\gimel")      { return 'VAR'; }
("e")                   { return 'CONST'; }
("\\pi")                { return 'CONST'; }
// Basic operators
("+")                   { return 'ADD'; }
("-")                   { return 'SUB'; }
("\\pm")                { return 'ADDSUB'; }
("*")                   { return 'MUL'; }
("\\times")             { return 'MUL'; }
("\\cdot")              { return 'MUL'; }
("/")                   { return 'DIV'; }
("\\div")               { return 'DIV'; }
("\\frac")              { return 'FRAC'; }
("\\mod")               { return 'MOD'; }
// Exponential stuff
("\\sqrt")              { return 'SQRT'; }
("^")                   { return 'POW'; }
("\\ln")                { return 'LN'; }
("\\log_")              { return 'LOGBASE'; }
("\\log")               { return 'LOG10'; }
// Trig functions 
("\\sin")               { return 'SIN'; }
("\\cos")               { return 'COS'; }
("\\tan")               { return 'TAN'; }
("\\arcsin")            { return 'ARCSIN'; }
("\\arccos")            { return 'ARCCOS'; }
("\\arctan")            { return 'ARCTAN'; }
("\\csc")               { return 'CSC'; }
("\\sec")               { return 'SEC'; }
("\\cot")               { return 'COT'; }
// Brackets 
("||")                  { return 'MAGNITUDE'; }
("|")                   { return 'ABS'; }
("(")                   { return 'LPAREN'; }
("{")                   { return 'LCURLY'; }
("[")                   { return 'LSQUARE'; }
("\\lceil")             { return 'LCEIL'; }
("\\lfloor")            { return 'LFLOOR'; }
(")")                   { return 'RPAREN'; }
("}")                   { return 'RCURLY'; }
("]")                   { return 'RSQUARE'; }
("\\rceil")             { return 'RCEIL'; }
("\\rfloor")            { return 'RFLOOR'; }
("\\left")              {  }
("\\right")             {  }
// Logic stuff
("\\sim")               {return 'NOT';}
("\\wedge")             {return 'AND';}
("\\vee")               {return 'OR';}
("\\to")                {return 'IFTHEN';}
("\\leftrightarrow")    {return 'IFTHEN';}
("\\Rightarrow")        {return 'IFTHEN';}
("\\Leftrightarrow")    {return 'IFTHEN';}
("=")                   {return 'EQUAL';}
("\\equiv")             {return 'EQUAL';}
("\\ne")                {return 'NOT_EQUAL';}
("\\le")                {return 'LESS_EQUAL';}
("<=")                  {return 'LESS_EQUAL';}
("<")                   {return 'LT';}
("\\ge")                {return 'GREAT_EQUAL';}
(">=")                  {return 'GREAT_EQUAL';}
(">")                   {return 'GT';}
// Summation and product
("_")                   {return 'UNDERSCORE';}
("\\sum")               {return 'SUM';}

// Other stuff to ignore 
("$")                   {  }
(\s+)                   {  }
<<EOF>>                 { return 'EOF'; }

/lex

/* operator associations and precedence */

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
    | VAR
        {$$ = yytext;}
    | NUMBER
        {$$ = Number(yytext);}
    ;
