<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.10.2" name="powerup" tilewidth="16" tileheight="16" tilecount="4" columns="4">
 <editorsettings>
  <export target="powerup.lua" format="lua"/>
 </editorsettings>
 <image source="object/powerup.png" width="64" height="16"/>
 <tile id="0">
  <properties>
   <property name="isAnimate" type="bool" value="true"/>
   <property name="scorePoints" type="int" value="30"/>
  </properties>
  <objectgroup draworder="index" id="2">
   <object id="1" x="2.56642" y="3.15455" width="10.6132" height="11.5221">
    <properties>
     <property name="isCollider" type="bool" value="true"/>
    </properties>
   </object>
  </objectgroup>
  <animation>
   <frame tileid="0" duration="170"/>
   <frame tileid="1" duration="170"/>
   <frame tileid="2" duration="170"/>
   <frame tileid="3" duration="170"/>
  </animation>
 </tile>
</tileset>
