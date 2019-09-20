# docker-ionic-android-sdk
Docker image include Android SDK for building Ionic5 framework application.

[![Docker Build Status](https://img.shields.io/docker/cloud/build/chiticariu/ionic5.svg)](https://cloud.docker.com/repository/docker/chiticariu/ionic5)

## Example `.gitlab-ci` file
```Dockerfile
build_frontend_apk:
  stage: build_fe
  image: chiticariu/ionic5
  script:
    - "cd <Ionic Project Directory>"
    - "npm i -g npm-upgrade"
    - "npm install"
    - "mkdir www"
    - "yes | /opt/android-sdk/tools/bin/sdkmanager --licenses || true"
    - "ionic cordova build --release --prod android"
    - "cd ../.."
    - "mkdir publish_fe"
    - "cp <Ionic Project Directory>/platforms/android/app/build/outputs/apk/release/*.apk publish_fe/"
  artifacts:
    paths:
    - publish_fe/*.apk
  when: manual
```
## Extra helper command
If you want to run or build the ionic project in computer but doesn't have Android Studio, Android SDK or Ionic Framework and this computer installed Docker. You can use helper command  

- Restore npm package
```
Linux:    docker run --rm -v $(pwd):/myApp chiticariu/ionic5 npm install
Windows:  docker run --rm -v %cd%:/myApp chiticariu/ionic5 npm install
```
- Preview Ionic web app in your web browser
```
Linux:    docker run --rm -v $(pwd):/myApp -p 8100:8100 chiticariu/ionic5 ionic serve
Windows:  docker run --rm -v %cd%:/myApp -p 8100:8100 chiticariu/ionic5 ionic serve
```
- Build android apk output file
```
Linux:    docker run --rm -v $(pwd):/myApp chiticariu/ionic5 ionic cordova build android
Windows:  docker run --rm -v %cd%:/myApp chiticariu/ionic5 ionic cordova build android
```

References:

(https://github.com/Kusumoto/docker-ionic-android-sdk)
