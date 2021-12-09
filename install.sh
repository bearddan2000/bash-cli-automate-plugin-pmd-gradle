#! /bin/bash

function build_docker_cmd() {
  #cucumber if present MUST be first command
  #it will overwrite the reports dir

  local file=$(pwd)/$1/Dockerfile
  local cmd="\"check\""

  case $d in
    *cucumber* )
      cmd="\"cucumber\", ${cmd}"
      case $d in
        *jacoco* ) cmd="${cmd}, \"jacocoTestReport\"" ;;
      esac ;;
      *jacoco* )
        case $d in
          *cucumber* )
            cmd="\"cucumber\", ${cmd}" ;;
        esac
        cmd="${cmd}, \"jacocoTestReport\"" ;;
    esac

    echo "CMD [${cmd}]" >> $file
}

for d in `ls -la | grep ^d | awk '{print $NF}' | egrep -v '^\.'`; do

  cat .src/install.sh > $(pwd)/$d/install.sh

  cat .src/Dockerfile > $(pwd)/$d/Dockerfile

  build_docker_cmd $d

  cat .src/plugin-1 $(pwd)/$d/bin/build.gradle .src/plugin-2 > $(pwd)/$d/bin/tmp-build.gradle

  mv $(pwd)/$d/bin/tmp-build.gradle $(pwd)/$d/bin/build.gradle

  cp -R .src/config $d/bin

  ./readme.sh $d

  ./folder.sh $d

done
