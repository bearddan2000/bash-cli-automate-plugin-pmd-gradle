#! /bin/bash

function replace_readme_str() {
  #statements
  local file=$1/README.md
  local old=$2
  local new=$3

  perl -pi.bak -0 -e "s/${old}/${new}/" $file
  rm -f $1/README.md.bak
}

d=$1

case $d in
  *cucumber* )
    case $d in
      *jacoco* ) replace_readme_str $d "jacoco" "jacoco-pmd" ;;
      * ) replace_readme_str $d "cucumber" "cucumber-pmd" ;;
    esac
    ;;
    *jacoco* )
      case $d in
       *cucumber* ) replace_readme_str $d "cucumber" "cucumber-pmd" ;;
       * ) replace_readme_str $d "jacoco" "jacoco-pmd" ;;
      esac
      ;;
    *spock* ) replace_readme_str $d "spock" "spock-pmd" ;;
    *spring* ) replace_readme_str $d "spring" "spring-pmd" ;;
    * ) replace_readme_str $d "gradle" "gradle-pmd" ;;
esac

replace_readme_str $1 "- gradle" "- gradle\n\t- pmd"

replace_readme_str $1 "# Description\n" "# Description\nAnalyze source code for potential bugs.\n"
