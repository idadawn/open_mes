#!/bin/sh
exec java -Xms512m -Xmx512m \
  -Djava.security.egd=file:/dev/./urandom \
  -Djava.awt.headless=true \
  -Djava.awt.font.enableServerMode=true \
  -Dsun.java2d.d3d=false \
  -Dsun.java2d.ddscale=true \
  -Dmetaxk.captcha.enable=true \
  -jar /metaxk-mes-server/app.jar

