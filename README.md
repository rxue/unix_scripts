# Bash
[Bash Beginners Guide](http://www.tldp.org/LDP/Bash-Beginners-Guide/Bash-Beginners-Guide.pdf)

## Convention:
When referencing a variable, surround its name with curly braces to clarify to the parser and to human readers where the variable name stops and other text begins; for example, `${etcdir}` instead of just `$etcdir`

There's no standard convention for the naming of shell variables, but all-caps names typically suggest environment variables or variables read from global configuration files. More often than not, local variable are all-lowercase with components separated by unserscores.

<sub>Ref: UNIX AND LINUX SYSTEM ADMINISTRATION HANDBOOK (4th edition) > Chapter 2 Scripting and the Shell > Shell basics > Variables and quoting (P/33)</sub>

### configure_my_debian.sh
\# `bash configure_my_debian.sh`
   
FAQ:
----
* How to check the distribution version of your current Linux: `lsb_release -a` 
* How to get running script directory: ``$(cd `dirname $0` && pwd)``
 
